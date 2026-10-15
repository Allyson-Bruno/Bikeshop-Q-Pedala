package bikeshop.logica;

import java.time.LocalDate;

import bikeshop.dao.ClienteDAO;
import bikeshop.modelo.Cliente;
import bikeshop.validacao.ClienteValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import bikeshop.excecao.CpfJaCadastradoException;

public class CadastroClienteLogica implements Logica {

	@Override
	public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String cpf = request.getParameter("cpf");
        String nome = request.getParameter("nome");
        String nascimento = request.getParameter("datanasci");
        String email = request.getParameter("email");
        String telefone = request.getParameter("telefone");
        
        //Inicializada com null devido ao try catch.
        LocalDate dataNascimento = null;
        
        if (nascimento != null && !nascimento.isBlank()) {
        	
        	try {
        		dataNascimento = LocalDate.parse(nascimento);
			} catch (Exception e) {
				//Permanece null para ser rejeitada pela validação abaixo.
			}
        }
        
        String erro = null;
        
        if (!ClienteValidacao.cpfValido(cpf)) {
            erro = "Informe um CPF válido com 11 números, sem pontuação.";

        } else if (!ClienteValidacao.nomeValido(nome)) {
            erro = "Informe um nome com até 120 caracteres.";

        } else if (!ClienteValidacao.dataNascimentoValida(dataNascimento)) {
            erro = "Informe uma data de nascimento válida e que não seja futura.";

        } else if (!ClienteValidacao.emailValido(email)) {
            erro = "Informe um e-mail válido com até 254 caracteres.";

        } else if (!ClienteValidacao.telefoneValido(telefone)) {
            erro = "Informe um telefone válido com até 20 caracteres.";
        }
        
        if (erro != null) {
        	request.setAttribute("erro", erro);
        	//Retorna a página de cadastro informando o erro.
        	request.getRequestDispatcher("/cadastro-cliente.jsp").forward(request, response);
        	
        	//Impede que um cadastro inválido chegue ao DAO.
        	return;
        }

        Cliente cliente = new Cliente();

        cliente.setCpf(cpf);
        cliente.setNome(nome.strip());
        cliente.setDataNascimento(dataNascimento);
        cliente.setEmail(email.strip());
        cliente.setTelefone(telefone.strip());
        
        ClienteDAO dao = new ClienteDAO();
        
        /*
         * Quando o CPF estiver repetido:
         * 
         *  O DAO lança CpfJaCadastradoException.
		 *	O catch recupera a mensagem com e.getMessage().
		 *	O forward volta ao formulário mantendo os parâmetros enviados.
		 *  O return impede que o redirecionamento de sucesso seja executado.
         * 
         */

        try {
        	
            dao.adicionaCliente(cliente);

        } catch (CpfJaCadastradoException e) {

            request.setAttribute("erro", e.getMessage());

            request.getRequestDispatcher("/cadastro-cliente.jsp").forward(request, response);

            return;
        }

        response.sendRedirect(request.getContextPath() + "/cadastro-cliente.jsp?sucesso=true"
        
        );        
	}
	
	
}//class CadastroClienteLogica.
