package bikeshop.logica;

import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.OrdemServico;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class FormularioExecucaoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String idInformado = request.getParameter("id");
        Long id;

        if (idInformado == null || idInformado.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Informe o ID da OS.");
            return;
        }

        try {
            id = Long.valueOf(idInformado.strip());

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID da OS inválido.");
            return;
        }

        if (id <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID da OS inválido.");
            return;
        }

        OrdemServicoDAO dao = new OrdemServicoDAO();

        OrdemServico ordem = dao.buscarAgendadaPorId(id);

        if (ordem == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "OS não encontrada ou já não está agendada.");
            return;
        }

        request.setAttribute("ordem", ordem);

        request.getRequestDispatcher("/execucao-servico.jsp").forward(request, response);
    }
    
}//class FormularioExecucaoLogica