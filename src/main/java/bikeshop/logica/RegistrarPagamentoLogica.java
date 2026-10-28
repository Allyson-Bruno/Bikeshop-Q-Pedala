package bikeshop.logica;

import bikeshop.dao.OrdemServicoDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegistrarPagamentoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Allow", "POST");
            response.sendError(
                HttpServletResponse.SC_METHOD_NOT_ALLOWED
            );
            return;
        }

        String idInformado = request.getParameter("id");
        Long idOrdem;

        try {
            if (idInformado == null || !idInformado.matches("[0-9]+")) {
                throw new NumberFormatException();
            }

            idOrdem = Long.parseLong(idInformado);

            if (idOrdem <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Identificação da OS inválida."
            );
            return;
        }

        // Desmarcado: o navegador não envia esse parâmetro.
        // Marcado: deve enviar somente o valor "true".
        String[] opcoesDesconto = request.getParameterValues("aplicarDesconto");

        boolean aplicarDesconto = false;

        if (opcoesDesconto != null) {

            if (opcoesDesconto.length != 1 || !"true".equals(opcoesDesconto[0])) {

                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Opção de desconto inválida.");
                return;
            }

            aplicarDesconto = true;
        }

        OrdemServicoDAO dao = new OrdemServicoDAO();

        boolean registrado;

        try {
        	
            registrado = dao.registrarPagamento(idOrdem, aplicarDesconto);

        } catch (IllegalArgumentException e) {

            request.setAttribute("erro", e.getMessage());

            // Recarrega a OS e os valores de apresentação.
            // Essa lógica encaminha a requisição para pagamento.jsp.
            new FormularioPagamentoLogica().executa(request, response);

            return;
        }

        if (!registrado) {
            response.sendError(
                HttpServletResponse.SC_CONFLICT, 
                "A OS não existe ou já não está pendente de pagamento.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/mvc?logica=ListarPendentesPagamentoLogica&pago=true");
    }
}//class RegistrarPagamentoLogica.