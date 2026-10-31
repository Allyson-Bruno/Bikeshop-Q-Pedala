package bikeshop.relatorio;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType0Font;

import bikeshop.modelo.ItemOrdemServico;
import bikeshop.modelo.OrdemServico;
import bikeshop.validacao.RelatorioValidacao;

public class RelatorioServicosPdf {

    public byte[] gerar(LocalDate dataInicial, LocalDate dataFinal, List<OrdemServico> ordens,
            BigDecimal totalRelatorio) throws IOException {

        if (!RelatorioValidacao.intervaloValido(dataInicial, dataFinal)) {
            throw new IllegalArgumentException("Informe um intervalo de datas válido.");
        }

        if (ordens == null || totalRelatorio == null) {
            throw new IllegalArgumentException("Informe as ordens e o total do relatório.");
        }

        DateTimeFormatter formatoData =
            DateTimeFormatter.ofPattern("dd/MM/yyyy");

        NumberFormat moeda = NumberFormat.getCurrencyInstance(Locale.forLanguageTag("pt-BR"));

        String periodo = formatoData.format(dataInicial)
            + " a " + formatoData.format(dataFinal);

        try (PDDocument documento = new PDDocument();
        	ByteArrayOutputStream saida = new ByteArrayOutputStream()) {

            PDType0Font regular = carregarFonte(
                documento,
                "/fontes/NotoSans-Regular.ttf"
            );

            PDType0Font negrito = carregarFonte(
                documento,
                "/fontes/NotoSans-Bold.ttf"
            );

            try (Escritor escritor = new Escritor(
                    documento, regular, negrito, periodo)) {

                escritor.novaPagina();

                if (ordens.isEmpty()) {
                    escritor.texto(
                        "Nenhum serviço realizado no período informado.",
                        false
                    );
                }

                for (OrdemServico ordem : ordens) {

                    escritor.iniciarOrdem(ordem.getId());

                    escritor.texto(
                        "Data da execução: "
                        + formatoData.format(ordem.getDataExecucao()),
                        false
                    );

                    String status = "PAGA".equals(ordem.getStatus())
                        ? "Paga"
                        : "Executada — pagamento pendente";

                    escritor.texto("Status: " + status, false);

                    escritor.texto(
                        "Cliente: " + ordem.getCliente().getNome()
                        + " — CPF: " + ordem.getCliente().getCpf(),
                        false
                    );

                    escritor.texto(
                        "Bicicleta: " + ordem.getBicicleta().getMarca()
                        + " — " + ordem.getBicicleta().getModelo(),
                        false
                    );

                    escritor.texto(
                        "Número de série: "
                        + ordem.getBicicleta().getNumeroSerie(),
                        false
                    );

                    escritor.texto("Serviços realizados:", true);

                    for (ItemOrdemServico item : ordem.getItens()) {

                        escritor.texto(
                            "- " + item.getServico().getNome()
                            + ": " + moeda.format(item.getValor()),
                            false
                        );
                    }

                    // Mantém os três valores juntos na mesma página.
                    escritor.garantirEspaco(3 * Escritor.ALTURA_LINHA);

                    escritor.texto(
                        "Total dos serviços: "
                        + moeda.format(ordem.getValorTotal()),
                        false
                    );

                    escritor.texto(
                        "Desconto aplicado: "
                        + moeda.format(ordem.getDesconto()),
                        false
                    );

                    BigDecimal valorFinal = ordem.getValorTotal()
                        .subtract(ordem.getDesconto());

                    escritor.texto(
                        "Valor final: " + moeda.format(valorFinal),
                        true
                    );

                    escritor.finalizarOrdem();
                }

                escritor.garantirEspaco(2 * Escritor.ALTURA_LINHA);

                escritor.texto(
                    "Total faturado no período: "
                    + moeda.format(totalRelatorio),
                    true
                );

                escritor.espaco();

                escritor.texto(
                    "O total inclui ordens executadas e pagas, "
                    + "considerando os descontos já registrados. "
                    + "Não representa apenas pagamentos recebidos.",
                    false
                );

                escritor.texto(
                    "Ordens com pagamento pendente ainda podem receber "
                    + "desconto na confirmação do pagamento.",
                    false
                );
            }

            // O conteúdo das páginas já foi fechado neste ponto.
            documento.save(saida);

            return saida.toByteArray();
        }
    }

    private PDType0Font carregarFonte(
            PDDocument documento,
            String caminho) throws IOException {

        try (InputStream entrada =
                RelatorioServicosPdf.class.getResourceAsStream(caminho)) {

            if (entrada == null) {
                throw new IOException(
                    "Fonte não encontrada nos recursos: " + caminho
                );
            }

            return PDType0Font.load(documento, entrada, true);
        }
    }

    /*
     * Cuida apenas da escrita, da quebra de linhas e das páginas.
     * Cada geração possui seu próprio escritor.
     */
    private static class Escritor implements AutoCloseable {

        private static final float MARGEM = 50;
        private static final float TAMANHO_FONTE = 11;
        private static final float ALTURA_LINHA = 17;

        private final PDDocument documento;
        private final PDType0Font regular;
        private final PDType0Font negrito;
        private final String periodo;

        private PDPageContentStream conteudo;
        private float y;
        private Long idOrdemAtual;

        Escritor(
                PDDocument documento,
                PDType0Font regular,
                PDType0Font negrito,
                String periodo) {

            this.documento = documento;
            this.regular = regular;
            this.negrito = negrito;
            this.periodo = periodo;
        }

        void novaPagina() throws IOException {

            if (conteudo != null) {
                conteudo.close();
                conteudo = null;
            }

            PDPage pagina = new PDPage(PDRectangle.A4);
            documento.addPage(pagina);

            conteudo = new PDPageContentStream(documento, pagina);

            y = PDRectangle.A4.getHeight() - MARGEM;

            escreverLinha("BikeShop Q-Pedala", negrito, 16);
            escreverLinha(
                "Relatório de serviços prestados",
                negrito,
                12
            );
            escreverLinha("Período: " + periodo, regular, 10);

            y -= 12;

            // Numeração no rodapé, sem alterar a posição do conteúdo.
            conteudo.beginText();
            conteudo.setFont(regular, 9);
            conteudo.newLineAtOffset(MARGEM, 25);
            conteudo.showText("Página " + documento.getNumberOfPages());
            conteudo.endText();

            if (idOrdemAtual != null) {
                escreverLinha(
                    "OS #" + idOrdemAtual + " — continuação",
                    negrito,
                    TAMANHO_FONTE
                );
            }
        }

        void iniciarOrdem(Long id) throws IOException {

            idOrdemAtual = null;

            // Evita iniciar uma OS muito perto do final da página.
            garantirEspaco(6 * ALTURA_LINHA);

            idOrdemAtual = id;

            texto("Ordem de serviço #" + id, true);
        }

        void finalizarOrdem() {

            idOrdemAtual = null;
            y -= 14;
        }

        void espaco() {
            y -= 10;
        }

        void garantirEspaco(float altura) throws IOException {

            if (y - altura < MARGEM) {
                novaPagina();
            }
        }

        void texto(String texto, boolean usarNegrito) throws IOException {

            PDType0Font fonte = usarNegrito ? negrito : regular;

            // Normaliza espaços e quebras recebidas nos campos.
            String normalizado = texto
                .replace('\u00A0', ' ')
                .replace('\u202F', ' ')
                .replaceAll("\\s+", " ")
                .strip();

            if (normalizado.isEmpty()) {
                return;
            }

            float larguraMaxima =
                PDRectangle.A4.getWidth() - 2 * MARGEM;

            StringBuilder linha = new StringBuilder();

            for (int indice = 0; indice < normalizado.length();) {

                int caractere = normalizado.codePointAt(indice);
                indice += Character.charCount(caractere);

                int tamanhoAnterior = linha.length();
                linha.appendCodePoint(caractere);

                float largura = fonte.getStringWidth(linha.toString())
                    / 1000 * TAMANHO_FONTE;

                if (largura > larguraMaxima) {

                    int ultimoEspaco = linha.lastIndexOf(" ");

                    if (ultimoEspaco >= 0) {

                        emitirLinha(
                            linha.substring(0, ultimoEspaco),
                            fonte
                        );

                        String restante = linha
                            .substring(ultimoEspaco + 1)
                            .stripLeading();

                        linha.setLength(0);
                        linha.append(restante);

                    } else {

                        // Permite quebrar também textos sem espaços,
                        // como números de série muito longos.
                        emitirLinha(
                            linha.substring(0, tamanhoAnterior),
                            fonte
                        );

                        linha.delete(0, tamanhoAnterior);
                    }
                }
            }

            if (!linha.isEmpty()) {
                emitirLinha(linha.toString(), fonte);
            }
        }

        private void emitirLinha(
                String texto,
                PDType0Font fonte) throws IOException {

            garantirEspaco(ALTURA_LINHA);

            escreverLinha(texto, fonte, TAMANHO_FONTE);
        }

        private void escreverLinha(
                String texto,
                PDType0Font fonte,
                float tamanho) throws IOException {

            conteudo.beginText();
            conteudo.setFont(fonte, tamanho);
            conteudo.newLineAtOffset(MARGEM, y);
            conteudo.showText(texto);
            conteudo.endText();

            y -= tamanho + 6;
        }

        @Override
        public void close() throws IOException {

            if (conteudo != null) {
                conteudo.close();
                conteudo = null;
            }
        }
    }
    
}//class RelatorioServicosPdf.