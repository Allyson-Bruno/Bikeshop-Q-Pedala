package bikeshop.validacao;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

public class AgendamentoValidacao {

    public static boolean dataAgendamentoValida(LocalDate data) {

        if (data == null) {
            return false;
        }
        
        /*
         * O isBefore() verifica se a data está antes de hoje. 
         * O ! inverte o resultado: se não está no passado, é aceita.
         */

        return !data.isBefore(LocalDate.now());
    }
    
    public static boolean servicosValidos(String[] idsServicos) {

        if (idsServicos == null || idsServicos.length == 0) {
            return false;
        }

        Set<Long> idsEncontrados = new HashSet<>();

        for (String idInformado : idsServicos) {

            if (idInformado == null || !idInformado.matches("[0-9]+")) {

                return false;
            }

            try {
            	
                Long id = Long.valueOf(idInformado);

                if (id <= 0 || !idsEncontrados.add(id)) {
                    return false;
                }

            } catch (NumberFormatException e) {
                return false;
            }
        }

        return true;
    }
    
    
}//class AgendamentoValidacao.