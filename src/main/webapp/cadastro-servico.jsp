<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Cadastro de serviço</title>
</head>
<body>

    <h1>Cadastro de serviço</h1>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <c:if test="${param.sucesso == 'true'}">
        <p>Serviço cadastrado com sucesso.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/mvc" method="post">

        <label for="nome">Nome do serviço:</label><br>
        <input type="text" id="nome" name="nome"
               required maxlength="120"
               value="<c:out value='${param.nome}' />"><br>

        <label for="valor">Valor (R$):</label><br>
        <input type="text" id="valor" name="valor"
               inputmode="decimal" required
               placeholder="Ex.: 150,50"
               aria-describedby="orientacaoValor"
               value="<c:out value='${param.valor}' />"><br>

        <small id="orientacaoValor">
            Use vírgula ou ponto para os centavos, sem separador de milhar.
            Ex.: 1500,50.
        </small><br>

        <input type="hidden" name="logica" value="CadastroServicoLogica">

        <button type="submit">Cadastrar</button>
    </form>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>