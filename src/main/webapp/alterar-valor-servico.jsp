<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Alterar valor</title>
</head>
<body>

    <h1>Alterar valor do serviço</h1>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <p>
        Serviço: <strong><c:out value="${servico.nome}" /></strong>
    </p>

    <form action="${pageContext.request.contextPath}/mvc" method="post">

        <input type="hidden" name="logica"
               value="AlterarValorServicoLogica">

        <input type="hidden" name="id"
               value="<c:out value='${servico.id}' />">

        <label for="valor">Novo valor (R$):</label><br>

        <input type="text" id="valor" name="valor"
               inputmode="decimal" required
               aria-describedby="orientacaoValor"
               value="<c:out value='${param.valor != null ? param.valor : servico.valor}' />"><br>

        <small id="orientacaoValor">
            Use vírgula ou ponto para os centavos, sem separador de milhar.
            Ex.: 1500,50.
        </small><br>

        <button type="submit">Salvar alteração</button>
    </form>

    <p>
        <a href="${pageContext.request.contextPath}/mvc?logica=ListarServicosLogica">
            Voltar à listagem
        </a>
    </p>

</body>
</html>