package bikeshop.servlet;

import java.io.IOException;

import bikeshop.logica.Logica;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/mvc")
public class ControllerServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String parametro = request.getParameter("logica");
		String nomeDaclasse = "bikeshop.logica." + parametro;
	
		try {
			
			Class<?> classe = Class.forName(nomeDaclasse);
			Logica logica = (Logica) classe.getDeclaredConstructor().newInstance();
			logica.executa(request, response);
			
		} catch (Exception e) {
			
			throw new ServletException(e);
		}
	
	}
	
	
}//class ControllerServlet.
