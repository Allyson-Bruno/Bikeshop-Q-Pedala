package bikeshop.validacao;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Year;

import org.junit.jupiter.api.Test;

public class BicicletaValidacaoTest {

    // Marca
    @Test
    public void deveAceitarMarcaPreenchida() {
        assertTrue(BicicletaValidacao.marcaValida("Caloi"));
    }

    @Test
    public void deveRejeitarMarcaNula() {
        assertFalse(BicicletaValidacao.marcaValida(null));
    }

    @Test
    public void deveRejeitarMarcaVaziaOuComApenasEspacos() {
        assertFalse(BicicletaValidacao.marcaValida(""));
        assertFalse(BicicletaValidacao.marcaValida("   "));
    }

    @Test
    public void deveAceitarMarcaCom60Caracteres() {
        assertTrue(BicicletaValidacao.marcaValida("A".repeat(60)));
    }

    @Test
    public void deveRejeitarMarcaCom61Caracteres() {
        assertFalse(BicicletaValidacao.marcaValida("A".repeat(61)));
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDaMarca() {
        String marca = "  " + "A".repeat(60) + "  ";

        assertTrue(BicicletaValidacao.marcaValida(marca));
    }

    // Modelo
    @Test
    public void deveAceitarModeloPreenchido() {
        assertTrue(BicicletaValidacao.modeloValido("Elite Carbon"));
    }

    @Test
    public void deveRejeitarModeloNulo() {
        assertFalse(BicicletaValidacao.modeloValido(null));
    }

    @Test
    public void deveRejeitarModeloVazioOuComApenasEspacos() {
        assertFalse(BicicletaValidacao.modeloValido(""));
        assertFalse(BicicletaValidacao.modeloValido("   "));
    }

    @Test
    public void deveAceitarModeloCom100Caracteres() {
        assertTrue(BicicletaValidacao.modeloValido("A".repeat(100)));
    }

    @Test
    public void deveRejeitarModeloCom101Caracteres() {
        assertFalse(BicicletaValidacao.modeloValido("A".repeat(101)));
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDoModelo() {
        String modelo = "  " + "A".repeat(100) + "  ";

        assertTrue(BicicletaValidacao.modeloValido(modelo));
    }
    
    @Test
    public void deveAceitarTiposDefinidos() {

        String[] tipos = {"MTB", "Road", "Gravel", "BMX", "Elétrica"};

        for (String tipo : tipos) {
            assertTrue(BicicletaValidacao.tipoValido(tipo), tipo);
        }
    }

    @Test
    public void deveRejeitarTipoNulo() {
        assertFalse(BicicletaValidacao.tipoValido(null));
    }

    @Test
    public void deveRejeitarTipoVazioOuComApenasEspacos() {
        assertFalse(BicicletaValidacao.tipoValido(""));
        assertFalse(BicicletaValidacao.tipoValido("   "));
    }

    @Test
    public void deveRejeitarTipoForaDasOpcoes() {
        assertFalse(BicicletaValidacao.tipoValido("Outro"));
    }

    @Test
    public void deveRejeitarTipoComEscritaDiferente() {
        assertFalse(BicicletaValidacao.tipoValido("mtb"));
        assertFalse(BicicletaValidacao.tipoValido("Eletrica"));
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDoTipo() {
        assertTrue(BicicletaValidacao.tipoValido("  MTB  "));
    }
    
    @Test
    public void deveAceitarTamanhoQuadroPreenchido() {
        assertTrue(BicicletaValidacao.tamanhoQuadroValido("17"));
        assertTrue(BicicletaValidacao.tamanhoQuadroValido("54 cm"));
        assertTrue(BicicletaValidacao.tamanhoQuadroValido("M"));
    }

    @Test
    public void deveRejeitarTamanhoQuadroNulo() {
        assertFalse(BicicletaValidacao.tamanhoQuadroValido(null));
    }

    @Test
    public void deveRejeitarTamanhoQuadroVazioOuComApenasEspacos() {
        assertFalse(BicicletaValidacao.tamanhoQuadroValido(""));
        assertFalse(BicicletaValidacao.tamanhoQuadroValido("   "));
    }

    @Test
    public void deveAceitarTamanhoQuadroCom30Caracteres() {
        assertTrue(BicicletaValidacao.tamanhoQuadroValido("A".repeat(30)));
    }

    @Test
    public void deveRejeitarTamanhoQuadroCom31Caracteres() {
        assertFalse(BicicletaValidacao.tamanhoQuadroValido("A".repeat(31)));
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDoTamanhoQuadro() {
        String tamanho = "  " + "A".repeat(30) + "  ";

        assertTrue(BicicletaValidacao.tamanhoQuadroValido(tamanho));
    }
    
    //Início dos testes do número de série.
    @Test
    public void deveAceitarNumeroSeriePreenchido() {
        assertTrue(BicicletaValidacao.numeroSerieValido("ABC-2026-001"));
        assertTrue(BicicletaValidacao.numeroSerieValido("123456789"));
    }

    @Test
    public void deveRejeitarNumeroSerieNulo() {
        assertFalse(BicicletaValidacao.numeroSerieValido(null));
    }

    @Test
    public void deveRejeitarNumeroSerieVazioOuComApenasEspacos() {
        assertFalse(BicicletaValidacao.numeroSerieValido(""));
        assertFalse(BicicletaValidacao.numeroSerieValido("   "));
    }

    @Test
    public void deveAceitarNumeroSerieCom50Caracteres() {
        assertTrue(BicicletaValidacao.numeroSerieValido("A".repeat(50)));
    }

    @Test
    public void deveRejeitarNumeroSerieCom51Caracteres() {
        assertFalse(BicicletaValidacao.numeroSerieValido("A".repeat(51)));
    }

    @Test
    public void deveDesconsiderarEspacosNasExtremidadesDoNumeroSerie() {
        String numero = "  " + "A".repeat(50) + "  ";

        assertTrue(BicicletaValidacao.numeroSerieValido(numero));
    }
    
    //Testes do ano de fabricação.
    @Test
    public void deveAceitarAnoFabricacaoDentroDoIntervalo() {
        assertTrue(BicicletaValidacao.anoFabricacaoValido((short) 2020));
    }

    @Test
    public void deveRejeitarAnoFabricacaoNulo() {
        assertFalse(BicicletaValidacao.anoFabricacaoValido(null));
    }

    @Test
    public void deveAceitarAnoFabricacaoMinimo() {
        assertTrue(BicicletaValidacao.anoFabricacaoValido((short) 1800));
    }

    @Test
    public void deveRejeitarAnoFabricacaoAbaixoDoMinimo() {
        assertFalse(BicicletaValidacao.anoFabricacaoValido((short) 1799));
    }

    @Test
    public void deveAceitarAnoFabricacaoAtual() {
        short anoAtual = (short) Year.now().getValue();

        assertTrue(BicicletaValidacao.anoFabricacaoValido(anoAtual));
    }

    @Test
    public void deveRejeitarAnoFabricacaoFuturo() {
        short anoFuturo = (short) (Year.now().getValue() + 1);

        assertFalse(BicicletaValidacao.anoFabricacaoValido(anoFuturo));
    }
    
    
}//class BicicletaValidacaoTest.