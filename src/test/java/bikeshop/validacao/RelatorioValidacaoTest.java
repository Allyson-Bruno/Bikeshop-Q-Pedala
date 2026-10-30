package bikeshop.validacao;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDate;

import org.junit.jupiter.api.Test;

public class RelatorioValidacaoTest {

    @Test
    public void deveAceitarIntervaloEmOrdemCronologica() {

        LocalDate inicio = LocalDate.of(2026, 10, 1);
        LocalDate fim = LocalDate.of(2026, 10, 30);

        assertTrue(RelatorioValidacao.intervaloValido(inicio, fim));
    }

    @Test
    public void deveAceitarConsultaDeUmUnicoDia() {

        LocalDate data = LocalDate.of(2026, 10, 15);

        assertTrue(RelatorioValidacao.intervaloValido(data, data));
    }

    @Test
    public void deveRejeitarIntervaloInvertido() {

        LocalDate inicio = LocalDate.of(2026, 10, 30);
        LocalDate fim = LocalDate.of(2026, 10, 1);

        assertFalse(RelatorioValidacao.intervaloValido(inicio, fim));
    }

    @Test
    public void deveRejeitarDataInicialNula() {

        assertFalse(RelatorioValidacao.intervaloValido(null, LocalDate.of(2026, 10, 30)));
    }

    @Test
    public void deveRejeitarDataFinalNula() {

        assertFalse(RelatorioValidacao.intervaloValido(LocalDate.of(2026, 10, 1), null));
    }

    @Test
    public void deveRejeitarAmbasAsDatasNulas() {

        assertFalse(RelatorioValidacao.intervaloValido(null, null));
    }

    @Test
    public void deveAceitarIntervaloEntreAnosDiferentes() {

        LocalDate inicio = LocalDate.of(2025, 12, 31);
        LocalDate fim = LocalDate.of(2026, 1, 1);

        assertTrue(RelatorioValidacao.intervaloValido(inicio, fim));
    }

    @Test
    public void deveAceitarIntervaloFuturo() {

        LocalDate inicio = LocalDate.now().plusDays(1);
        LocalDate fim = inicio.plusDays(10);

        assertTrue(RelatorioValidacao.intervaloValido(inicio, fim));
    }
    
}//class RelatorioValidacaoTest.