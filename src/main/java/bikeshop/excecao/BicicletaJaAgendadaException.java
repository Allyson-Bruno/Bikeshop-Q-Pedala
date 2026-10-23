package bikeshop.excecao;

public class BicicletaJaAgendadaException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public BicicletaJaAgendadaException(Throwable causa) {
        super("Essa bicicleta já possui uma OS agendada para essa data.", causa);
    }
    
}//class BicicletaJaAgendadaException.