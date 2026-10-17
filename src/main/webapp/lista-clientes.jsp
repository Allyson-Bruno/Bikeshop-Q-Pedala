<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BikeShop Q Pedala Listagem de clientes.</title>
</head>
<body>

	<table border="1">
		
		<thead>
			<tr>
				
				<th>Nome</th>			
				<th>CPF</th>
				<th>Data nascimento</th>
				<th>Email</th>
				<th>Telefone</th>
			</tr>		
		</thead>
		
		<tbody>
		
		<c:forEach var="cliente" items="${clientes}">
			
				<tr>
					<td><c:out value="${cliente.nome}" /></td>
	            	<td><c:out value="${cliente.cpf}" /></td>
	            	<td><c:out value="${cliente.dataNascimento}" /></td>
	            	<td><c:out value="${cliente.email}" /></td>
	            	<td><c:out value="${cliente.telefone}" /></td>
				</tr>		
			
			</c:forEach>
			
		<c:if test="${empty clientes}">
        	<tr>
            	<td colspan="5">Nenhum cliente cadastrado.</td>
        	</tr>
    	</c:if>
			
		</tbody>
	
	</table>	

</body>
</html>