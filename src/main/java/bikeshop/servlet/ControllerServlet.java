package bikeshop.servlet;

import java.io.IOException;

import bikeshop.logica.Logica;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/mvc")
public class ControllerServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		
		String parametro = request.getParameter("logica");
		
		if (parametro == null || parametro.isBlank()) {
			
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nenhuma lógica foi informada.");
			
			//Se os dados estiverem errados já barra a execução.
			return;
		}

		// Exige autenticação para todas as ações, exceto o login.
		if (!"LoginLogica".equals(parametro)) {
			
			HttpSession session = request.getSession(false);
			
			if (session == null || !Boolean.TRUE.equals(session.getAttribute("usuarioLogado"))) {
				
				response.sendRedirect(request.getContextPath() + "/login-admin.jsp");
				return;
			}
			
		}
		
		String nomeDaClasse = "bikeshop.logica." + parametro;

		try {

		    Class<?> classe = Class.forName(nomeDaClasse);

		    if (!Logica.class.isAssignableFrom(classe) || classe.isInterface()) {

		        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Operação não encontrada.");
		        
		        return;
		    }

		    Logica logica = (Logica) classe.getDeclaredConstructor().newInstance();

		    logica.executa(request, response);

		} catch (ClassNotFoundException e) {

		    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Operação não encontrada.");

		} catch (Exception e) {

		    // Registra os detalhes técnicos no log do servidor.
		    getServletContext().log("Falha ao executar a operação: " + parametro, e);

		    // O web.xml encaminha o erro para erro.jsp.
		    throw new ServletException("Não foi possível concluir a operação.", e);
		}
	}
	
}//class ControllerServlet.
