package bikeshop.logica;

import java.util.List;

import bikeshop.dao.BicicletaDAO;
import bikeshop.modelo.Bicicleta;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ListarBicicletasLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        BicicletaDAO dao = new BicicletaDAO();

        List<Bicicleta> bicicletas = dao.listaBicicletas();

        request.setAttribute("bicicletas", bicicletas);

        request.getRequestDispatcher("/lista-bicicletas.jsp").forward(request, response);
    }
    
}//class ListarBicicletasLogica.