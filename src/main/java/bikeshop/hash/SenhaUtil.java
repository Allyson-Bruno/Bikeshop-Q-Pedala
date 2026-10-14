package bikeshop.hash;

import org.mindrot.jbcrypt.BCrypt;

public class SenhaUtil {

	public static boolean verificar(String senha, String hash) {
		return BCrypt.checkpw(senha, hash);
	}
	
	
}//class SenhaUtil.
