package bikeshop.logica;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface Logica {

	void executa(HttpServletRequest request, HttpServletResponse response)
		throws Exception;
	
	
}//interface Logica.
