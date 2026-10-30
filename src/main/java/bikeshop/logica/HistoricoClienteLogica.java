package bikeshop.logica;

import java.util.List;

import bikeshop.dao.ClienteDAO;
import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.Cliente;
import bikeshop.modelo.OrdemServico;
import bikeshop.validacao.ClienteValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HistoricoClienteLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String cpfInformado = request.getParameter("cpf");

        // Primeiro acesso: abre a página sem realizar uma busca.
        if (cpfInformado == null) {
            request.getRequestDispatcher("/historico-cliente.jsp").forward(request, response);
            return;
        }

        String cpf = cpfInformado.strip();

        request.setAttribute("cpfBuscado", cpf);

        if (!ClienteValidacao.cpfValido(cpf)) {
            request.setAttribute("erro", "Informe um CPF válido com 11 números, sem pontuação.");

            request.getRequestDispatcher("/historico-cliente.jsp").forward(request, response);
            return;
        }

        ClienteDAO clienteDAO = new ClienteDAO();

        Cliente cliente = clienteDAO.buscarPorCpf(cpf);

        if (cliente == null) {
            request.setAttribute("erro", "Nenhum cliente encontrado com o CPF informado.");

            request.getRequestDispatcher("/historico-cliente.jsp").forward(request, response);
            return;
        }

        OrdemServicoDAO ordemDAO = new OrdemServicoDAO();

        List<OrdemServico> ordens = ordemDAO.listaHistoricoPorCliente(cliente.getId());

        request.setAttribute("cliente", cliente);
        request.setAttribute("ordens", ordens);

        request.getRequestDispatcher("/historico-cliente.jsp").forward(request, response);
    }
    
}//class HistoricoClienteLogica.