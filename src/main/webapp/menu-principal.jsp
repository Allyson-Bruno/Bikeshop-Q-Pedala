<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@taglib uri = "jakarta.tags.core" prefix="c" %>    
   
<%@include file="autenticacao.jsp"%>   
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Menu BikeShop Q-Pedala</title>
</head>
<body>

	<!-- Enviar esse Menu para análise, suspeito que falta os campos de listagem. -->
	<ul>
		<li><a href="cadastro-cliente.jsp">Cadastro de clientes</a></li>
		<li>
			<a href="${pageContext.request.contextPath}/mvc?logica=ListarClientesLogica">
				Listagem de clientes.
			</a>
		</li>

		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=FormularioBicicletaLogica">
        		Cadastro de bicicletas
    		</a>
		</li>		
		
		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=ListarBicicletasLogica">
        		Listagem de bicicletas
    		</a>
		</li>
		
		<li>
    		<a href="${pageContext.request.contextPath}/cadastro-servico.jsp">
        		Cadastro de serviços
    		</a>
		</li>
		
		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=ListarServicosLogica">
        		Listagem de serviços
    		</a>
		</li>
		
		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=FormularioAgendamentoLogica">
        		Agendamento de serviço
    		</a>
		</li>		
		
		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=ListarAgendamentosLogica">
        		Agendamentos pendentes
    		</a>
		</li>
		
		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=ListarPendentesPagamentoLogica">
        		Realizar pagamento
    		</a>
		</li>

		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=HistoricoClienteLogica">
        		Histórico por cliente
    		</a>
		</li>		
		
		<li>Histórico por bicicleta.</li>
		<li>Relatório de serviços prestados.</li>
		
		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=LogoutLogica">
        		Sair
    		</a>
		</li>
	</ul>
	
	

</body>
</html>