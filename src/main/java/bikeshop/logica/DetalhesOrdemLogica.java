package bikeshop.logica;

import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.OrdemServico;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DetalhesOrdemLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String idInformado = request.getParameter("id");
        Long idOrdem;

        try {
            if (idInformado == null
                    || !idInformado.matches("[0-9]+")) {
                throw new NumberFormatException();
            }

            idOrdem = Long.parseLong(idInformado);

            if (idOrdem <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Identificação da OS inválida.");
            return;
        }

        OrdemServicoDAO dao = new OrdemServicoDAO();

        OrdemServico ordem = dao.buscarDetalhesPorId(idOrdem);

        if (ordem == null) {
            response.sendError(
                HttpServletResponse.SC_NOT_FOUND, 
            		"OS não encontrada ou ainda não possui serviços realizados.");
            return;
        }

        request.setAttribute("ordem", ordem);

        request.getRequestDispatcher("/detalhes-ordem.jsp").forward(request, response);
    }
    
}//class DetalhesOrdemLogica.