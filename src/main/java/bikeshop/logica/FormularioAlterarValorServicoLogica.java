package bikeshop.logica;

import bikeshop.dao.ServicoDAO;
import bikeshop.modelo.Servico;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class FormularioAlterarValorServicoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String idInformado = request.getParameter("id");

        Long id;

        try {
        	
            if (idInformado == null || idInformado.isBlank()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Informe o ID do serviço.");
                return;
            }

            id = Long.valueOf(idInformado.strip());

            if (id <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do serviço inválido.");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do serviço inválido.");
            return;
        }

        ServicoDAO dao = new ServicoDAO();

        Servico servico = dao.buscarPorId(id);

        if (servico == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Serviço não encontrado.");
            return;
        }

        request.setAttribute("servico", servico);

        request.getRequestDispatcher("/alterar-valor-servico.jsp").forward(request, response);
    }
    
}//FormularioAlterarValorServicoLogica