package bikeshop.validacao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;

import org.junit.jupiter.api.Test;

public class PagamentoValidacaoTest {

    @Test
    public void devePermitirDescontoComTresOuMaisServicos() {
        assertTrue(PagamentoValidacao.permiteDesconto(3));
        assertTrue(PagamentoValidacao.permiteDesconto(4));
    }

    @Test
    public void naoDevePermitirDescontoComMenosDeTresServicos() {
        assertFalse(PagamentoValidacao.permiteDesconto(1));
        assertFalse(PagamentoValidacao.permiteDesconto(2));
    }

    @Test
    public void deveManterDescontoZeroSemConfirmacao() {
        assertEquals(
            new BigDecimal("0.00"),
            PagamentoValidacao.calcularDesconto(
                new BigDecimal("300.00"), 3, false));
    }

    @Test
    public void devePermitirPagamentoSemDescontoComUmServico() {
        assertEquals(
            new BigDecimal("150.00"),
            PagamentoValidacao.calcularValorFinal(
                new BigDecimal("150.00"), 1, false
            )
        );
    }

    @Test
    public void deveCalcularDezPorCentoComConfirmacao() {
        assertEquals(
            new BigDecimal("30.00"),
            PagamentoValidacao.calcularDesconto(
                new BigDecimal("300.00"), 3, true
            )
        );
    }

    @Test
    public void deveRejeitarDescontoComDoisServicos() {
        assertThrows(
            IllegalArgumentException.class,
            () -> PagamentoValidacao.calcularDesconto(
                new BigDecimal("200.00"), 2, true
            )
        );
    }

    @Test
    public void deveCalcularValorFinalComDesconto() {
        assertEquals(
            new BigDecimal("270.00"),
            PagamentoValidacao.calcularValorFinal(
                new BigDecimal("300.00"), 3, true
            )
        );
    }

    @Test
    public void deveArredondarDescontoParaCimaNoMeioCentavo() {
        assertEquals(
            new BigDecimal("10.01"),
            PagamentoValidacao.calcularDesconto(
                new BigDecimal("100.05"), 3, true
            )
        );
    }

    @Test
    public void deveArredondarDescontoParaBaixoAbaixoDoMeioCentavo() {
        assertEquals(
            new BigDecimal("10.00"),
            PagamentoValidacao.calcularDesconto(
                new BigDecimal("100.04"), 3, true
            )
        );
    }

    @Test
    public void deveSubtrairODescontoJaArredondado() {
        assertEquals(
            new BigDecimal("90.04"),
            PagamentoValidacao.calcularValorFinal(
                new BigDecimal("100.05"), 3, true
            )
        );
    }

    @Test
    public void deveAceitarTotalZero() {
        assertEquals(
            new BigDecimal("0.00"),
            PagamentoValidacao.calcularValorFinal(
                BigDecimal.ZERO, 3, true
            )
        );
    }

    @Test
    public void deveRejeitarQuantidadeZeroOuNegativa() {
        assertThrows(
            IllegalArgumentException.class,
            () -> PagamentoValidacao.calcularDesconto(
                new BigDecimal("100.00"), 0, false
            )
        );

        assertThrows(
            IllegalArgumentException.class,
            () -> PagamentoValidacao.calcularDesconto(
                new BigDecimal("100.00"), -1, false
            )
        );
    }

    @Test
    public void deveRejeitarTotalNulo() {
        assertThrows(
            IllegalArgumentException.class,
            () -> PagamentoValidacao.calcularDesconto(
                null, 3, true
            )
        );
    }

    @Test
    public void deveRejeitarTotalNegativo() {
        assertThrows(
            IllegalArgumentException.class,
            () -> PagamentoValidacao.calcularDesconto(
                new BigDecimal("-10.00"), 3, true
            )
        );
    }

    @Test
    public void deveRejeitarTotalComFracaoDeCentavo() {
        assertThrows(
            IllegalArgumentException.class,
            () -> PagamentoValidacao.calcularDesconto(
                new BigDecimal("100.001"), 3, true
            )
        );
    }

    @Test
    public void deveRejeitarTotalAcimaDoLimite() {
        assertThrows(
            IllegalArgumentException.class,
            () -> PagamentoValidacao.calcularDesconto(
                new BigDecimal("100000000.00"), 3, true
            )
        );
    }
    
}//class PagamentoValidacaoTest.