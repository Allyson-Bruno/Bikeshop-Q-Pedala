package bikeshop.logica;

import bikeshop.dao.BicicletaDAO;
import bikeshop.dao.ClienteDAO;
import bikeshop.excecao.NumeroSerieJaCadastradoException;
import bikeshop.modelo.Bicicleta;
import bikeshop.modelo.Cliente;
import bikeshop.validacao.BicicletaValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CadastroBicicletaLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // Cadastro deve ser enviado por POST.
    	/*
    	 * Impede que a ação execute se alguém a acessar por outro método, por exemplo digitando
    	 * /mvc?logica=CadastroClienteLogica na barra do navegador, o que envia um GET.
    	 * 
    	 */

    	if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Allow", "POST");
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String tipo = request.getParameter("tipo");
        String tamanhoQuadro = request.getParameter("tamanhoQuadro");
        String numeroSerie = request.getParameter("numeroSerie");
        String anoInformado = request.getParameter("anoFabricacao");
        String idProprietario = request.getParameter("idProprietario");

        Short anoFabricacao = null;

        if (anoInformado != null && !anoInformado.isBlank()) {
            try {
                anoFabricacao = Short.valueOf(anoInformado.strip());
            } catch (NumberFormatException e) {
                // Permanece null para ser rejeitado pela validação.
            }
        }

        String erro = null;

        if (!BicicletaValidacao.marcaValida(marca)) {
            erro = "Informe uma marca com até 60 caracteres.";

        } else if (!BicicletaValidacao.modeloValido(modelo)) {
            erro = "Informe um modelo com até 100 caracteres.";

        } else if (!BicicletaValidacao.tipoValido(tipo)) {
            erro = "Selecione um tipo de bicicleta válido.";

        } else if (!BicicletaValidacao.tamanhoQuadroValido(tamanhoQuadro)) {
            erro = "Informe um tamanho de quadro com até 30 caracteres.";

        } else if (!BicicletaValidacao.numeroSerieValido(numeroSerie)) {
            erro = "Informe um número de série com até 50 caracteres.";

        } else if (!BicicletaValidacao.anoFabricacaoValido(anoFabricacao)) {
            erro = "Informe um ano de fabricação entre 1800 e o ano atual.";
        }

        ClienteDAO clienteDAO = new ClienteDAO();
        Cliente proprietario = null;

        // Só busca o proprietário se os demais campos estiverem válidos.
        if (erro == null && idProprietario != null && !idProprietario.isBlank()) {

            try {
            	
                Long id = Long.valueOf(idProprietario.strip());

                if (id <= 0) {
                    erro = "Proprietário inválido.";
                } else {
                    proprietario = clienteDAO.buscarPorId(id);

                    if (proprietario == null) {
                        erro = "O proprietário selecionado não foi encontrado.";
                    }
                }

            } catch (NumberFormatException e) {
                erro = "Proprietário inválido.";
            }
        }

        if (erro != null) {
            request.setAttribute("erro", erro);

            request.setAttribute("clientes", clienteDAO.listaCliente());

            request.getRequestDispatcher("/cadastro-bicicleta.jsp") .forward(request, response);

            return;
        }

        Bicicleta bicicleta = new Bicicleta();

        bicicleta.setMarca(marca.strip());
        bicicleta.setModelo(modelo.strip());
        bicicleta.setTipo(tipo.strip());
        bicicleta.setTamanhoQuadro(tamanhoQuadro.strip());
        bicicleta.setNumeroSerie(numeroSerie.strip());
        bicicleta.setAnoFabricacao(anoFabricacao);
        bicicleta.setProprietario(proprietario);

        BicicletaDAO bicicletaDAO = new BicicletaDAO();

        try {
        	
            bicicletaDAO.adicionaBicicleta(bicicleta);

        } catch (NumeroSerieJaCadastradoException e) {

        	request.setAttribute("erro", e.getMessage());

            request.setAttribute("clientes", clienteDAO.listaCliente());

            request.getRequestDispatcher("/cadastro-bicicleta.jsp").forward(request, response);

            return;
        }

        response.sendRedirect(request.getContextPath() +
        		"/mvc?logica=FormularioBicicletaLogica&sucesso=true"
        );
    }
}