package bikeshop.logica;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.OrdemServico;
import bikeshop.validacao.RelatorioCalculo;
import bikeshop.validacao.RelatorioValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RelatorioServicosLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String inicioInformado = request.getParameter("dataInicial");
        String fimInformado = request.getParameter("dataFinal");

        // Mantém os filtros preenchidos ao apresentar o resultado ou erro.
        request.setAttribute("dataInicialFiltro", inicioInformado);
        request.setAttribute("dataFinalFiltro", fimInformado);

        // Primeiro acesso: abre somente o formulário.
        if (inicioInformado == null && fimInformado == null) {
            request.getRequestDispatcher("/relatorio-servicos.jsp").forward(request, response);
            return;
        }

        LocalDate dataInicial = converterData(inicioInformado);
        LocalDate dataFinal = converterData(fimInformado);

        String erro = null;

        if (dataInicial == null || dataFinal == null) {
            erro = "Informe uma data inicial e uma data final válidas.";

        } else if (!RelatorioValidacao.intervaloValido(dataInicial, dataFinal)) {

            erro = "A data inicial deve ser anterior ou igual à data final.";
        }

        if (erro != null) {
            request.setAttribute("erro", erro);

            request.getRequestDispatcher("/relatorio-servicos.jsp").forward(request, response);
            return;
        }

        OrdemServicoDAO dao = new OrdemServicoDAO();

        List<OrdemServico> ordens = dao.listaRelatorioServicos(dataInicial, dataFinal);

        BigDecimal totalRelatorio = RelatorioCalculo.calcularTotal(ordens);

        request.setAttribute("ordens", ordens);
        request.setAttribute("totalRelatorio", totalRelatorio);
        request.setAttribute("consultaRealizada", true);

        request.getRequestDispatcher("/relatorio-servicos.jsp").forward(request, response);
    }

    private LocalDate converterData(String dataInformada) {

        if (dataInformada == null || dataInformada.isBlank()) {
            return null;
        }

        try {
            return LocalDate.parse(dataInformada.strip());

        } catch (DateTimeParseException e) {
            return null;
        }
    }
    
}//class RelatorioServicosLogica.