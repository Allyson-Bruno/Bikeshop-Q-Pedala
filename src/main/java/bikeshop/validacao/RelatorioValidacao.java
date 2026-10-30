package bikeshop.validacao;

import java.time.LocalDate;

public class RelatorioValidacao {

    public static boolean intervaloValido(LocalDate dataInicial, LocalDate dataFinal) {

        if (dataInicial == null || dataFinal == null) {
            return false;
        }

        // Aceita a data inicial anterior ou igual à final.
        return !dataInicial.isAfter(dataFinal);
    }
    
}//class RelatorioValidacao.