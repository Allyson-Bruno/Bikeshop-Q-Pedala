package bikeshop.logica;

import bikeshop.dao.AdministradorDAO;
import bikeshop.hash.SenhaUtil;
import bikeshop.modelo.Administrador;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginLogica implements Logica {

	@Override
	public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

		//Recuperando os dados formulário "login-admin".
		String usuario = request.getParameter("usuario");
		String senha = request.getParameter("senha");

		//Define para onde o usuário será redirecionado:
		String url;

		AdministradorDAO admDAO = new AdministradorDAO();
		
		Administrador adm = admDAO.buscarPorUsuario(usuario);
		
		//Verifica se o ADM existe e se a senha está correta.
		if(adm != null && SenhaUtil.verificar(senha, adm.getSenha())) {
			
			//Cria uma nova sessão após autenticar.
			HttpSession session = request.getSession(false);
			
			/*
			 * Ao invalidá-la e criar outra depois da autenticação, 
			 * evita-se reutilizar a sessão antiga para o usuário autenticado.
			 */
			if (session != null) {
				session.invalidate();
			}
			
			session = request.getSession(true);
			
			//Definindo o tempo de inatividade para 2 minutos como solicitado (120 segundos).
			session.setMaxInactiveInterval(2 * 60);
			
			//É armazenado o status na sessão como verdadeiro.
			session.setAttribute("usuarioLogado", true);
			
			//Armazena o nome do usuário logado na sessão.
			session.setAttribute("usuario", usuario);
			
			//Definindo para onde o usuário será redirecionado.
			url = "menu-principal.jsp";
		
		} else {
			url = "login-admin.jsp";
		}
		
		//Realiza o redirecionamento do usuário.
		response.sendRedirect(request.getContextPath() + "/" + url);
	}
	
}//class LoginLogica.
