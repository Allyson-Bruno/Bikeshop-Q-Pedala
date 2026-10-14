<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login BikeShop Q-Pedala</title>
</head>
<body>

	<form action="mvc" method="post">
		
		<label for="usuario">Usuario: </label> <br>
		<input type="text" id="usuario" name="usuario" required="required"><br>
		
		<label for="senha">Senha: </label> <br>
		<input type="password" id="senha" name="senha" required="required"> <br>
		
		<input type="hidden" name="logica" value="LoginLogica">
		<input type="submit" value="Enviar">
		
	</form>
	
</body>
</html>