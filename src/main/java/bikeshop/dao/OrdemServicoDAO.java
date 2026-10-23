package bikeshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.postgresql.util.PSQLException;
import org.postgresql.util.ServerErrorMessage;

import bikeshop.excecao.BicicletaJaAgendadaException;
import bikeshop.jdbc.ConnectionFactory;
import bikeshop.modelo.ItemOrdemServico;
import bikeshop.modelo.OrdemServico;

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
    
}//class OrdemServicoDAO.