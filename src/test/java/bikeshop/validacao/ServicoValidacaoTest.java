package bikeshop.validacao;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;

import org.junit.jupiter.api.Test;

public class ServicoValidacaoTest {

    @Test
    public void deveAceitarNomePreenchido() {
        assertTrue(ServicoValidacao.nomeValido("Revisão básica"));
    }

    @Test
    public void deveRejeitarNomeNulo() {
        assertFalse(ServicoValidacao.nomeValido(null));
    }

    @Test
    public void deveRejeitarNomeVazioOuComApenasEspacos() {
        assertFalse(ServicoValidacao.nomeValido(""));
        assertFalse(ServicoValidacao.nomeValido("   "));
    }

    @Test
    public void deveAceitarNomeCom120Caracteres() {
        assertTrue(ServicoValidacao.nomeValido("A".repeat(120)));
    }

    @Test
    public void deveRejeitarNomeCom121Caracteres() {
        assertFalse(ServicoValidacao.nomeValido("A".repeat(121)));
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDoNome() {
        String nome = "  " + "A".repeat(120) + "  ";

        assertTrue(ServicoValidacao.nomeValido(nome));
    }
    
    @Test
    public void deveAceitarValorComDuasCasasDecimais() {
        assertTrue(ServicoValidacao.valorValido(new BigDecimal("150.50")));
    }

    @Test
    public void deveAceitarValorInteiro() {
        assertTrue(ServicoValidacao.valorValido(new BigDecimal("150")));
    }

    @Test
    public void deveAceitarValorComUmaCasaDecimal() {
        assertTrue(ServicoValidacao.valorValido(new BigDecimal("150.5")));
    }

    @Test
    public void deveAceitarValorZero() {
        assertTrue(ServicoValidacao.valorValido(BigDecimal.ZERO));
    }

    @Test
    public void deveRejeitarValorNulo() {
        assertFalse(ServicoValidacao.valorValido(null));
    }

    @Test
    public void deveRejeitarValorNegativo() {
        assertFalse(ServicoValidacao.valorValido(new BigDecimal("-0.01")));
    }

    @Test
    public void deveAceitarValorMaximo() {
        assertTrue(
            ServicoValidacao.valorValido(new BigDecimal("99999999.99"))
        );
    }

    @Test
    public void deveRejeitarValorAcimaDoMaximo() {
        assertFalse(
            ServicoValidacao.valorValido(new BigDecimal("100000000.00"))
        );
    }

    @Test
    public void deveRejeitarFracaoMenorQueUmCentavo() {
        assertFalse(ServicoValidacao.valorValido(new BigDecimal("150.001")));
    }

    @Test
    public void deveAceitarZerosDecimaisExtras() {
        assertTrue(ServicoValidacao.valorValido(new BigDecimal("150.000")));
    }
    
}//class ServicoValidacaoTest.