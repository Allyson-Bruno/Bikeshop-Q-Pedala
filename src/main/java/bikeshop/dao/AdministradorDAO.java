
package bikeshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import bikeshop.jdbc.ConnectionFactory;
import bikeshop.modelo.Administrador;

public class AdministradorDAO {

    public Administrador buscarPorUsuario(String usuario) {

    	//A busca pode ser feita pelo nome, dado que ele é único.
        String sql = "SELECT id, usuario, senha FROM administrador WHERE usuario = ?";

        //Facilita no fechamento da conexão.
        try (Connection connection = new ConnectionFactory().getConnection();

            PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, usuario);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                if (resultSet.next()) {
                	
                    Administrador administrador = new Administrador();
                    
                    administrador.setId(resultSet.getLong("id"));
                    administrador.setUsuario(resultSet.getString("usuario"));
                    administrador.setSenha(resultSet.getString("senha"));
                    
                    return administrador;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar administrador.", e);
        }

        return null;
    }
    
}//class AdministradorDAO.
