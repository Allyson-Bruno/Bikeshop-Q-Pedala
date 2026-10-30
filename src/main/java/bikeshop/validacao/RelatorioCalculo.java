package bikeshop.validacao;

import java.math.BigDecimal;
import java.util.List;

import bikeshop.modelo.OrdemServico;

public class RelatorioCalculo {

    public static BigDecimal calcularTotal(List<OrdemServico> ordens) {

        if (ordens == null) {
            throw new IllegalArgumentException("A lista de ordens não pode ser nula.");
        }

        BigDecimal totalRelatorio = new BigDecimal("0.00");

        for (OrdemServico ordem : ordens) {

            if (ordem == null) {
                throw new IllegalArgumentException("A lista contém uma ordem inválida.");
            }

            BigDecimal totalOrdem = ordem.getValorTotal();
            BigDecimal desconto = ordem.getDesconto();

            if (!ServicoValidacao.valorValido(totalOrdem) || !ServicoValidacao.valorValido(desconto)
                    || desconto.compareTo(totalOrdem) > 0) {

                throw new IllegalArgumentException("A OS possui total ou desconto inválido.");
            }

            BigDecimal valorFinal = totalOrdem.subtract(desconto);

            totalRelatorio = totalRelatorio.add(valorFinal);
        }

        return totalRelatorio.setScale(2);
    }
    
}//class RelatorioCalculo.