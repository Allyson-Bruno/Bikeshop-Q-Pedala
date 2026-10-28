<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Registrar execução</title>
</head>
<body>

    <h1>Registrar execução</h1>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <p>OS: <c:out value="${ordem.id}" /></p>

    <p>
        Cliente: <c:out value="${ordem.cliente.nome}" />
        — CPF: <c:out value="${ordem.cliente.cpf}" />
    </p>

    <p>
        Bicicleta: <c:out value="${ordem.bicicleta.marca}" />
        — <c:out value="${ordem.bicicleta.modelo}" />
        — Série: <c:out value="${ordem.bicicleta.numeroSerie}" />
    </p>

    <p>
        Data do agendamento:
        <c:out value="${ordem.dataAgendamento}" />
    </p>

    <form action="${pageContext.request.contextPath}/mvc" method="post">

        <input type="hidden" name="logica" value="RegistrarExecucaoLogica">

        <input type="hidden" name="id" value="<c:out value='${ordem.id}' />">

        <label for="dataExecucao">Data da execução:</label><br>

        <input type="date" id="dataExecucao" name="dataExecucao"
               required
               value="<c:out value='${param.dataExecucao}' />"><br>

        <fieldset>
    <legend>Serviços efetivamente realizados</legend>

    <p>
        Marque os serviços realizados e confira o valor de cada um.
        O preço atual do catálogo aparece como sugestão.
        Se o serviço foi realizado anteriormente, informe o valor
        aplicado naquela ocasião.
    </p>

    <c:forEach var="item" items="${ordem.itens}">

        <%-- Recupera a seleção caso o formulário retorne com erro. --%>
        <c:set var="selecionado" value="${false}" />

        <c:forEach var="idSelecionado" items="${paramValues.idItens}">
            <c:if test="${idSelecionado eq item.id.toString()}">
                <c:set var="selecionado" value="${true}" />
            </c:if>
        </c:forEach>

        <%-- Cada item possui seu próprio parâmetro de valor. --%>
        <c:set var="nomeCampoValor" value="valorItem_${item.id}" />

        <%-- Preserva o valor enviado, inclusive se estiver vazio. --%>
        <c:set var="valorExibido" value="${item.servico.valor}" />

        <c:if test="${param[nomeCampoValor] != null}">
            <c:set var="valorExibido"
                   value="${param[nomeCampoValor]}" />
        </c:if>

        <div>
            <input type="checkbox"
                   id="item-${item.id}"
                   name="idItens"
                   value="${item.id}"
                   ${selecionado ? 'checked' : ''}>

            <label for="item-${item.id}">
                <c:out value="${item.servico.nome}" />
            </label>

            <br>

            <label for="valor-item-${item.id}">
                Valor aplicado (R$):
            </label>

            <input type="text"
                   id="valor-item-${item.id}"
                   name="${nomeCampoValor}"
                   value="<c:out value='${valorExibido}' />"
                   inputmode="decimal"
                   placeholder="Ex.: 150,00">

            <br><br>
        </div>

    	</c:forEach>
	</fieldset>

        <button type="submit">Confirmar execução</button>
    </form>

    <p>
        <a href="${pageContext.request.contextPath}/mvc?logica=ListarAgendamentosLogica">
            Voltar aos agendamentos
        </a>
    </p>

</body>
</html>