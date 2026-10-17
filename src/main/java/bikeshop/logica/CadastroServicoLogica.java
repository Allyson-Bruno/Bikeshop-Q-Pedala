package bikeshop.logica;

import java.math.BigDecimal;

import bikeshop.dao.ServicoDAO;
import bikeshop.excecao.NomeServicoJaCadastradoException;
import bikeshop.modelo.Servico;
import bikeshop.validacao.ServicoValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CadastroServicoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.setHeader("Allow", "POST");
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        String nome = request.getParameter("nome");
        String valorInformado = request.getParameter("valor");

        BigDecimal valor = null;

        if (valorInformado != null) {

            String valorTratado = valorInformado.strip();

            // Aceita números com um único separador decimal opcional.
            if (valorTratado.matches("[0-9]+([.,][0-9]+)?")) {

                try {
                    valor = new BigDecimal(
                        valorTratado.replace(',', '.')
                    );

                } catch (NumberFormatException e) {
                    // Permanece null para ser rejeitado pela validação.
                }
            }
        }

        String erro = null;

        if (!ServicoValidacao.nomeValido(nome)) {
            erro = "Informe um nome de serviço com até 120 caracteres.";

        } else if (!ServicoValidacao.valorValido(valor)) {
            erro = "Informe um valor entre 0 e 99999999,99, "
                 + "sem frações menores que um centavo e sem "
                 + "separador de milhar.";
        }

        if (erro != null) {
            request.setAttribute("erro", erro);

            request.getRequestDispatcher("/cadastro-servico.jsp").forward(request, response);

            return;
        }

        Servico servico = new Servico();

        servico.setNome(nome.strip());
        servico.setValor(valor.setScale(2));

        ServicoDAO dao = new ServicoDAO();

        try {
        	
            dao.adicionaServico(servico);

        } catch (NomeServicoJaCadastradoException e) {
            request.setAttribute("erro", e.getMessage());

            request.getRequestDispatcher("/cadastro-servico.jsp").forward(request, response);

            return;
        }

        response.sendRedirect(request.getContextPath() + "/cadastro-servico.jsp?sucesso=true");
    }
    
}//class CadastroServicoLogica.