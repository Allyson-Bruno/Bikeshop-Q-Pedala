<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Cadastro de bicicleta</title>
</head>
<body>

    <h1>Cadastro de bicicleta</h1>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <c:if test="${param.sucesso == 'true'}">
        <p>Bicicleta cadastrada com sucesso.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/mvc" method="post">

        <label for="marca">Marca:</label><br>
        <input type="text" id="marca" name="marca"
               required maxlength="60"
               value="<c:out value='${param.marca}' />"><br>

        <label for="modelo">Modelo:</label><br>
        <input type="text" id="modelo" name="modelo"
               required maxlength="100"
               value="<c:out value='${param.modelo}' />"><br>

        <label for="tipo">Tipo:</label><br>
        <select id="tipo" name="tipo" required>
            <option value="">Selecione</option>

            <option value="MTB"
                ${param.tipo == 'MTB' ? 'selected' : ''}>MTB</option>

            <option value="Road"
                ${param.tipo == 'Road' ? 'selected' : ''}>Road</option>

            <option value="Gravel"
                ${param.tipo == 'Gravel' ? 'selected' : ''}>Gravel</option>

            <option value="BMX"
                ${param.tipo == 'BMX' ? 'selected' : ''}>BMX</option>

            <option value="Elétrica"
                ${param.tipo == 'Elétrica' ? 'selected' : ''}>Elétrica</option>
        </select><br>

        <label for="tamanhoQuadro">Tamanho do quadro:</label><br>
        <input type="text" id="tamanhoQuadro" name="tamanhoQuadro"
               required maxlength="30"
               placeholder="Ex.: 17, 54 cm ou M"
               value="<c:out value='${param.tamanhoQuadro}' />"><br>

        <label for="numeroSerie">Número de série:</label><br>
        <input type="text" id="numeroSerie" name="numeroSerie"
               required maxlength="50"
               value="<c:out value='${param.numeroSerie}' />"><br>

        <label for="anoFabricacao">Ano de fabricação:</label><br>
        <input type="number" id="anoFabricacao" name="anoFabricacao"
               required min="1800" step="1"
               value="<c:out value='${param.anoFabricacao}' />"><br>

        <label for="idProprietario">Proprietário:</label><br>
        <select id="idProprietario" name="idProprietario">
            <option value="">Sem proprietário</option>

            <c:forEach var="cliente" items="${clientes}">
                <option value="${cliente.id}"
                    ${param.idProprietario == cliente.id.toString()
                        ? 'selected' : ''}>
                    <c:out value="${cliente.nome}" />
                    — <c:out value="${cliente.cpf}" />
                </option>
            </c:forEach>
        </select><br>

        <input type="hidden" name="logica"
               value="CadastroBicicletaLogica">

        <button type="submit">Cadastrar</button>
    </form>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>