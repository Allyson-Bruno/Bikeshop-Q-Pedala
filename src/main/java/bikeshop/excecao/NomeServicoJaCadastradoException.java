package bikeshop.excecao;

public class NomeServicoJaCadastradoException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public NomeServicoJaCadastradoException(Throwable causa) {
        super("Já existe um serviço cadastrado com esse nome.", causa);
    }
    
}//class NomeServicoJaCadastradoException.