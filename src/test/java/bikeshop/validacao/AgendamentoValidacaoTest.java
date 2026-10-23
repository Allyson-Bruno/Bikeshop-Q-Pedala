package bikeshop.validacao;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDate;

import org.junit.jupiter.api.Test;

public class AgendamentoValidacaoTest {

    @Test
    public void deveAceitarAgendamentoHoje() {
        assertTrue(
            AgendamentoValidacao.dataAgendamentoValida(LocalDate.now())
        );
    }

    @Test
    public void deveAceitarAgendamentoFuturo() {
        LocalDate amanha = LocalDate.now().plusDays(1);

        assertTrue(
            AgendamentoValidacao.dataAgendamentoValida(amanha)
        );
    }

    @Test
    public void deveRejeitarAgendamentoPassado() {
        LocalDate ontem = LocalDate.now().minusDays(1);

        assertFalse(
            AgendamentoValidacao.dataAgendamentoValida(ontem)
        );
    }

    @Test
    public void deveRejeitarDataNula() {
        assertFalse(
            AgendamentoValidacao.dataAgendamentoValida(null)
        );
    }
    
    @Test
    public void deveAceitarUmServico() {
        assertTrue(
            AgendamentoValidacao.servicosValidos(new String[]{"1"})
        );
    }

    @Test
    public void deveAceitarVariosServicos() {
        assertTrue(
            AgendamentoValidacao.servicosValidos(new String[]{"1", "2", "3"})
        );
    }

    @Test
    public void deveRejeitarSelecaoNulaOuVazia() {
        assertFalse(AgendamentoValidacao.servicosValidos(null));
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{})
        );
    }

    @Test
    public void deveRejeitarIdNuloVazioOuComEspacos() {
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{null})
        );
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{""})
        );
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{" "})
        );
    }

    @Test
    public void deveRejeitarIdNaoNumerico() {
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{"abc"})
        );
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{"1.5"})
        );
    }

    @Test
    public void deveRejeitarIdZeroOuNegativo() {
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{"0"})
        );
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{"-1"})
        );
    }

    @Test
    public void deveRejeitarServicoRepetido() {
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{"1", "1"})
        );
    }

    @Test
    public void deveRejeitarIdAcimaDaCapacidadeDeLong() {
        assertFalse(
            AgendamentoValidacao.servicosValidos(
                new String[]{"9223372036854775808"}
            )
        );
    }

    @Test
    public void deveRejeitarSelecaoComUmIdInvalido() {
        assertFalse(
            AgendamentoValidacao.servicosValidos(new String[]{"1", "abc"})
        );
    }
    
}//class AgendamentoValidacaoTest.