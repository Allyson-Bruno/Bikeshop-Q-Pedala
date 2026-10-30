package bikeshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.util.PSQLException;
import org.postgresql.util.ServerErrorMessage;

import bikeshop.excecao.NumeroSerieJaCadastradoException;
import bikeshop.jdbc.ConnectionFactory;
import bikeshop.modelo.Bicicleta;
import bikeshop.modelo.Cliente;

public class BicicletaDAO {

    public void adicionaBicicleta(Bicicleta bicicleta) {

        String sql = """
            INSERT INTO public.bicicleta (
                marca, modelo, tipo, tamanho_quadro,
                numero_serie, ano_fabricacao, id_proprietario
            )
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
          
        	PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, bicicleta.getMarca());
            preparedStatement.setString(2, bicicleta.getModelo());
            preparedStatement.setString(3, bicicleta.getTipo());
            preparedStatement.setString(4, bicicleta.getTamanhoQuadro());
            preparedStatement.setString(5, bicicleta.getNumeroSerie());
            preparedStatement.setShort(6, bicicleta.getAnoFabricacao());

            if (bicicleta.getProprietario() == null) {

            	//Não havendo cliente associado grava null. 
            	//Na tabela onde será listado será mostrado uma mensagem.
                preparedStatement.setNull(7, Types.BIGINT);

            } else {

                preparedStatement.setLong(7, bicicleta.getProprietario().getId());
            }

            preparedStatement.executeUpdate();

        } catch (SQLException e) {

            if ("23505".equals(e.getSQLState()) && e instanceof PSQLException) {

                PSQLException erroPostgres = (PSQLException) e;

                ServerErrorMessage detalhes = erroPostgres.getServerErrorMessage();

                if (detalhes != null && "uc_numero_serie".equals(detalhes.getConstraint())) {

                    throw new NumeroSerieJaCadastradoException(e);
                }
            }

            throw new RuntimeException("Erro ao cadastrar bicicleta.", e);
        }
    }
    
    public List<Bicicleta> listaBicicletas() {

    	/*
    	 * Motivo do uso do LEFT JOIN.
    	 * 
    	 * LEFT JOIN porque o proprietário é opcional:
    	 * Com proprietário: retorna a bicicleta e os dados do cliente.
    	 * Sem proprietário: retorna a bicicleta, com os dados do cliente como NULL.
    	 * Um INNER JOIN deixaria as bicicletas sem proprietário fora do resultado.
    	 * Se quiséssemos mostrar somente os dados da bicicleta e o ID do proprietário:
    	 * SELECT * FROM bicicleta seria suficiente
    	 * 
    	 */
    	
        String sql = """
            SELECT b.id, b.marca, b.modelo, b.tipo,
                   b.tamanho_quadro, b.numero_serie, b.ano_fabricacao,
                   c.id AS proprietario_id,
                   c.nome AS proprietario_nome,
                   c.cpf AS proprietario_cpf
            FROM public.bicicleta b
            LEFT JOIN public.cliente c ON c.id = b.id_proprietario
            ORDER BY b.marca, b.modelo, b.id
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
            
        	PreparedStatement preparedStatement = connection.prepareStatement(sql);
        	
        	ResultSet resultSet = preparedStatement.executeQuery()) {

            return extraiResultSet(resultSet);

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar bicicletas.", e);
        }
    }
    
    
    private List<Bicicleta> extraiResultSet(ResultSet resultSet) throws SQLException {

        List<Bicicleta> bicicletas = new ArrayList<>();

        while (resultSet.next()) {

            Bicicleta bicicleta = new Bicicleta();

            bicicleta.setId(resultSet.getLong("id"));
            bicicleta.setMarca(resultSet.getString("marca"));
            bicicleta.setModelo(resultSet.getString("modelo"));
            bicicleta.setTipo(resultSet.getString("tipo"));
            bicicleta.setTamanhoQuadro(resultSet.getString("tamanho_quadro"));
            bicicleta.setNumeroSerie(resultSet.getString("numero_serie"));
            bicicleta.setAnoFabricacao(resultSet.getShort("ano_fabricacao"));

            Long idProprietario = resultSet.getObject("proprietario_id", Long.class);

            if (idProprietario != null) {

                Cliente proprietario = new Cliente();

                proprietario.setId(idProprietario);
                proprietario.setNome(resultSet.getString("proprietario_nome"));
                proprietario.setCpf(resultSet.getString("proprietario_cpf"));

                bicicleta.setProprietario(proprietario);
            }

            bicicletas.add(bicicleta);
        }

        return bicicletas;
    }
    
    public List<Bicicleta> listaPorCliente(Long idCliente) {

        String sql = """
            SELECT b.id, b.marca, b.modelo, b.tipo,
                   b.tamanho_quadro, b.numero_serie, b.ano_fabricacao,
                   c.id AS proprietario_id,
                   c.nome AS proprietario_nome,
                   c.cpf AS proprietario_cpf
            FROM public.bicicleta b
            INNER JOIN public.cliente c ON c.id = b.id_proprietario
            WHERE b.id_proprietario = ?
            ORDER BY b.marca, b.modelo, b.id
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
        		
        	PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setLong(1, idCliente);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                return extraiResultSet(resultSet);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar bicicletas do cliente.", e);
        }
    }
    
    public Bicicleta buscarPorIdECliente(Long idBicicleta, Long idCliente) {

        String sql = """
            SELECT b.id, b.marca, b.modelo, b.tipo,
                   b.tamanho_quadro, b.numero_serie, b.ano_fabricacao,
                   c.id AS proprietario_id,
                   c.nome AS proprietario_nome,
                   c.cpf AS proprietario_cpf
            FROM public.bicicleta b
            INNER JOIN public.cliente c ON c.id = b.id_proprietario
            WHERE b.id = ? AND b.id_proprietario = ?
            """;

        try (Connection connection = new ConnectionFactory().getConnection();

        	PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setLong(1, idBicicleta);
            preparedStatement.setLong(2, idCliente);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                List<Bicicleta> bicicletas = extraiResultSet(resultSet);

                if (bicicletas.isEmpty()) {
                    return null;
                }

                return bicicletas.get(0);
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                "Erro ao buscar bicicleta do cliente.", e
            );
        }
    }
    
    public Bicicleta buscarPorNumeroSerie(String numeroSerie) {

        String sql = """
            SELECT b.id, b.marca, b.modelo, b.tipo,
                   b.tamanho_quadro, b.numero_serie, b.ano_fabricacao,
                   c.id AS proprietario_id,
                   c.nome AS proprietario_nome,
                   c.cpf AS proprietario_cpf
            FROM public.bicicleta b
            LEFT JOIN public.cliente c ON c.id = b.id_proprietario
            WHERE b.numero_serie = ?
            """;

        try (Connection connection = new ConnectionFactory().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, numeroSerie);

            try (ResultSet resultSet = statement.executeQuery()) {

                List<Bicicleta> bicicletas = extraiResultSet(resultSet);

                if (bicicletas.isEmpty()) {
                    return null;
                }

                return bicicletas.get(0);
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                "Erro ao buscar bicicleta pelo número de série.", e
            );
        }
    }
    
    
}//class BicicletaDAO