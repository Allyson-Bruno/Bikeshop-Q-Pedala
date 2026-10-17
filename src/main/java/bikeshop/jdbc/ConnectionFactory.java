package bikeshop.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

    public Connection getConnection() {

        String url = System.getenv("BIKESHOP_DB_URL");
        String usuario = System.getenv("BIKESHOP_DB_USER");
        String senha = System.getenv("BIKESHOP_DB_PASSWORD");

        if (url == null || url.isBlank() || usuario == null || usuario.isBlank() || 
        		senha == null || senha.isBlank()) {

            throw new IllegalStateException("Configure as variáveis BIKESHOP_DB_URL, "
            		+ "BIKESHOP_DB_USER e BIKESHOP_DB_PASSWORD.");
        }

        try {
        	
            Class.forName("org.postgresql.Driver");

            return DriverManager.getConnection(url, usuario, senha);

        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver do PostgreSQL não encontrado.", e);

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao conectar ao banco de dados.", e);
        }
    }
    
}//class ConnectionFactory