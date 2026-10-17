package bikeshop.logica;

import java.util.List;

import bikeshop.dao.ServicoDAO;
import bikeshop.modelo.Servico;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ListarServicosLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ServicoDAO dao = new ServicoDAO();

        List<Servico> servicos = dao.listaServicos();

        request.setAttribute("servicos", servicos);

        request.getRequestDispatcher("/lista-servicos.jsp").forward(request, response);
    }
    
}//class ListarServicosLogica.