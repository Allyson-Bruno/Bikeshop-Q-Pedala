package bikeshop.validacao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.Test;

import bikeshop.modelo.ItemOrdemServico;
import bikeshop.modelo.OrdemServico;

public class RelatorioCalculoTest {

    @Test
    public void deveRetornarZeroParaRelatorioVazio() {

        assertEquals(new BigDecimal("0.00"), RelatorioCalculo.calcularTotal(List.of()));
    }

    @Test
    public void deveSomarOrdensSemDesconto() {

        OrdemServico primeira = criarOrdem("150.00", "0.00");
        OrdemServico segunda = criarOrdem("50.00", "0.00");

        assertEquals(new BigDecimal("200.00"), 
        		RelatorioCalculo.calcularTotal(List.of(primeira, segunda)));
    }

    @Test
    public void deveSubtrairOsDescontosRegistrados() {

        OrdemServico primeira = criarOrdem("300.00", "30.00");
        OrdemServico segunda = criarOrdem("150.00", "0.00");

        assertEquals(new BigDecimal("420.00"), 
        		RelatorioCalculo.calcularTotal(List.of(primeira, segunda)));
    }

    @Test
    public void deveUsarODescontoJaArredondadoDaOrdem() {

        OrdemServico ordem = criarOrdem("100.05", "10.01");

        assertEquals(new BigDecimal("90.04"), 
        		RelatorioCalculo.calcularTotal(List.of(ordem)));
    }

    @Test
    public void deveSomarCentavosComPrecisao() {

        OrdemServico primeira = criarOrdem("0.10", "0.00");
        OrdemServico segunda = criarOrdem("0.20", "0.00");

        assertEquals(new BigDecimal("0.30"), 
        		RelatorioCalculo.calcularTotal(List.of(primeira, segunda)));
    }

    @Test
    public void deveContarUmaOrdemUmaVezMesmoComVariosItens() {

        OrdemServico ordem = criarOrdem("300.00", "30.00");

        for (int i = 0; i < 3; i++) {

            ItemOrdemServico item = new ItemOrdemServico();

            item.setExecutado(true);
            item.setValor(new BigDecimal("100.00"));

            ordem.getItens().add(item);
        }

        assertEquals(new BigDecimal("270.00"), 
        		RelatorioCalculo.calcularTotal(List.of(ordem)));
    }

    @Test
    public void devePermitirTotalMaiorQueLimiteDeUmaUnicaOrdem() {

        OrdemServico primeira = criarOrdem("99999999.99", "0.00");
        OrdemServico segunda = criarOrdem("0.01", "0.00");

        assertEquals(new BigDecimal("100000000.00"), 
        		RelatorioCalculo.calcularTotal(List.of(primeira, segunda)));
    }

    @Test
    public void deveRejeitarListaNula() {

        assertThrows(IllegalArgumentException.class, 
        		() -> RelatorioCalculo.calcularTotal(null));
    }

    @Test
    public void deveRejeitarOrdemNula() {

        List<OrdemServico> ordens = Arrays.asList(criarOrdem("150.00", "0.00"), null);

        assertThrows(IllegalArgumentException.class, 
        		() -> RelatorioCalculo.calcularTotal(ordens));
    }

    @Test
    public void deveRejeitarDescontoMaiorQueTotal() {

        OrdemServico ordem = criarOrdem("100.00", "110.00");

        assertThrows(
            IllegalArgumentException.class,
            () -> RelatorioCalculo.calcularTotal(List.of(ordem))
        );
    }

    @Test
    public void deveRejeitarValoresNaoPreenchidos() {

        OrdemServico semTotal = criarOrdem("100.00", "0.00");
        semTotal.setValorTotal(null);

        OrdemServico semDesconto = criarOrdem("100.00", "0.00");
        semDesconto.setDesconto(null);

        assertThrows(
            IllegalArgumentException.class,
            () -> RelatorioCalculo.calcularTotal(List.of(semTotal))
        );

        assertThrows(
            IllegalArgumentException.class,
            () -> RelatorioCalculo.calcularTotal(List.of(semDesconto))
        );
    }

    private OrdemServico criarOrdem(String total, String desconto) {

        OrdemServico ordem = new OrdemServico();

        ordem.setValorTotal(new BigDecimal(total));
        ordem.setDesconto(new BigDecimal(desconto));

        return ordem;
    }
    
}//class RelatorioCalculoTest.