package bikeshop.validacao;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ExecucaoValidacao {

    public static boolean dataExecucaoValida(LocalDate data) {

        if (data == null) {
            return false;
        }

        //Não sendo aceito somente datas que estão no futuro.
        return !data.isAfter(LocalDate.now());
    }
    
    public static boolean itensSelecionadosValidos(String[] idItens) {

        if (idItens == null || idItens.length == 0) {
            return false;
        }

        Set<Long> idsEncontrados = new HashSet<>();

        for (String idInformado : idItens) {

            if (idInformado == null || !idInformado.matches("[0-9]+")) {
                return false;
            }

            try {
                long id = Long.parseLong(idInformado);

                // add() retorna false se o ID já estiver no conjunto.
                if (id <= 0 || !idsEncontrados.add(id)) {
                    return false;
                }

            } catch (NumberFormatException e) {
                // Também rejeita números maiores que o limite de Long.
                return false;
            }
        }

        return true;
    }

    public static BigDecimal converterValor(String valorInformado) {

        return ServicoValidacao.converterValor(valorInformado);
    }

    public static boolean valorItemValido(BigDecimal valor) {

        return ServicoValidacao.valorValido(valor);
    }
    
    public static BigDecimal calcularTotal(List<BigDecimal> valores) {

        if (valores == null || valores.isEmpty()) {
            throw new IllegalArgumentException(
                "Selecione pelo menos um serviço realizado."
            );
        }

        BigDecimal total = BigDecimal.ZERO;

        for (BigDecimal valor : valores) {

            if (!valorItemValido(valor)) {
                throw new IllegalArgumentException(
                    "Todos os serviços selecionados devem possuir um valor válido."
                );
            }

            total = total.add(valor);
        }

        if (total.compareTo(new BigDecimal("99999999.99")) > 0) {
            throw new IllegalArgumentException(
                "O valor total da OS não pode ultrapassar R$ 99.999.999,99."
            );
        }

        return total.setScale(2);
    }
    
    
}//class ExecucaoValidacao.