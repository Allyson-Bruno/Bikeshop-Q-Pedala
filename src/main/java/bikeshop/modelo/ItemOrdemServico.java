package bikeshop.modelo;

import java.math.BigDecimal;

public class ItemOrdemServico {

    private Long id;
    private Servico servico;
    private BigDecimal valor;
    private boolean executado;

    public ItemOrdemServico() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Servico getServico() {
        return servico;
    }

    public void setServico(Servico servico) {
        this.servico = servico;
    }

    public BigDecimal getValor() {
        return valor;
    }

    public void setValor(BigDecimal valor) {
        this.valor = valor;
    }

    public boolean isExecutado() {
        return executado;
    }

    public void setExecutado(boolean executado) {
        this.executado = executado;
    }
    
}//class ItemOrdemServico.
