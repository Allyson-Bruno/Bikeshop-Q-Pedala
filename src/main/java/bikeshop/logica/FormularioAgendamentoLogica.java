package bikeshop.logica;

import java.util.List;

import bikeshop.dao.BicicletaDAO;
import bikeshop.dao.ClienteDAO;
import bikeshop.dao.ServicoDAO;
import bikeshop.modelo.Bicicleta;
import bikeshop.modelo.Cliente;
import bikeshop.modelo.Servico;
import bikeshop.validacao.ClienteValidacao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class FormularioAgendamentoLogica implements Logica {

    @Override
    public void executa(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String cpf = request.getParameter("cpf");

        // Sem parâmetro, apenas abre a página de busca.
        // Em outras palavras o administrador a página sem realizar uma busca.
        if (cpf == null) {
            request.getRequestDispatcher("/agendamento.jsp").forward(request, response);
            return;
        }

        cpf = cpf.strip();

        String erro = null;

        if (!ClienteValidacao.cpfValido(cpf)) {
            erro = "Informe um CPF válido com 11 números, sem pontuação.";

        } else {

            ClienteDAO clienteDAO = new ClienteDAO();
            Cliente cliente = clienteDAO.buscarPorCpf(cpf);

            if (cliente == null) {
                erro = "Nenhum cliente encontrado com esse CPF.";

            } else {

                BicicletaDAO bicicletaDAO = new BicicletaDAO();
                ServicoDAO servicoDAO = new ServicoDAO();

                List<Bicicleta> bicicletas = bicicletaDAO.listaPorCliente(cliente.getId());

                List<Servico> servicos = servicoDAO.listaServicos();

                request.setAttribute("cliente", cliente);
                request.setAttribute("bicicletas", bicicletas);
                request.setAttribute("servicos", servicos);

                if (bicicletas.isEmpty()) {
                    erro = "Esse cliente não possui bicicletas cadastradas.";

                } else if (servicos.isEmpty()) {
                    erro = "Cadastre pelo menos um serviço antes de agendar.";
                }
            }
        }

        request.setAttribute("erro", erro);

        request.getRequestDispatcher("/agendamento.jsp").forward(request, response);
    }
    
}//class FormularioAgendamentoLogica.