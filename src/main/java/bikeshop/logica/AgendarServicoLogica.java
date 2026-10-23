package bikeshop.logica;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import bikeshop.dao.BicicletaDAO;
import bikeshop.dao.ClienteDAO;
import bikeshop.dao.OrdemServicoDAO;
import bikeshop.dao.ServicoDAO;
import bikeshop.excecao.BicicletaJaAgendadaException;
import bikeshop.modelo.Bicicleta;
import bikeshop.modelo.Cliente;
import bikeshop.modelo.ItemOrdemServico;
import bikeshop.modelo.OrdemServico;
import bikeshop.modelo.Servico;
import bikeshop.validacao.AgendamentoValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AgendarServicoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Allow", "POST");
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        String clienteInformado = request.getParameter("idCliente");
        String bicicletaInformada = request.getParameter("idBicicleta");
        String dataInformada = request.getParameter("dataAgendamento");
        String[] idsServicos = request.getParameterValues("idServicos");

        Long idCliente = null;
        Long idBicicleta = null;
        LocalDate dataAgendamento = null;

        String erro = null;

        // Converte e valida o ID do cliente.
        try {
        	
            if (clienteInformado != null) {
                idCliente = Long.valueOf(clienteInformado.strip());
            }

            if (idCliente == null || idCliente <= 0) {
                erro = "Cliente inválido.";
            }

        } catch (NumberFormatException e) {
            erro = "Cliente inválido.";
        }

        ClienteDAO clienteDAO = new ClienteDAO();
        Cliente cliente = null;

        if (erro == null) {
            cliente = clienteDAO.buscarPorId(idCliente);

            if (cliente == null) {
                erro = "Cliente não encontrado.";
            }
        }

        // Converte o ID da bicicleta.
        if (erro == null) {
            try {
            	
                if (bicicletaInformada != null) {
                    idBicicleta = Long.valueOf(bicicletaInformada.strip());
                }

                if (idBicicleta == null || idBicicleta <= 0) {
                    erro = "Selecione uma bicicleta válida.";
                }

            } catch (NumberFormatException e) {
                erro = "Selecione uma bicicleta válida.";
            }
        }

        Bicicleta bicicleta = null;

        if (erro == null) {
            BicicletaDAO bicicletaDAO = new BicicletaDAO();

            bicicleta = bicicletaDAO.buscarPorIdECliente(
                idBicicleta, idCliente
            );

            if (bicicleta == null) {
                erro = "Bicicleta não encontrada para esse cliente.";
            }
        }

        // Converte e valida a data.
        if (erro == null) {
            if (dataInformada != null && !dataInformada.isBlank()) {
                try {
                    dataAgendamento = LocalDate.parse(dataInformada);

                } catch (DateTimeParseException e) {
                    // Permanece null para ser rejeitada.
                }
            }

            if (!AgendamentoValidacao.dataAgendamentoValida(
                    dataAgendamento)) {

                erro = "Informe uma data válida, de hoje em diante.";
            }
        }

        if (erro == null &&
            !AgendamentoValidacao.servicosValidos(idsServicos)) {

            erro = "Selecione pelo menos um serviço, com IDs válidos e sem repetição.";
        }

        if (erro != null) {
            voltarFormulario(request, response, cliente, erro);
            return;
        }

        OrdemServico ordem = new OrdemServico();

        ordem.setCliente(cliente);
        ordem.setBicicleta(bicicleta);
        ordem.setDataAgendamento(dataAgendamento);

        ServicoDAO servicoDAO = new ServicoDAO();

        // Confere se cada serviço selecionado existe.
        for (String idInformado : idsServicos) {

            Long idServico = Long.valueOf(idInformado);
            Servico servico = servicoDAO.buscarPorId(idServico);

            if (servico == null) {
                voltarFormulario(request, response, cliente, "Um dos serviços selecionados não foi encontrado.");
                return;
            }

            ItemOrdemServico item = new ItemOrdemServico();

            item.setServico(servico);
            item.setExecutado(false);
            item.setValor(null);

            ordem.getItens().add(item);
        }

        OrdemServicoDAO ordemDAO = new OrdemServicoDAO();

        try {
            ordemDAO.agendar(ordem);

        } catch (BicicletaJaAgendadaException e) {
            voltarFormulario(request, response, cliente, e.getMessage());
            return;
        }

        response.sendRedirect(request.getContextPath()
        		+ "/mvc?logica=FormularioAgendamentoLogica&sucesso=true");
    }

    private void voltarFormulario(HttpServletRequest request,
                                  HttpServletResponse response,
                                  Cliente cliente,
                                  String erro) throws Exception {

        request.setAttribute("erro", erro);

        if (cliente != null) {

            BicicletaDAO bicicletaDAO = new BicicletaDAO();
            ServicoDAO servicoDAO = new ServicoDAO();

            request.setAttribute("cliente", cliente);

            request.setAttribute("bicicletas", bicicletaDAO.listaPorCliente(cliente.getId()));

            request.setAttribute("servicos", servicoDAO.listaServicos());
        }

        request.getRequestDispatcher("/agendamento.jsp").forward(request, response);
    }
    
}//class AgendarServicoLogica.