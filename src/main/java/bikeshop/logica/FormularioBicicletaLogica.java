package bikeshop.logica;

import java.util.List;

import bikeshop.dao.ClienteDAO;
import bikeshop.modelo.Cliente;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//Responsável por buscar os clientes e encaminhar para o cadastro-bicicleta.jsp
//O link precisa passar pela controladora para carregar os clientes antes de abrir a JSP.
public class FormularioBicicletaLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ClienteDAO dao = new ClienteDAO();

        List<Cliente> clientes = dao.listaCliente();

        request.setAttribute("clientes", clientes);

        request.getRequestDispatcher("/cadastro-bicicleta.jsp").forward(request, response);
    }
}