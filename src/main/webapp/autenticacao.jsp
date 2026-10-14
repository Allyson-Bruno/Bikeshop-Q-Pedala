<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>

	<c:if test="${sessionScope.usuarioLogado != true}">
		<jsp:forward page="login-admin.jsp"></jsp:forward>
	</c:if>

</body>
</html>