package bikeshop.logica;

import java.math.BigDecimal;

import bikeshop.dao.ServicoDAO;
import bikeshop.modelo.Servico;
import bikeshop.validacao.ServicoValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AlterarValorServicoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Allow", "POST");
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        String idInformado = request.getParameter("id");
        Long id;

        if (idInformado == null || idInformado.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Informe o ID do serviço.");
            return;
        }

        try {
        	
            id = Long.valueOf(idInformado.strip());

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do serviço inválido.");
            return;
        }

        if (id <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do serviço inválido.");
            return;
        }

        ServicoDAO dao = new ServicoDAO();
        Servico servico = dao.buscarPorId(id);

        if (servico == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Serviço não encontrado.");
            return;
        }
        
        String valorInformado = request.getParameter("valor");

        BigDecimal valor = ServicoValidacao.converterValor(valorInformado);

        if (!ServicoValidacao.valorValido(valor)) {

            request.setAttribute(
                "erro",
                "Informe um valor entre 0 e 99999999,99, "
                + "sem frações menores que um centavo e sem "
                + "separador de milhar."
            );

            request.setAttribute("servico", servico);
            request.getRequestDispatcher("/alterar-valor-servico.jsp").forward(request, response);

            return;
        }

        boolean alterado = dao.alterarValor(id, valor.setScale(2));

        if (!alterado) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Serviço não encontrado para atualização.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/mvc?logica=ListarServicosLogica&alterado=true");
    }
    
}//class AlterarValorServicoLogica.