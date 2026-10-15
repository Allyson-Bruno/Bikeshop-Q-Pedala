package bikeshop.logica;

import java.util.List;

import bikeshop.dao.ClienteDAO;
import bikeshop.modelo.Cliente;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ListarClientesLogica implements Logica {

	@Override
	public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

		//Chama e DAO e encaminha para a JPS de listagem.
		ClienteDAO dao = new ClienteDAO();
		
		List<Cliente> cliente = dao.listaCliente();
		
		//Atributo que será usado para acessar a lista.
		request.setAttribute("clientes", cliente);
		
		request.getRequestDispatcher("/lista-clientes.jsp").forward(request, response);
	}

	
}//class ListarClientesLogica.
