package bikeshop.modelo;

public class Bicicleta {

    private Long id;
    private String marca;
    private String modelo;
    private String tipo;
    private String tamanhoQuadro;
    private String numeroSerie;
    private Short anoFabricacao;
    private Cliente proprietario;

    public Bicicleta() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getTamanhoQuadro() {
        return tamanhoQuadro;
    }

    public void setTamanhoQuadro(String tamanhoQuadro) {
        this.tamanhoQuadro = tamanhoQuadro;
    }

    public String getNumeroSerie() {
        return numeroSerie;
    }

    public void setNumeroSerie(String numeroSerie) {
        this.numeroSerie = numeroSerie;
    }

    public Short getAnoFabricacao() {
        return anoFabricacao;
    }

    public void setAnoFabricacao(Short anoFabricacao) {
        this.anoFabricacao = anoFabricacao;
    }

    public Cliente getProprietario() {
        return proprietario;
    }

    public void setProprietario(Cliente proprietario) {
        this.proprietario = proprietario;
    }
    
}//class Bicicleta.
