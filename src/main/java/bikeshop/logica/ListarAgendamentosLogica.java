package bikeshop.logica;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

import bikeshop.dao.OrdemServicoDAO;
import bikeshop.modelo.OrdemServico;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ListarAgendamentosLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String dataInformada = request.getParameter("data");
        String modo = request.getParameter("modo");

        LocalDate data = null;
        String erro = null;

        if (dataInformada == null) {
            data = LocalDate.now();

        } else if (dataInformada.isBlank()) {
            erro = "Informe uma data para consultar.";

        } else {
            try {
                data = LocalDate.parse(dataInformada);

            } catch (DateTimeParseException e) {
                erro = "Informe uma data válida.";
            }
        }

        if (modo == null) {
            modo = "apartir";
        }

        if (!"apartir".equals(modo) && !"exata".equals(modo)) {
            erro = "Selecione um modo de consulta válido.";
        }

        List<OrdemServico> agendamentos = new ArrayList<>();

        if (erro == null) {

            boolean somenteNaData = "exata".equals(modo);

            OrdemServicoDAO dao = new OrdemServicoDAO();

            agendamentos = dao.listaAgendamentos(data, somenteNaData);
        }

        request.setAttribute("agendamentos", agendamentos);
        request.setAttribute("erro", erro);
        request.setAttribute("modoFiltro", modo);

        // Preserva o texto informado, inclusive em caso de erro.
        request.setAttribute("dataFiltro", dataInformada == null ? data.toString() : dataInformada);

        request.getRequestDispatcher("/lista-agendamentos.jsp").forward(request, response);
    }
    
}//class ListarAgendamentosLogica.