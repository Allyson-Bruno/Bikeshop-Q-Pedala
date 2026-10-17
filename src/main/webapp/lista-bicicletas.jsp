<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Bicicletas</title>
</head>
<body>

    <h1>Bicicletas cadastradas</h1>

    <table border="1">
        <thead>
            <tr>
                <th>Marca</th>
                <th>Modelo</th>
                <th>Tipo</th>
                <th>Tamanho do quadro</th>
                <th>Número de série</th>
                <th>Ano de fabricação</th>
                <th>Proprietário</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach var="bicicleta" items="${bicicletas}">
                <tr>
                    <td><c:out value="${bicicleta.marca}" /></td>
                    <td><c:out value="${bicicleta.modelo}" /></td>
                    <td><c:out value="${bicicleta.tipo}" /></td>
                    <td><c:out value="${bicicleta.tamanhoQuadro}" /></td>
                    <td><c:out value="${bicicleta.numeroSerie}" /></td>
                    <td><c:out value="${bicicleta.anoFabricacao}" /></td>

                    <td>
                        <c:choose>
                            <c:when test="${not empty bicicleta.proprietario}">
                                <c:out value="${bicicleta.proprietario.nome}" />
                                — <c:out value="${bicicleta.proprietario.cpf}" />
                            </c:when>

                            <c:otherwise>
                                Sem proprietário
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty bicicletas}">
                <tr>
                    <td colspan="7">Nenhuma bicicleta cadastrada.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>