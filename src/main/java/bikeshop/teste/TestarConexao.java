package bikeshop.teste;

import java.sql.Connection;
import java.sql.SQLException;

import bikeshop.jdbc.ConnectionFactory;

public class TestarConexao {

	public static void main(String[] args) throws SQLException {

		Connection connection = new ConnectionFactory().getConnection();
		System.out.println("Conexão Estabelecida!");
		connection.close();
	}

}//class TestarConexao.
