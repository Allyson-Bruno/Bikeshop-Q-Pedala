package bikeshop.validacao;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDate;

import org.junit.jupiter.api.Test;

public class ClienteValidacaoTest {
	
	/*
	 * 
	 * @Test	Identifica um método que o JUnit deve executar como teste.
		assertTrue(resultado)	O teste passa se o resultado for true.
		assertFalse(resultado)	O teste passa se o resultado for false.
	 * 
	 */

    @Test
    public void deveAceitarDataPassada() {

        LocalDate data = LocalDate.of(2000, 5, 10);

        assertTrue(ClienteValidacao.dataNascimentoValida(data));
    }

    @Test
    public void deveAceitarDataDeHoje() {

        LocalDate data = LocalDate.now();

        assertTrue(ClienteValidacao.dataNascimentoValida(data));
    }

    @Test
    public void deveRejeitarDataFutura() {

        LocalDate data = LocalDate.now().plusDays(1);

        assertFalse(ClienteValidacao.dataNascimentoValida(data));
    }

    @Test
    public void deveRejeitarDataNula() {

        assertFalse(ClienteValidacao.dataNascimentoValida(null));
    }
    
    //Testes para o CPF.
    
    @Test
    public void deveAceitarCpfComDigitosCorretos() {
        assertTrue(ClienteValidacao.cpfValido("52998224725"));
    }

    @Test
    public void deveRejeitarPrimeiroDigitoIncorreto() {
        assertFalse(ClienteValidacao.cpfValido("52998224735"));
    }

    @Test
    public void deveRejeitarSegundoDigitoIncorreto() {
        assertFalse(ClienteValidacao.cpfValido("52998224724"));
    }

    @Test
    public void deveRejeitarCpfComTodosOsNumerosIguais() {

        for (int numero = 0; numero <= 9; numero++) {
            String cpf = String.valueOf(numero).repeat(11);

            assertFalse(ClienteValidacao.cpfValido(cpf));
        }
    }

    @Test
    public void deveRejeitarCpfComTamanhoIncorreto() {
        assertFalse(ClienteValidacao.cpfValido("5299822472"));
        assertFalse(ClienteValidacao.cpfValido("529982247255"));
    }

    @Test
    public void deveRejeitarCpfComLetras() {
        assertFalse(ClienteValidacao.cpfValido("5299822472A"));
    }

    @Test
    public void deveRejeitarCpfComPontuacao() {
        assertFalse(ClienteValidacao.cpfValido("529.982.247-25"));
    }

    @Test
    public void deveRejeitarCpfVazioOuNulo() {
        assertFalse(ClienteValidacao.cpfValido(""));
        assertFalse(ClienteValidacao.cpfValido(null));
    }
    
    //Testes para o nome.
    
    @Test
    public void deveAceitarNomePreenchido() {
        assertTrue(ClienteValidacao.nomeValido("Allyson Bruno"));
    }

    @Test
    public void deveRejeitarNomeNulo() {
        assertFalse(ClienteValidacao.nomeValido(null));
    }

    @Test
    public void deveRejeitarNomeVazio() {
        assertFalse(ClienteValidacao.nomeValido(""));
    }

    @Test
    public void deveRejeitarNomeComApenasEspacos() {
        assertFalse(ClienteValidacao.nomeValido("   "));
    }

    @Test
    public void deveAceitarNomeCom120Caracteres() {
        assertTrue(ClienteValidacao.nomeValido("A".repeat(120)));
    }

    @Test
    public void deveRejeitarNomeCom121Caracteres() {
        assertFalse(ClienteValidacao.nomeValido("A".repeat(121)));
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDoNome() {
        String nome = "  " + "A".repeat(120) + "  ";

        assertTrue(ClienteValidacao.nomeValido(nome));
    }
    
    //Testes para o email.
    @Test
    public void deveAceitarEmailComFormatoBasico() {
        assertTrue(ClienteValidacao.emailValido("allyson@example.com"));
    }

    @Test
    public void deveAceitarEmailComPontoMaisESubdominio() {
        assertTrue(
            ClienteValidacao.emailValido("allyson.bruno+loja@aluno.example.com")
        );
    }

    @Test
    public void deveRejeitarEmailNulo() {
        assertFalse(ClienteValidacao.emailValido(null));
    }

    @Test
    public void deveRejeitarEmailVazioOuComApenasEspacos() {
        assertFalse(ClienteValidacao.emailValido(""));
        assertFalse(ClienteValidacao.emailValido("   "));
    }

    @Test
    public void deveRejeitarEmailSemArroba() {
        assertFalse(ClienteValidacao.emailValido("allyson.example.com"));
    }

    @Test
    public void deveRejeitarEmailSemUsuarioOuDominio() {
        assertFalse(ClienteValidacao.emailValido("@example.com"));
        assertFalse(ClienteValidacao.emailValido("allyson@"));
    }

    @Test
    public void deveRejeitarEmailComEspacoInterno() {
        assertFalse(ClienteValidacao.emailValido("allyson bruno@example.com"));
    }

    @Test
    public void deveRejeitarEmailComDuasArrobas() {
        assertFalse(ClienteValidacao.emailValido("allyson@@example.com"));
    }

    @Test
    public void deveRejeitarDominioSemPonto() {
        assertFalse(ClienteValidacao.emailValido("allyson@example"));
    }

    @Test
    public void deveRejeitarPontosInvalidosNoUsuario() {
        assertFalse(ClienteValidacao.emailValido(".allyson@example.com"));
        assertFalse(ClienteValidacao.emailValido("allyson.@example.com"));
        assertFalse(ClienteValidacao.emailValido("allyson..bruno@example.com"));
    }

    @Test
    public void deveRejeitarHifenNasExtremidadesDoDominio() {
        assertFalse(ClienteValidacao.emailValido("allyson@-example.com"));
        assertFalse(ClienteValidacao.emailValido("allyson@example-.com"));
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDoEmail() {
        assertTrue(ClienteValidacao.emailValido("  allyson@example.com  "));
    }

    @Test
    public void deveAceitarEmailCom254Caracteres() {

        String dominio = "b".repeat(63) + "." +
                         "c".repeat(63) + "." +
                         "d".repeat(61);

        String email = "a".repeat(64) + "@" + dominio;

        assertTrue(ClienteValidacao.emailValido(email));
    }

    @Test
    public void deveRejeitarEmailCom255Caracteres() {

        String dominio = "b".repeat(63) + "." +
                         "c".repeat(63) + "." +
                         "d".repeat(62);

        String email = "a".repeat(64) + "@" + dominio;

        assertFalse(ClienteValidacao.emailValido(email));
    }
    
    //Telefone.
    @Test
    public void deveAceitarTelefoneSemFormatacao() {
        assertTrue(ClienteValidacao.telefoneValido("32999999999"));
    }

    @Test
    public void deveAceitarTelefoneComFormatacao() {
        assertTrue(ClienteValidacao.telefoneValido("(32) 99999-9999"));
    }

    @Test
    public void deveRejeitarTelefoneNulo() {
        assertFalse(ClienteValidacao.telefoneValido(null));
    }

    @Test
    public void deveRejeitarTelefoneVazio() {
        assertFalse(ClienteValidacao.telefoneValido(""));
    }

    @Test
    public void deveRejeitarTelefoneComApenasEspacos() {
        assertFalse(ClienteValidacao.telefoneValido("   "));
    }

    @Test
    public void deveAceitarTelefoneCom20Caracteres() {
        assertTrue(
            ClienteValidacao.telefoneValido("1".repeat(20))
        );
    }

    @Test
    public void deveRejeitarTelefoneCom21Caracteres() {
        assertFalse(
            ClienteValidacao.telefoneValido("1".repeat(21))
        );
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDoTelefone() {
        assertTrue(
            ClienteValidacao.telefoneValido("  (32) 99999-9999  ")
        );
    }
    
    @Test
    public void deveRejeitarTelefoneComLetras() {
        assertFalse(ClienteValidacao.telefoneValido("abc"));
        assertFalse(ClienteValidacao.telefoneValido("32abc9999"));
    }

    @Test
    public void deveRejeitarTelefoneSemNumeros() {
        assertFalse(ClienteValidacao.telefoneValido("()+ -"));
    }
    
    
}//class ClienteValidacaoTest.