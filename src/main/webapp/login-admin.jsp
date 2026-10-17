<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login BikeShop Q-Pedala</title>
</head>
<body>

	<c:if test="${not empty erro}">
    	<p><c:out value="${erro}" /></p>
	</c:if>

	<form action="mvc" method="post">
		
		<label for="usuario">Usuario: </label> <br>
		<input type="text" id="usuario" name="usuario" required value="<c:out value='${param.usuario}' />"> <br>
		
		<label for="senha">Senha: </label> <br>
		<input type="password" id="senha" name="senha" required="required"> <br>
		
		<input type="hidden" name="logica" value="LoginLogica">
		<input type="submit" value="Login">
		
	</form>
	
</body>
</html>