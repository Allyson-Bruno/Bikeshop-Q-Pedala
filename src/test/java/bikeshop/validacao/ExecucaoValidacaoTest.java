package bikeshop.validacao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.Test;

public class ExecucaoValidacaoTest {

    @Test
    public void deveAceitarExecucaoHoje() {
        assertTrue(
            ExecucaoValidacao.dataExecucaoValida(LocalDate.now())
        );
    }

    @Test
    public void deveAceitarExecucaoPassada() {
        LocalDate ontem = LocalDate.now().minusDays(1);

        assertTrue(
            ExecucaoValidacao.dataExecucaoValida(ontem)
        );
    }

    @Test
    public void deveRejeitarExecucaoFutura() {
        LocalDate amanha = LocalDate.now().plusDays(1);

        assertFalse(
            ExecucaoValidacao.dataExecucaoValida(amanha)
        );
    }

    @Test
    public void deveRejeitarDataNula() {
        assertFalse(
            ExecucaoValidacao.dataExecucaoValida(null)
        );
    }
    
 // Seleção dos itens.

    @Test
    public void deveAceitarUmItemSelecionado() {
        assertTrue(
            ExecucaoValidacao.itensSelecionadosValidos(
                new String[] {"1"}
            )
        );
    }

    @Test
    public void deveAceitarVariosItensDistintos() {
        assertTrue(
            ExecucaoValidacao.itensSelecionadosValidos(
                new String[] {"1", "2", "5"}
            )
        );
    }

    @Test
    public void deveRejeitarSelecaoNulaOuVazia() {
        assertFalse(
            ExecucaoValidacao.itensSelecionadosValidos(null)
        );

        assertFalse(
            ExecucaoValidacao.itensSelecionadosValidos(new String[0])
        );
    }

    @Test
    public void deveRejeitarIdsRepetidos() {
        assertFalse(
            ExecucaoValidacao.itensSelecionadosValidos(
                new String[] {"2", "2"}
            )
        );

        // Apesar da escrita diferente, ambos representam o mesmo ID.
        assertFalse(
            ExecucaoValidacao.itensSelecionadosValidos(
                new String[] {"2", "02"}
            )
        );
    }

    @Test
    public void deveRejeitarIdZeroOuNegativo() {
        assertFalse(
            ExecucaoValidacao.itensSelecionadosValidos(
                new String[] {"0"}
            )
        );

        assertFalse(
            ExecucaoValidacao.itensSelecionadosValidos(
                new String[] {"-1"}
            )
        );
    }

    @Test
    public void deveRejeitarIdComFormatoInvalido() {

        String[] invalidos = {null, "", " ", "abc", "1.5", " 1 "};

        for (String id : invalidos) {
            assertFalse(
                ExecucaoValidacao.itensSelecionadosValidos(
                    new String[] {id}
                )
            );
        }
    }

    @Test
    public void deveRejeitarIdMaiorQueLimiteDeLong() {
        assertFalse(
            ExecucaoValidacao.itensSelecionadosValidos(
                new String[] {"9223372036854775808"}
            )
        );
    }

    // Valores dos itens.

    @Test
    public void deveConverterValorComVirgulaOuPonto() {

        assertEquals(
            new BigDecimal("150.00"),
            ExecucaoValidacao.converterValor("150,00")
        );

        assertEquals(
            new BigDecimal("150.00"),
            ExecucaoValidacao.converterValor("150.00")
        );
    }

    @Test
    public void deveRejeitarTextoMonetarioInvalido() {

        String[] invalidos = {
            null, "", "   ", "abc", "R$ 150,00", "1.500,00"
        };

        for (String valor : invalidos) {
            assertNull(ExecucaoValidacao.converterValor(valor));
        }
    }

    @Test
    public void deveAceitarValorZeroEValorMaximo() {

        assertTrue(
            ExecucaoValidacao.valorItemValido(BigDecimal.ZERO)
        );

        assertTrue(
            ExecucaoValidacao.valorItemValido(
                new BigDecimal("99999999.99")
            )
        );
    }

    @Test
    public void deveRejeitarValorNuloNegativoOuAcimaDoLimite() {

        assertFalse(
            ExecucaoValidacao.valorItemValido(null)
        );

        assertFalse(
            ExecucaoValidacao.valorItemValido(
                new BigDecimal("-0.01")
            )
        );

        assertFalse(
            ExecucaoValidacao.valorItemValido(
                new BigDecimal("100000000.00")
            )
        );
    }

    @Test
    public void deveRejeitarFracaoMenorQueUmCentavo() {

        BigDecimal valor = ExecucaoValidacao.converterValor("150,001");

        assertFalse(ExecucaoValidacao.valorItemValido(valor));
    }
    
    @Test
    public void deveSomarValoresDosItens() {

        List<BigDecimal> valores = List.of(
            new BigDecimal("150.00"),
            new BigDecimal("50.00"),
            new BigDecimal("40.00"));

        assertEquals(
            new BigDecimal("240.00"),
            ExecucaoValidacao.calcularTotal(valores));
    }

    @Test
    public void deveSomarCentavosComPrecisao() {

        List<BigDecimal> valores = List.of(
            new BigDecimal("0.10"),
            new BigDecimal("0.20"));

        assertEquals(
            new BigDecimal("0.30"),
            ExecucaoValidacao.calcularTotal(valores));
    }

    @Test
    public void deveAceitarTotalZero() {

        assertEquals(
            new BigDecimal("0.00"),
            ExecucaoValidacao.calcularTotal(
                List.of(BigDecimal.ZERO)));
    }

    @Test
    public void deveAceitarSomaNoLimitePermitido() {

        List<BigDecimal> valores = List.of(
            new BigDecimal("99999999.98"),
            new BigDecimal("0.01"));

        assertEquals(
            new BigDecimal("99999999.99"),
            ExecucaoValidacao.calcularTotal(valores));
    }

    @Test
    public void deveRejeitarSomaAcimaDoLimitePermitido() {

        // Cada valor é válido, mas a soma ultrapassa o limite.
        List<BigDecimal> valores = List.of(
            new BigDecimal("99999999.99"),
            new BigDecimal("0.01"));

        assertThrows(
            IllegalArgumentException.class,
            () -> ExecucaoValidacao.calcularTotal(valores));
    }

    @Test
    public void deveRejeitarListaDeValoresNulaOuVazia() {

        assertThrows(
            IllegalArgumentException.class,
            () -> ExecucaoValidacao.calcularTotal(null));

        assertThrows(IllegalArgumentException.class, 
        		() -> ExecucaoValidacao.calcularTotal(List.of()));
    }

    @Test
    public void deveRejeitarItemComValorNulo() {

        // Arrays.asList permite null; List.of não permite.
        List<BigDecimal> valores = Arrays.asList(
            new BigDecimal("150.00"),
            null
        );

        assertThrows(IllegalArgumentException.class, 
        		() -> ExecucaoValidacao.calcularTotal(valores));
    }

    @Test
    public void deveRejeitarItemNegativoMesmoComTotalPositivo() {

        List<BigDecimal> valores = List.of(
            new BigDecimal("150.00"),
            new BigDecimal("-10.00")
        );

        assertThrows(IllegalArgumentException.class, 
        		() -> ExecucaoValidacao.calcularTotal(valores));
    }

    @Test
    public void deveRejeitarFracoesDeCentavoMesmoSeASomaForExata() {

        // A soma seria 1.00, mas os valores individuais são inválidos.
        List<BigDecimal> valores = List.of(
            new BigDecimal("0.001"),
            new BigDecimal("0.999")
        );

        assertThrows(IllegalArgumentException.class, 
        		() -> ExecucaoValidacao.calcularTotal(valores));
    }
    
}//class ExecucaoValidacaoTest.