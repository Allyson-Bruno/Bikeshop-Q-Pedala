package bikeshop.logica;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogoutLogica implements Logica {

	@Override
	public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

		//Recuperando uma sessão já existente, sem que seja criado uma nova.
		HttpSession session = request.getSession(false);
		
		if (session != null) {
			//Destruindo a sessão.
			session.invalidate();
		}
		
		//Redireciona o usuário para a página de login.
		response.sendRedirect(request.getContextPath()  + "/login-admin.jsp");
		
	}
	
}//class LogoutLogic.
