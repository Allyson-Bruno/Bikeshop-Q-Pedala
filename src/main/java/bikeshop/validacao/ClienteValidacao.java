package bikeshop.validacao;

import java.time.LocalDate;

public class ClienteValidacao {

	  public static boolean dataNascimentoValida(LocalDate dataNascimento) {

	        if (dataNascimento == null) {
	            return false;
	        }

	        //Não estando depois da data atual é aceita.
	        return !dataNascimento.isAfter(LocalDate.now());
	    }
	  
	  
	  /*
	   * Sobre a validação do CPF.
	   * 
	   * 1. Se o CPF não é nulo e possui exatamente 11 números.
	   * 2. Se os números não são todos iguais.
	   * 3. Se os dois últimos números, chamados dígitos verificadores, correspondem ao cálculo
		 
	   * Como funciona o cálculo:
		 
	   * Para o primeiro dígito, multiplicamos os nove primeiros números pelos pesos 10, 9, 8… até 2 e somamos os resultados. Calculamos 11 - (soma % 11); se resultar em 10 ou 11, usamos zero.
	   * Para o segundo, repetimos com os dez primeiros números e os pesos 11, 10, 9… até 2.
	   * A expressão cpf.charAt(i) - '0' converte o caractere numérico em um int: por exemplo, '5' - '0' resulta em 5.

	   */
	  
	  public static boolean cpfValido(String cpf) {

		    if (cpf == null || !cpf.matches("[0-9]{11}")) {
		        return false;
		    }

		    // Rejeita sequências como 00000000000 e 11111111111.
		    boolean todosIguais = true;

		    for (int i = 1; i < cpf.length(); i++) {
		        if (cpf.charAt(i) != cpf.charAt(0)) {
		            todosIguais = false;
		            break;
		        }
		    }

		    if (todosIguais) {
		        return false;
		    }

		    // Calcula o primeiro dígito verificador.
		    int soma = 0;

		    for (int i = 0; i < 9; i++) {
		        soma += (cpf.charAt(i) - '0') * (10 - i);
		    }

		    int primeiroDigito = 11 - (soma % 11);

		    if (primeiroDigito >= 10) {
		        primeiroDigito = 0;
		    }

		    if (primeiroDigito != cpf.charAt(9) - '0') {
		        return false;
		    }

		    // Calcula o segundo dígito, incluindo o primeiro.
		    soma = 0;

		    for (int i = 0; i < 10; i++) {
		        soma += (cpf.charAt(i) - '0') * (11 - i);
		    }

		    int segundoDigito = 11 - (soma % 11);

		    if (segundoDigito >= 10) {
		        segundoDigito = 0;
		    }

		    return segundoDigito == cpf.charAt(10) - '0';
		}
	  
	  public static boolean nomeValido(String nome) {

		    if (nome == null) {
		        return false;
		    }

		    /*
		     * O strip() remove espaços do início e do final.
		     */
		    
		    String nomeTratado = nome.strip();

		    return !nomeTratado.isBlank() && nomeTratado.length() <= 120;
		}
	  
	  public static boolean emailValido(String email) {

		    if (email == null) {
		        return false;
		    }

		    String emailTratado = email.strip();

		    if (emailTratado.isBlank() || emailTratado.length() > 254) {
		        return false;
		    }
		    
		    /*
		     * O matches() compara a String inteira com uma expressão regular, que descreve o formato aceito. Aqui, exigimos:
			 *	- Uma parte antes do @, sem pontos consecutivos ou nas extremidades.
			 *	- Um único @.
			 *	- Um domínio com pelo menos um ponto, sem hífen no início ou final de cada parte.
			 *	- Ausência de espaços internos.
		     * 
		     * 
		     */

		    return emailTratado.matches(
		        "[A-Za-z0-9_%+-]+(?:\\.[A-Za-z0-9_%+-]+)*@" +
		        "[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?" +
		        "(?:\\.[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)+"
		    );
		}
	  
	  public static boolean telefoneValido(String telefone) {

		    if (telefone == null) {
		        return false;
		    }

		    String telefoneTratado = telefone.strip();

		    if (telefoneTratado.isBlank() || telefoneTratado.length() > 20) {
		        return false;
		    }

		    return telefoneTratado.matches("[0-9()+ -]+")
		        && telefoneTratado.matches(".*[0-9].*");
		}
	
}//class ClienteValidacao.
