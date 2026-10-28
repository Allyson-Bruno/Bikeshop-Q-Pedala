package bikeshop.logica;

import java.util.List;

import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.OrdemServico;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Funções dessa lógica:
 * 
 * 1. Consulta as OS com status EXECUTADA.
 * 2. Coloca a lista no atributo de requisição ordens, que a JSP acessará por ${ordens}.
 * 3. Encaminha a requisição para lista-pendentes-pagamento.jsp.
 */

public class ListarPendentesPagamentoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        OrdemServicoDAO dao = new OrdemServicoDAO();

        List<OrdemServico> ordens = dao.listaPendentesPagamento();

        request.setAttribute("ordens", ordens);

        request.getRequestDispatcher("/lista-pendentes-pagamento.jsp").forward(request, response);
    }
    
}//class ListarPendentesPagamentoLogica.