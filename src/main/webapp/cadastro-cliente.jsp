<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@taglib uri="jakarta.tags.core" prefix="c" %>

<%@include file="autenticacao.jsp"%>     
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BikeShop Q-Pedala</title>
</head>
<body>

	 <h1>Cadastro de cliente</h1>

	<c:if test="${not empty erro}">
    	<p><c:out value="${erro}" /></p>
	</c:if>

	<c:if test="${param.sucesso == 'true'}">
    	<p>Cliente cadastrado com sucesso.</p>
	</c:if>

	<form action="mvc" method="post">
		
		<label for="cpf">CPF: </label> <br>
		
		<input type="text" id="cpf" name="cpf" required maxlength="11" pattern="[0-9]{11}" 
			value="<c:out value='${param.cpf}'/>" placeholder="Somente os 11 números"> <br>
		
		<label for="nome">Nome: </label> <br>
		<input type="text" id="nome" name="nome" maxlength="120" required="required"
			value="<c:out value='${param.nome}'/>"> <br>
		
		<label for="datanasci">Data Nascimento:</label> <br>
		<input type="date" id="datanasci" name="datanasci" required="required"
			value="<c:out value='${param.datanasci}'/>"> <br>
		
		<label for="email">Email: </label>	<br>
		<input type="email" id="email" name="email" maxlength="254" required="required"
			value="<c:out value='${param.email}'/>"> <br>
	
		<label for="telefone">Telefone</label>	<br>
		<input type="text" id="telefone" name="telefone" maxlength="20" required="required"
			value="<c:out value='${param.telefone}'/>"> <br>
		
		<input type="hidden" name="logica" value="CadastroClienteLogica">
		<input type="submit" value="Enviar">

	</form>

</body>
</html>