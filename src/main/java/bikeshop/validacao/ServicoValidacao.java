package bikeshop.validacao;

import java.math.BigDecimal;

public class ServicoValidacao {

    public static boolean nomeValido(String nome) {

        if (nome == null) {
            return false;
        }

        String nomeTratado = nome.strip();

        return !nomeTratado.isBlank() && nomeTratado.length() <= 120;
    }
    
    public static boolean valorValido(BigDecimal valor) {

        if (valor == null) {
            return false;
        }

        //Impede ultrapassar a capacidade da coluna.
        BigDecimal valorMaximo = new BigDecimal("99999999.99");

        return valor.compareTo(BigDecimal.ZERO) >= 0
            && valor.compareTo(valorMaximo) <= 0
            //rejeita frações menores que um centavo, como 150.001.
            //Mas aceita 150.000, pois os zeros extras não mudam o valor
            && valor.stripTrailingZeros().scale() <= 2;
    }
    
}//class ServicoValidacao.