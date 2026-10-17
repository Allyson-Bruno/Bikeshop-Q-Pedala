package bikeshop.excecao;

public class NumeroSerieJaCadastradoException extends RuntimeException {

	 private static final long serialVersionUID = 1L;

	    public NumeroSerieJaCadastradoException(Throwable causa) {
	        super("Já existe uma bicicleta cadastrada com esse número de série.", causa);
	    }
	
}//class NumeroSerieJaCadastradoException.
