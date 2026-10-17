package bikeshop.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.util.PSQLException;
import org.postgresql.util.ServerErrorMessage;

import bikeshop.excecao.NomeServicoJaCadastradoException;
import bikeshop.jdbc.ConnectionFactory;
import bikeshop.modelo.Servico;

public class ServicoDAO {

    public void adicionaServico(Servico servico) {

        String sql = """
            INSERT INTO public.servico (nome, valor)
            VALUES (?, ?)
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
            
        	PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, servico.getNome());
            preparedStatement.setBigDecimal(2, servico.getValor());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {

            if ("23505".equals(e.getSQLState()) && e instanceof PSQLException) {

                PSQLException erroPostgres = (PSQLException) e;

                ServerErrorMessage detalhes = erroPostgres.getServerErrorMessage();

                if (detalhes != null && "uc_nome_servico".equals(detalhes.getConstraint())) {

                    throw new NomeServicoJaCadastradoException(e);
                }
            }

            throw new RuntimeException("Erro ao cadastrar serviço.", e);
        }
    }
    
    public List<Servico> listaServicos() {

        String sql = """
            SELECT id, nome, valor
            FROM public.servico
            ORDER BY nome, id
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
             
        	PreparedStatement preparedStatement = connection.prepareStatement(sql);
            ResultSet resultSet = preparedStatement.executeQuery()) {

            return extraiResultSet(resultSet);

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar serviços.", e);
        }
    }
    
    private List<Servico> extraiResultSet(ResultSet resultSet) throws SQLException {

        List<Servico> servicos = new ArrayList<>();

        while (resultSet.next()) {

            Servico servico = new Servico();

            servico.setId(resultSet.getLong("id"));
            servico.setNome(resultSet.getString("nome"));
            servico.setValor(resultSet.getBigDecimal("valor"));

            servicos.add(servico);
        }

        return servicos;
    }
    
    public Servico buscarPorId(Long id) {

        String sql = """
            SELECT id, nome, valor
            FROM public.servico
            WHERE id = ?
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setLong(1, id);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                List<Servico> servicos = extraiResultSet(resultSet);

                if (servicos.isEmpty()) {
                    return null;
                }

                return servicos.get(0);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar serviço por ID.", e);
        }
    }
    
    public boolean alterarValor(Long id, BigDecimal valor) {

        String sql = """
            UPDATE public.servico
            SET valor = ?
            WHERE id = ?
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setBigDecimal(1, valor);
            preparedStatement.setLong(2, id);

            int registrosAlterados = preparedStatement.executeUpdate();

            return registrosAlterados == 1;

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao alterar valor do serviço.", e);
        }
    }
    
    
    
    
    
}//class ServicoDAO.