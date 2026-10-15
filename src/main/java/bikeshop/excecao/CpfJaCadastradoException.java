package bikeshop.excecao;

public class CpfJaCadastradoException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    //Parâmetro causa preserva o erro original do banco.
    public CpfJaCadastradoException(Throwable causa) {
        super("Já existe um cliente cadastrado com esse CPF.", causa);
    }
    
}//class CpfJaCadastradoException.