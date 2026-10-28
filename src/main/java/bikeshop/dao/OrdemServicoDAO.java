package bikeshop.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.postgresql.util.PSQLException;
import org.postgresql.util.ServerErrorMessage;

import bikeshop.excecao.BicicletaJaAgendadaException;
import bikeshop.jdbc.ConnectionFactory;
import bikeshop.modelo.Bicicleta;
import bikeshop.modelo.Cliente;
import bikeshop.modelo.ItemOrdemServico;
import bikeshop.modelo.OrdemServico;
import bikeshop.modelo.Servico;
import bikeshop.validacao.ExecucaoValidacao;

public class OrdemServicoDAO {

    public Long agendar(OrdemServico ordem) {

        if (ordem.getItens() == null || ordem.getItens().isEmpty()) {
            throw new IllegalArgumentException(
                "A OS precisa ter pelo menos um serviço."
            );
        }

        String sqlOrdem = """
            INSERT INTO public.ordem_servico (
                id_bicicleta, id_cliente, data_agendamento,
                status, desconto, valor_total
            )
            VALUES (?, ?, ?, 'AGENDADA', 0, 0)
            RETURNING id
            """;

        String sqlItem = """
            INSERT INTO public.item_ordem_servico (
                id_ordem_servico, id_servico, valor, executado
            )
            VALUES (?, ?, NULL, FALSE)
            """;

        try (Connection connection = new ConnectionFactory().getConnection()) {

            connection.setAutoCommit(false);

            try {

                Long idOrdem;

                // Primeiro, insere a OS e recupera seu ID.
                try (PreparedStatement statementOrdem = connection.prepareStatement(sqlOrdem)) {

                    statementOrdem.setLong(1, ordem.getBicicleta().getId());
                    
                    statementOrdem.setLong(2, ordem.getCliente().getId());
                    
                    statementOrdem.setObject(3, ordem.getDataAgendamento());

                    try (ResultSet resultSet = statementOrdem.executeQuery()) {

                        if (!resultSet.next()) {
                            throw new SQLException(
                                "Não foi possível recuperar o ID da OS."
                            );
                        }

                        idOrdem = resultSet.getLong("id");
                    }
                }

                // Depois, insere os itens usando o ID da OS.
                try (PreparedStatement statementItem = connection.prepareStatement(sqlItem)) {

                    for (ItemOrdemServico item : ordem.getItens()) {

                        statementItem.setLong(1, idOrdem);
                        statementItem.setLong(2, item.getServico().getId());

                        statementItem.executeUpdate();
                    }
                }

                connection.commit();

                return idOrdem;

            } catch (SQLException | RuntimeException e) {

                try {
                    connection.rollback();

                } catch (SQLException erroRollback) {
                    e.addSuppressed(erroRollback);
                }

                throw e;
            }

         } catch (SQLException e) {

            if ("23505".equals(e.getSQLState()) && e instanceof PSQLException) {

                PSQLException erroPostgres = (PSQLException) e;

                ServerErrorMessage detalhes = erroPostgres.getServerErrorMessage();

                if (detalhes != null && "uq_bicicleta_agendamento".equals(detalhes.getConstraint())) {

                    throw new BicicletaJaAgendadaException(e);
                }
            }

            throw new RuntimeException("Erro ao agendar serviço.", e);
        }
    }
    
    public List<OrdemServico> listaAgendamentos(LocalDate data, boolean somenteNaData) {

        String sql = """
            SELECT os.id AS ordem_id,
                   os.data_agendamento,
                   os.status,
                   os.desconto,
                   os.valor_total,
                   c.id AS cliente_id,
                   c.nome AS cliente_nome,
                   c.cpf AS cliente_cpf,
                   b.id AS bicicleta_id,
                   b.marca,
                   b.modelo,
                   b.numero_serie,
                   i.id AS item_id,
                   i.valor AS item_valor,
                   i.executado,
                   s.id AS servico_id,
                   s.nome AS servico_nome,
                   s.valor AS servico_valor
            FROM public.ordem_servico os
            INNER JOIN public.cliente c ON c.id = os.id_cliente
            INNER JOIN public.bicicleta b ON b.id = os.id_bicicleta
            INNER JOIN public.item_ordem_servico i
                ON i.id_ordem_servico = os.id
            INNER JOIN public.servico s ON s.id = i.id_servico
            WHERE os.status = 'AGENDADA'
            """;

        if (somenteNaData) {
            sql += " AND os.data_agendamento = ?";
        } else {
            sql += " AND os.data_agendamento >= ?";
        }

        sql += " ORDER BY os.data_agendamento, os.id, i.id";

        try (Connection connection = new ConnectionFactory().getConnection();
             PreparedStatement preparedStatement =
                 connection.prepareStatement(sql)) {

            preparedStatement.setObject(1, data);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                return extraiAgendamentos(resultSet);
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                "Erro ao listar agendamentos pendentes.", e
            );
        }
    }
    
    private List<OrdemServico> extraiAgendamentos(ResultSet resultSet) throws SQLException {

    	//O LinkedHashMap preserva a ordem de inserção, mantendo a ordenação por data e ID definida no SQL. 
    	//No final, ordens.values() fornece as ordens agrupadas, convertidas para uma List.
        Map<Long, OrdemServico> ordens = new LinkedHashMap<>();

        while (resultSet.next()) {

            Long idOrdem = resultSet.getLong("ordem_id");

            OrdemServico ordem = ordens.get(idOrdem);

            // Cria a ordem somente na primeira linha desse ID.
            if (ordem == null) {

                ordem = new OrdemServico();

                ordem.setId(idOrdem);

                ordem.setDataAgendamento(
                    resultSet.getDate("data_agendamento").toLocalDate()
                );

                ordem.setStatus(resultSet.getString("status"));
                ordem.setDesconto(resultSet.getBigDecimal("desconto"));
                ordem.setValorTotal(resultSet.getBigDecimal("valor_total"));

                Cliente cliente = new Cliente();

                cliente.setId(resultSet.getLong("cliente_id"));
                cliente.setNome(resultSet.getString("cliente_nome"));
                cliente.setCpf(resultSet.getString("cliente_cpf"));

                ordem.setCliente(cliente);

                Bicicleta bicicleta = new Bicicleta();

                bicicleta.setId(resultSet.getLong("bicicleta_id"));
                bicicleta.setMarca(resultSet.getString("marca"));
                bicicleta.setModelo(resultSet.getString("modelo"));
                bicicleta.setNumeroSerie(resultSet.getString("numero_serie"));

                ordem.setBicicleta(bicicleta);

                ordens.put(idOrdem, ordem);
            }

            // Cada linha da consulta representa um item da ordem.
            Servico servico = new Servico();
            
            /*
             * Uma distintição importante:
             * item.servico.valor: preço atual do catálogo, usado como sugestão.
             * item.valor: valor histórico registrado na execução. 
             * Continua null enquanto o item não foi executado.
             * 
             */

            servico.setId(resultSet.getLong("servico_id"));
            servico.setNome(resultSet.getString("servico_nome"));
            servico.setValor(resultSet.getBigDecimal("servico_valor"));

            ItemOrdemServico item = new ItemOrdemServico();

            item.setId(resultSet.getLong("item_id"));
            item.setServico(servico);
            item.setValor(resultSet.getBigDecimal("item_valor"));
            item.setExecutado(resultSet.getBoolean("executado"));

            ordem.getItens().add(item);
        }

        return new ArrayList<>(ordens.values());
    }
    
    public boolean cancelar(Long id) {

        String sql = """
            UPDATE public.ordem_servico
            SET status = 'CANCELADA'
            WHERE id = ? AND status = 'AGENDADA'
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
             
        	PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setLong(1, id);

            int registrosAlterados = preparedStatement.executeUpdate();

            return registrosAlterados == 1;

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao cancelar agendamento.", e);
        }
    }
    
    public OrdemServico buscarAgendadaPorId(Long id) {

        String sql = """
            SELECT os.id AS ordem_id,
                   os.data_agendamento,
                   os.status,
                   os.desconto,
                   os.valor_total,
                   c.id AS cliente_id,
                   c.nome AS cliente_nome,
                   c.cpf AS cliente_cpf,
                   b.id AS bicicleta_id,
                   b.marca,
                   b.modelo,
                   b.numero_serie,
                   i.id AS item_id,
                   i.valor AS item_valor,
                   i.executado,
                   s.id AS servico_id,
                   s.nome AS servico_nome,
                   s.valor AS servico_valor
            FROM public.ordem_servico os
            INNER JOIN public.cliente c ON c.id = os.id_cliente
            INNER JOIN public.bicicleta b ON b.id = os.id_bicicleta
            INNER JOIN public.item_ordem_servico i
                ON i.id_ordem_servico = os.id
            INNER JOIN public.servico s ON s.id = i.id_servico
            WHERE os.id = ? AND os.status = 'AGENDADA'
            ORDER BY i.id
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
             
        	PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setLong(1, id);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                List<OrdemServico> ordens = extraiAgendamentos(resultSet);

                if (ordens.isEmpty()) {
                    return null;
                }

                return ordens.get(0);
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                "Erro ao buscar OS agendada por ID.", e
            );
        }
    }
    
    public boolean registrarExecucao(Long idOrdem, LocalDate dataExecucao, Map<Long, BigDecimal> valoresPorItem) {

        if (idOrdem == null || idOrdem <= 0) {
            throw new IllegalArgumentException("Informe uma OS válida.");
        }

        if (!ExecucaoValidacao.dataExecucaoValida(dataExecucao)) {
            throw new IllegalArgumentException(
                "Informe uma data de execução válida e que não seja futura."
            );
        }

        if (valoresPorItem == null || valoresPorItem.isEmpty()) {
            throw new IllegalArgumentException(
                "Selecione pelo menos um serviço realizado."
            );
        }

        for (Long idItem : valoresPorItem.keySet()) {
            if (idItem == null || idItem <= 0) {
                throw new IllegalArgumentException(
                    "Existe um item selecionado com identificação inválida."
                );
            }
        }

        // Valida os valores individuais e calcula o total no servidor.
        BigDecimal total = ExecucaoValidacao.calcularTotal(
            new ArrayList<>(valoresPorItem.values())
        );

        String sqlBuscarOrdem = """
            SELECT status
            FROM public.ordem_servico
            WHERE id = ?
            FOR UPDATE
            """;

        String sqlAtualizarItem = """
            UPDATE public.item_ordem_servico
            SET valor = ?, executado = TRUE
            WHERE id = ?
              AND id_ordem_servico = ?
              AND executado = FALSE
            """;

        String sqlAtualizarOrdem = """
            UPDATE public.ordem_servico
            SET data_execucao = ?,
                valor_total = ?,
                status = 'EXECUTADA'
            WHERE id = ?
              AND status = 'AGENDADA'
            """;

        try (Connection connection = new ConnectionFactory().getConnection()) {

            connection.setAutoCommit(false);

            try {

                // Bloqueia a OS durante esta transação.
                try (PreparedStatement statement = connection.prepareStatement(sqlBuscarOrdem)) {

                    statement.setLong(1, idOrdem);

                    try (ResultSet resultSet = statement.executeQuery()) {

                        if (!resultSet.next() || !"AGENDADA".equals(resultSet.getString("status"))) {

                            connection.rollback();
                            return false;
                        }
                    }
                }

                // Atualiza somente os itens selecionados.
                try (PreparedStatement statement = connection.prepareStatement(sqlAtualizarItem)) {

                    for (Map.Entry<Long, BigDecimal> entrada: valoresPorItem.entrySet()) {

                        statement.setBigDecimal(1, entrada.getValue().setScale(2));

                        statement.setLong(2, entrada.getKey());
                        statement.setLong(3, idOrdem);

                        int registrosAlterados = statement.executeUpdate();

                        if (registrosAlterados != 1) {
                            throw new IllegalArgumentException(
                                "Um dos itens selecionados não pertence à OS "
                                + "ou já foi executado.");
                        }
                    }
                }

                // Finaliza a OS após atualizar todos os itens selecionados.
                try (PreparedStatement statement = connection.prepareStatement(sqlAtualizarOrdem)) {

                    statement.setObject(1, dataExecucao);
                    statement.setBigDecimal(2, total);
                    statement.setLong(3, idOrdem);

                    int registrosAlterados = statement.executeUpdate();

                    if (registrosAlterados != 1) {
                        throw new SQLException("Não foi possível atualizar o status da OS.");
                    }
                }

                connection.commit();
                return true;

            } catch (SQLException | RuntimeException e) {

                try {
                    connection.rollback();

                } catch (SQLException erroRollback) {
                    e.addSuppressed(erroRollback);
                }

                throw e;
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao registrar a execução da OS.", e);
        }
    }
    
}//class OrdemServicoDAO.