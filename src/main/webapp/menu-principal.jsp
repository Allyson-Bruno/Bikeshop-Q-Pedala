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
		
		<li>Cadastro de serviços.</li>
		<li>Agendamento de serviço.</li>
		<li>Listagem de ordem de serviços agendadas/não executadas.</li>
		<li>Lançar serviços realizados.</li>
		<li>Realizar pagamento.</li>
		<li>Histórico por cliente.</li>
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