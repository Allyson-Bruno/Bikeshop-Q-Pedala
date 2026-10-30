package bikeshop.logica;

import java.util.List;

import bikeshop.dao.BicicletaDAO;
import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.Bicicleta;
import bikeshop.modelo.OrdemServico;
import bikeshop.validacao.BicicletaValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HistoricoBicicletaLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String numeroInformado = request.getParameter("numeroSerie");

        // Primeiro acesso: abre a página sem realizar uma busca.
        if (numeroInformado == null) {
            request.getRequestDispatcher("/historico-bicicleta.jsp").forward(request, response);
            return;
        }

        String numeroSerie = numeroInformado.strip();

        request.setAttribute("numeroSerieBuscado", numeroSerie);

        if (!BicicletaValidacao.numeroSerieValido(numeroSerie)) {
            request.setAttribute("erro", "Informe um número de série com até 50 caracteres.");

            request.getRequestDispatcher("/historico-bicicleta.jsp").forward(request, response);
            return;
        }

        BicicletaDAO bicicletaDAO = new BicicletaDAO();

        Bicicleta bicicleta = bicicletaDAO.buscarPorNumeroSerie(numeroSerie);

        if (bicicleta == null) {
            request.setAttribute("erro", "Nenhuma bicicleta encontrada com o número de série informado.");

            request.getRequestDispatcher("/historico-bicicleta.jsp").forward(request, response);
            return;
        }

        OrdemServicoDAO ordemDAO = new OrdemServicoDAO();

        List<OrdemServico> ordens = ordemDAO.listaHistoricoPorBicicleta(bicicleta.getId());

        request.setAttribute("bicicleta", bicicleta);
        request.setAttribute("ordens", ordens);

        request.getRequestDispatcher("/historico-bicicleta.jsp").forward(request, response);
    }
    
}//class HistoricoBicicletaLogica.