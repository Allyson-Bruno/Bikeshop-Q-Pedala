package bikeshop.logica;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.OrdemServico;
import bikeshop.relatorio.RelatorioServicosPdf;
import bikeshop.validacao.RelatorioCalculo;
import bikeshop.validacao.RelatorioValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ExportarRelatorioPdfLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Allow", "GET");
            
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        String inicioInformado = request.getParameter("dataInicial");
        String fimInformado = request.getParameter("dataFinal");

        LocalDate dataInicial = converterData(inicioInformado);
        LocalDate dataFinal = converterData(fimInformado);

        String erro = null;

        if (dataInicial == null || dataFinal == null) {
            erro = "Informe uma data inicial e uma data final válidas.";

        } else if (!RelatorioValidacao.intervaloValido(
                dataInicial, dataFinal)) {

            erro = "A data inicial deve ser anterior ou igual à data final.";
        }

        if (erro != null) {
            request.setAttribute("erro", erro);
            request.setAttribute("dataInicialFiltro", inicioInformado);
            request.setAttribute("dataFinalFiltro", fimInformado);

            request.getRequestDispatcher("/relatorio-servicos.jsp").forward(request, response);
            return;
        }

        OrdemServicoDAO dao = new OrdemServicoDAO();

        List<OrdemServico> ordens = dao.listaRelatorioServicos(dataInicial, dataFinal);

        BigDecimal total = RelatorioCalculo.calcularTotal(ordens);

        RelatorioServicosPdf gerador = new RelatorioServicosPdf();

        // Gera o documento completo antes de enviar a resposta.
        byte[] pdf = gerador.gerar(
            dataInicial,
            dataFinal,
            ordens,
            total
        );

        String nomeArquivo = "relatorio-servicos-"
            + dataInicial + "-a-" + dataFinal + ".pdf";

        response.setContentType("application/pdf");

        response.setHeader(
            "Content-Disposition",
            "attachment; filename=\"" + nomeArquivo + "\""
        );

        response.setHeader("Cache-Control", "no-store");
        response.setContentLength(pdf.length);

        response.getOutputStream().write(pdf);
        response.getOutputStream().flush();
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
    
}//class ExportarRelatorioPdfLogica.