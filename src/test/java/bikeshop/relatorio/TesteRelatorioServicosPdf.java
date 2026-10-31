package bikeshop.relatorio;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import bikeshop.modelo.Bicicleta;
import bikeshop.modelo.Cliente;
import bikeshop.modelo.ItemOrdemServico;
import bikeshop.modelo.OrdemServico;
import bikeshop.modelo.Servico;
import bikeshop.validacao.RelatorioCalculo;

public class TesteRelatorioServicosPdf {

    public static void main(String[] args) throws IOException {

        LocalDate dataInicial = LocalDate.of(2026, 10, 1);
        LocalDate dataFinal = LocalDate.of(2026, 10, 31);

        List<OrdemServico> ordens = new ArrayList<>();

        for (int numero = 1; numero <= 8; numero++) {
            ordens.add(criarOrdem(numero));
        }

        BigDecimal total = RelatorioCalculo.calcularTotal(ordens);

        RelatorioServicosPdf gerador = new RelatorioServicosPdf();

        byte[] pdf = gerador.gerar(
            dataInicial,
            dataFinal,
            ordens,
            total
        );

        salvar("teste-relatorio-servicos.pdf", pdf);

        List<OrdemServico> ordensVazias = List.of();

        byte[] pdfVazio = gerador.gerar(
            dataInicial,
            dataFinal,
            ordensVazias,
            RelatorioCalculo.calcularTotal(ordensVazias)
        );

        salvar("teste-relatorio-vazio.pdf", pdfVazio);

        System.out.println("Quantidade de OS: " + ordens.size());
        System.out.println("Total esperado: 3500.00");
        System.out.println("Total calculado: " + total);
    }

    private static OrdemServico criarOrdem(int numero) {

        Cliente cliente = new Cliente();

        cliente.setNome(
            "João da Conceição e Silva — Cliente de teste " + numero
        );
        cliente.setCpf("52998224725");

        Bicicleta bicicleta = new Bicicleta();

        bicicleta.setMarca("Marca de teste");
        bicicleta.setModelo(
            "Bicicleta elétrica para passeios urbanos e viagens prolongadas"
        );

        // Texto sem espaços para testar a quebra de uma sequência longa.
        bicicleta.setNumeroSerie("W".repeat(50));

        OrdemServico ordem = new OrdemServico();

        ordem.setId((long) numero);
        ordem.setCliente(cliente);
        ordem.setBicicleta(bicicleta);
        ordem.setDataAgendamento(LocalDate.of(2026, 10, numero));
        ordem.setDataExecucao(LocalDate.of(2026, 10, numero));

        adicionarItem(
            ordem,
            "Revisão completa",
            "150.00"
        );

        adicionarItem(
            ordem,
            "Regulagem de câmbio",
            "50.00"
        );

        adicionarItem(
            ordem,
            "Limpeza, lubrificação e inspeção dos componentes "
            + "da transmissão para utilização em trajetos prolongados",
            "50.00"
        );

        // Uma OS maior para testar a continuação entre páginas.
        if (numero == 1) {

            for (int item = 1; item <= 40; item++) {
                adicionarItem(
                    ordem,
                    "Serviço complementar de teste " + item,
                    "40.00"
                );
            }
        }

        BigDecimal totalOrdem = BigDecimal.ZERO;

        for (ItemOrdemServico item : ordem.getItens()) {
            totalOrdem = totalOrdem.add(item.getValor());
        }

        ordem.setValorTotal(totalOrdem.setScale(2));

        if (numero % 2 == 0) {
            ordem.setStatus("PAGA");
            ordem.setDesconto(new BigDecimal("25.00"));

        } else {
            ordem.setStatus("EXECUTADA");
            ordem.setDesconto(new BigDecimal("0.00"));
        }

        return ordem;
    }

    private static void adicionarItem(OrdemServico ordem, String nome, String valor) {

        Servico servico = new Servico();
        servico.setNome(nome);

        ItemOrdemServico item = new ItemOrdemServico();

        item.setServico(servico);
        item.setValor(new BigDecimal(valor));
        item.setExecutado(true);

        ordem.getItens().add(item);
    }

    private static void salvar(String nomeArquivo, byte[] conteudo) throws IOException {

        Path arquivo = Path.of("target", nomeArquivo);

        Files.createDirectories(arquivo.getParent());
        Files.write(arquivo, conteudo);

        System.out.println("PDF gerado em: " + arquivo.toAbsolutePath());
    }
    
}//class TesteRelatorioServicosPdf.