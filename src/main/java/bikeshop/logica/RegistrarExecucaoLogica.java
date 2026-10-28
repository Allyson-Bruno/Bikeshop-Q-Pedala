package bikeshop.logica;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.ItemOrdemServico;
import bikeshop.modelo.OrdemServico;
import bikeshop.validacao.ExecucaoValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegistrarExecucaoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Allow", "POST");
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        // Recupera e valida o ID da OS.
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
            		"Identificação da OS inválida.");
            return;
        }

        OrdemServicoDAO dao = new OrdemServicoDAO();

        OrdemServico ordem = dao.buscarAgendadaPorId(idOrdem);

        if (ordem == null) {
            response.sendError(HttpServletResponse.SC_CONFLICT, 
            		"A OS não existe ou já não está agendada.");
            return;
        }

        // Converte a data recebida.
        String dataInformada = request.getParameter("dataExecucao");
        LocalDate dataExecucao = null;

        if (dataInformada != null && !dataInformada.isBlank()) {

            try {
                dataExecucao = LocalDate.parse(dataInformada);

            } catch (DateTimeParseException e) {
                // Permanece null para ser rejeitada pela validação.
            }
        }

        if (!ExecucaoValidacao.dataExecucaoValida(dataExecucao)) {
            voltarFormulario(
                request,
                response,
                ordem,
                "Informe uma data de execução válida e que não seja futura.");
            return;
        }

        String[] idItens = request.getParameterValues("idItens");

        if (!ExecucaoValidacao.itensSelecionadosValidos(idItens)) {
            voltarFormulario(
                request,
                response,
                ordem,
                "Selecione pelo menos um serviço, sem repetir os itens.");
            return;
        }

        // Identifica os itens que realmente pertencem à OS.
        Set<Long> idsDaOrdem = new HashSet<>();

        for (ItemOrdemServico item : ordem.getItens()) {
            idsDaOrdem.add(item.getId());
        }

        Map<Long, BigDecimal> valoresPorItem = new LinkedHashMap<>();

        for (String idItemInformado : idItens) {

            // O formato e o limite de Long já foram validados.
            Long idItem = Long.parseLong(idItemInformado);

            if (!idsDaOrdem.contains(idItem)) {
                voltarFormulario(
                    request,
                    response,
                    ordem,
                    "Um dos serviços selecionados não pertence a esta OS.");
                return;
            }

            String valorInformado = request.getParameter(
                "valorItem_" + idItem
            );

            BigDecimal valor = ExecucaoValidacao.converterValor(
                valorInformado
            );

            if (!ExecucaoValidacao.valorItemValido(valor)) {
                voltarFormulario(
                    request,
                    response,
                    ordem,
                    "Informe um valor válido para cada serviço selecionado, "
                    + "entre 0 e 99999999,99, sem separador de milhar "
                    + "e sem frações menores que um centavo.");
                return;
            }

            valoresPorItem.put(idItem, valor);
        }

        boolean registrada;

        try {
            // O DAO valida a soma e grava tudo em uma transação.
            registrada = dao.registrarExecucao(
                idOrdem,
                dataExecucao,
                valoresPorItem);

        } catch (IllegalArgumentException e) {
            voltarFormulario(
                request,
                response,
                ordem,
                e.getMessage()
            );
            return;
        }

        if (!registrada) {
            // A situação da OS pode ter mudado após abrir o formulário.
            response.sendError(
                HttpServletResponse.SC_CONFLICT,
                "A OS já não está agendada. Atualize a listagem.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/mvc?logica=ListarAgendamentosLogica&executada=true");
    }

    private void voltarFormulario(HttpServletRequest request, HttpServletResponse response,
            OrdemServico ordem,
            String erro) throws Exception {

        request.setAttribute("ordem", ordem);
        request.setAttribute("erro", erro);

        request.getRequestDispatcher("/execucao-servico.jsp").forward(request, response);
    }
    
}//class RegistrarExecucaoLogica.