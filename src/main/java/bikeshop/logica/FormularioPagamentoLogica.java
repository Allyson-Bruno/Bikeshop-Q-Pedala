package bikeshop.logica;

import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.OrdemServico;
import bikeshop.validacao.PagamentoValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class FormularioPagamentoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,"Identificação da OS inválida.");
            return;
        }

        OrdemServicoDAO dao = new OrdemServicoDAO();

        OrdemServico ordem = dao.buscarExecutadaPorId(idOrdem);

        if (ordem == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "OS não encontrada ou não está pendente de pagamento.");
            return;
        }

        // Esta consulta retorna somente os itens realizados.
        int quantidadeExecutada = ordem.getItens().size();

        boolean permiteDesconto =
            PagamentoValidacao.permiteDesconto(quantidadeExecutada);

        request.setAttribute("ordem", ordem);
        request.setAttribute("quantidadeExecutada", quantidadeExecutada);
        request.setAttribute("permiteDesconto", permiteDesconto);

        // Apenas uma simulação para exibição no formulário.
        if (permiteDesconto) {

            request.setAttribute(
                "descontoPossivel",
                PagamentoValidacao.calcularDesconto(
                    ordem.getValorTotal(),
                    quantidadeExecutada,
                    true
                ));

            request.setAttribute(
                "totalComDesconto",
                PagamentoValidacao.calcularValorFinal(
                    ordem.getValorTotal(),
                    quantidadeExecutada,
                    true
                ));
        }

        request.getRequestDispatcher("/pagamento.jsp").forward(request, response);
    }
    
}//class FormularioPagamentoLogica.