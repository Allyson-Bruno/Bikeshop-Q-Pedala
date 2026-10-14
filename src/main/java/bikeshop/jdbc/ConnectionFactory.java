package bikeshop.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

	public Connection getConnection() {
		
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			throw new RuntimeException(e);
		}

		//Obviamente será alterado por questões de segurança.
		String url = "jdbc:postgresql://localhost/qpedalabikeshop";
		String user = "postgres";
		String password = "aluno";
		
		try {
			
			return DriverManager.getConnection(url, user, password);
			
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
	}
		
}//class ConnectionFactory.
	

