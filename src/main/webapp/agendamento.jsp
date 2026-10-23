<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Agendamento</title>
</head>
<body>

    <h1>Agendamento de serviço</h1>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <c:if test="${param.sucesso == 'true'}">
        <p>Agendamento realizado com sucesso.</p>
    </c:if>

    <!-- Busca do cliente -->
    <form action="${pageContext.request.contextPath}/mvc" method="get">

        <input type="hidden" name="logica"
               value="FormularioAgendamentoLogica">

        <label for="cpf">CPF do cliente:</label><br>

        <input type="text" id="cpf" name="cpf"
               required maxlength="11" pattern="[0-9]{11}"
               placeholder="Somente os 11 números"
               value="<c:out value='${param.cpf}' />">

        <button type="submit">Buscar cliente</button>
    </form>

    <!-- Dados do cliente encontrado -->
    <c:if test="${not empty cliente}">

        <h2>Cliente</h2>

        <p>Nome: <c:out value="${cliente.nome}" /></p>
        <p>CPF: <c:out value="${cliente.cpf}" /></p>
        <p>Telefone: <c:out value="${cliente.telefone}" /></p>

        <!-- Só permite agendar se houver bicicletas e serviços -->
        <c:if test="${not empty bicicletas and not empty servicos}">

            <form action="${pageContext.request.contextPath}/mvc"
                  method="post">

                <input type="hidden" name="logica"
                       value="AgendarServicoLogica">

                <input type="hidden" name="idCliente"
                       value="<c:out value='${cliente.id}' />">

                <input type="hidden" name="cpf"
                       value="<c:out value='${cliente.cpf}' />">

                <label for="idBicicleta">Bicicleta:</label><br>

                <select id="idBicicleta" name="idBicicleta" required>
                    <option value="">Selecione</option>

                    <c:forEach var="bicicleta" items="${bicicletas}">
                        <option value="${bicicleta.id}"
                            ${param.idBicicleta == bicicleta.id.toString()
                                ? 'selected' : ''}>
                            <c:out value="${bicicleta.marca}" />
                            — <c:out value="${bicicleta.modelo}" />
                            — Série: <c:out value="${bicicleta.numeroSerie}" />
                        </option>
                    </c:forEach>
                </select><br>

                <label for="dataAgendamento">
                    Data do agendamento:
                </label><br>

                <input type="date" id="dataAgendamento"
                       name="dataAgendamento" required
                       value="<c:out value='${param.dataAgendamento}' />"><br>

                <fieldset>
                    <legend>Selecione um ou mais serviços</legend>

                    <c:forEach var="servico" items="${servicos}">

                        <c:set var="selecionado" value="${false}" />

                        <c:forEach var="idSelecionado"
                                   items="${paramValues.idServicos}">
                            <c:if test="${idSelecionado == servico.id.toString()}">
                                <c:set var="selecionado" value="${true}" />
                            </c:if>
                        </c:forEach>

                        <input type="checkbox"
                               id="servico-${servico.id}"
                               name="idServicos"
                               value="${servico.id}"
                               ${selecionado ? 'checked' : ''}>

                        <label for="servico-${servico.id}">
                            <c:out value="${servico.nome}" />
                        </label><br>

                    </c:forEach>
                </fieldset>

                <button type="submit">Confirmar agendamento</button>
            </form>

        </c:if>
    </c:if>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>