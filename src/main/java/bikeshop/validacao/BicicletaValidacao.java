package bikeshop.validacao;

import java.time.Year;

public class BicicletaValidacao {

	//Marca.
    public static boolean marcaValida(String marca) {

        if (marca == null) {
            return false;
        }

        String marcaTratada = marca.strip();

        return !marcaTratada.isBlank() && marcaTratada.length() <= 60;
    }

    //Modelo
    public static boolean modeloValido(String modelo) {

        if (modelo == null) {
            return false;
        }

        String modeloTratado = modelo.strip();

        return !modeloTratado.isBlank() && modeloTratado.length() <= 100;
    }
    
    //Tipo da bicicleta.
    public static boolean tipoValido(String tipo) {

        if (tipo == null) {
            return false;
        }

        return switch (tipo.strip()) {
            case "MTB", "Road", "Gravel", "BMX", "Elétrica" -> true;
            default -> false;
        };
    }
    
    //Tamanho do quadro.
    public static boolean tamanhoQuadroValido(String tamanhoQuadro) {

        if (tamanhoQuadro == null) {
            return false;
        }

        String tamanhoTratado = tamanhoQuadro.strip();

        return !tamanhoTratado.isBlank() && tamanhoTratado.length() <= 30;
    }
    
    //Número de série.
    public static boolean numeroSerieValido(String numeroSerie) {

        if (numeroSerie == null) {
            return false;
        }

        String numeroTratado = numeroSerie.strip();

        return !numeroTratado.isBlank() && numeroTratado.length() <= 50;
    }
    
    //Ano de fabricação.
    public static boolean anoFabricacaoValido(Short anoFabricacao) {

        if (anoFabricacao == null) {
            return false;
        }

        int anoAtual = Year.now().getValue();

        return anoFabricacao >= 1800 && anoFabricacao <= anoAtual;
    }
    
    
}//class BicicletaValidacao.