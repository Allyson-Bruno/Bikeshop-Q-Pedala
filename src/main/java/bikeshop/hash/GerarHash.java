package bikeshop.hash;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Classe responsável por gerar o HASH necessário para o cadastrado do administrador.
 * Lembrando que o cadastro do administrador só é permitido via SGBD.
 * 
 */

public class GerarHash {

	public GerarHash() {
		
		String senha = "";
		
		String hash = BCrypt.hashpw(senha, BCrypt.gensalt(12));
		
		System.out.println(hash);
	}

	public static void main(String[] args) {
		new GerarHash();
	}
	
}//class GerarHash.
