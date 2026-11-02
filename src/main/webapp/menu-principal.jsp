<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@taglib uri = "jakarta.tags.core" prefix="c" %>    
   
<%@include file="autenticacao.jsp"%>   
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<c:import url="/WEB-INF/components/estilos.jsp" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Menu BikeShop Q-Pedala</title>
</head>

<body>

	<ul>
		
		<li>
    		<a href="${pageContext.request.contextPath}/cadastro-cliente.jsp">
        		Cadastro de clientes
    		</a>
		</li>		

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
		
		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=HistoricoBicicletaLogica">
        		Histórico por bicicleta
    		</a>
		</li>
		
		
		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=RelatorioServicosLogica">
        		Relatório de serviços prestados
    		</a>
		</li>		

		<li>
    		<a href="${pageContext.request.contextPath}/mvc?logica=LogoutLogica">
        		Sair
    		</a>
		</li>
	</ul>
	
	
	<c:import url="/WEB-INF/components/scripts.jsp" />
	
</body>
</html>