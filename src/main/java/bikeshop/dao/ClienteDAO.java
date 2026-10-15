package bikeshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.postgresql.util.PSQLException;
import org.postgresql.util.ServerErrorMessage;

import bikeshop.excecao.CpfJaCadastradoException;
import bikeshop.jdbc.ConnectionFactory;
import bikeshop.modelo.Cliente;

public class ClienteDAO {
	
	//Vai ser chamado pela CadastroClienteLogica, recebendo o objeto de lá.
	public void adicionaCliente(Cliente cliente) {
		
		//Relembrando: ID é gerado automáticamente pelo banco.
		String sql = "INSERT INTO public.cliente("
				+ "cpf, nome, data_nascimento, email, telefone)"
				+ "	VALUES (?, ?, ?, ?, ?);";
		
		try (Connection connection = new ConnectionFactory().getConnection()) {
			
			PreparedStatement preparedStatement = connection.prepareStatement(sql);
			
			preparedStatement.setString(1, cliente.getCpf());
			preparedStatement.setString(2, cliente.getNome());
			preparedStatement.setObject(3, cliente.getDataNascimento());
			preparedStatement.setString(4, cliente.getEmail());
			preparedStatement.setString(5, cliente.getTelefone());
			
			preparedStatement.executeUpdate();
			
		} catch (SQLException e) {

			//O código 23505 informa quando a violação de unicidade.
		    if ("23505".equals(e.getSQLState()) && e instanceof PSQLException) {

		        PSQLException erroPostgres = (PSQLException) e;

		        ServerErrorMessage detalhes = erroPostgres.getServerErrorMessage();

		        //uc_cpf é nome dado a restrição no SQL.
		        if (detalhes != null && "uc_cpf".equals(detalhes.getConstraint())) {

		            throw new CpfJaCadastradoException(e);
		        }
		    }

		    throw new RuntimeException("Erro ao cadastrar cliente.", e);
		}
	}
	
	//Parei aqui: metodo listarclientes.
	/**
	 * Retorna uma lista com todos os registros da tabela.
	 * @return
	 * @throws SQLException 
	 */
	
	public List<Cliente> listaCliente() throws SQLException {
		
		String sql = "SELECT * FROM public.cliente ORDER BY nome, id;";
		
		try (Connection connection = new ConnectionFactory().getConnection()) {
		
			PreparedStatement preparedStatement = connection.prepareStatement(sql);
			ResultSet resultSet = preparedStatement.executeQuery();
			
			return extraiResultSet(resultSet);
			
		} catch (SQLException e) {
			throw new RuntimeException("Erro ao listar clientes", e);
		}
				
	}

	public List<Cliente> extraiResultSet(ResultSet resultSet) throws SQLException {
		
		List<Cliente> clienteList = new ArrayList<>();
		
		while (resultSet.next()) {
			
			Cliente cliente = new Cliente();

			//Os nomes aqui são os mesmos das tabelas do SGBD.
			cliente.setCpf(resultSet.getString("cpf"));
			cliente.setNome(resultSet.getString("nome"));
			cliente.setEmail(resultSet.getString("email"));
			cliente.setTelefone(resultSet.getString("telefone"));
			cliente.setDataNascimento(resultSet.getDate("data_nascimento").toLocalDate());
			
			clienteList.add(cliente);
		}

		return clienteList;
		
	}
	
}//class ClienteDAO.
