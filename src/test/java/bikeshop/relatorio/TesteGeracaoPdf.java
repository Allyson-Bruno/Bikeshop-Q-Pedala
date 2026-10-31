package bikeshop.relatorio;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType0Font;

public class TesteGeracaoPdf {

    public static void main(String[] args) throws IOException {

        Path arquivo = Path.of("target", "teste-fontes-pdfbox.pdf");

        Files.createDirectories(arquivo.getParent());

        try (PDDocument documento = new PDDocument()) {

        	
            PDType0Font fonteRegular = carregarFonte(documento, "/fontes/NotoSans-Regular.ttf");

            PDType0Font fonteNegrito = carregarFonte(documento,"/fontes/NotoSans-Bold.ttf");

            PDPage pagina = new PDPage(PDRectangle.A4);

            documento.addPage(pagina);

            try (PDPageContentStream conteudo = new PDPageContentStream(documento, pagina)) {

                conteudo.beginText();

                conteudo.newLineAtOffset(50, pagina.getMediaBox().getHeight() - 60);

                conteudo.setFont(fonteNegrito, 16);
                conteudo.showText("BikeShop Q-Pedala");

                conteudo.newLineAtOffset(0, -30);

                conteudo.setFont(fonteRegular, 12);
                conteudo.showText("Relatório de serviços prestados");

                conteudo.newLineAtOffset(0, -22);
                conteudo.showText("Cliente: João — Bicicleta elétrica");

                conteudo.newLineAtOffset(0, -22);
                conteudo.showText("Serviço: revisão, regulagem e lubrificação.");

                conteudo.newLineAtOffset(0, -22);
                conteudo.showText("Valor final: R$ 150,00");

                conteudo.endText();
            }

            documento.save(arquivo.toFile());
        }

        System.out.println("PDF gerado em: " + arquivo.toAbsolutePath());
    }

    private static PDType0Font carregarFonte(PDDocument documento, String caminho) throws IOException {

    	//getResourceAsStream() busca a fonte nos recursos do projeto. 
    	//O caminho começa em /fontes/, sem incluir src/main/resources
        try (InputStream entrada = TesteGeracaoPdf.class.getResourceAsStream(caminho)) {

            if (entrada == null) {
                throw new IOException("Fonte não encontrada nos recursos: " + caminho);
            }

            //PDType0Font.load() carrega a fonte e a associa ao documento.
            return PDType0Font.load(documento, entrada, true);
        }
    }
    
}//class TesteGeracaoPdf.