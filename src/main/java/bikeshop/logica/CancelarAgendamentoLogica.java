package bikeshop.logica;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import bikeshop.dao.OrdemServicoDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CancelarAgendamentoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Allow", "POST");
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        String idInformado = request.getParameter("id");
        String dataInformada = request.getParameter("data");
        String modo = request.getParameter("modo");

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

        // Valida os filtros antes de realizar o cancelamento.
        LocalDate data;

        try {
            if (dataInformada == null || dataInformada.isBlank()) {
                data = LocalDate.now();
            } else {
                data = LocalDate.parse(dataInformada);
            }

        } catch (DateTimeParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Data do filtro inválida.");
            return;
        }

        if (modo == null) {
            modo = "apartir";
        }

        if (!"apartir".equals(modo) && !"exata".equals(modo)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Modo de consulta inválido.");
            return;
        }

        OrdemServicoDAO dao = new OrdemServicoDAO();

        boolean cancelado = dao.cancelar(id);

        response.sendRedirect(request.getContextPath()
            + "/mvc?logica=ListarAgendamentosLogica"
            + "&data=" + data
            + "&modo=" + modo
            + "&cancelado=" + cancelado
        );
    }
    
}//class CancelarAgendamentoLogica