package bikeshop.validacao;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class PagamentoValidacao {
	
	/*
	 * As regras serão:
	 * A OS deve ter pelo menos um serviço realizado.
	 * Com três ou mais serviços realizados, o administrador pode confirmar o desconto de 10%.
	 * Sem confirmação, o desconto é zero.
	 * Uma tentativa de aplicar desconto com menos de três serviços será rejeitada.
	 */

    private static final BigDecimal TAXA_DESCONTO = new BigDecimal("0.10");

    public static boolean permiteDesconto(int quantidadeExecutada) {
        return quantidadeExecutada >= 3;
    }

    public static BigDecimal calcularDesconto(BigDecimal total, int quantidadeExecutada, boolean aplicarDesconto) {

        if (!ServicoValidacao.valorValido(total)) {
            throw new IllegalArgumentException("O valor total da OS é inválido.");
        }

        if (quantidadeExecutada <= 0) {
            throw new IllegalArgumentException("A OS deve possuir pelo menos um serviço realizado.");
        }

        if (!aplicarDesconto) {
            return new BigDecimal("0.00");
        }

        if (!permiteDesconto(quantidadeExecutada)) {
            throw new IllegalArgumentException("O desconto exige pelo menos três serviços realizados.");
        }

        return total.multiply(TAXA_DESCONTO).setScale(2, RoundingMode.HALF_UP);
    }

    public static BigDecimal calcularValorFinal(BigDecimal total, int quantidadeExecutada, boolean aplicarDesconto) {

        BigDecimal desconto = calcularDesconto(total, quantidadeExecutada, aplicarDesconto);

        return total.subtract(desconto).setScale(2);
    }
    
}//class PagamentoValidacao.