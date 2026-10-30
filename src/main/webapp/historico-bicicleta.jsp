<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Histórico por bicicleta</title>
</head>
<body>

    <h1>Histórico por bicicleta</h1>

    <fmt:setLocale value="pt_BR" />

    <form action="${pageContext.request.contextPath}/mvc"
          method="get">

        <input type="hidden"
               name="logica"
               value="HistoricoBicicletaLogica">

        <label for="numeroSerie">Número de série:</label><br>

        <input type="text"
               id="numeroSerie"
               name="numeroSerie"
               maxlength="50"
               required
               value="<c:out value='${numeroSerieBuscado}' />">

        <button type="submit">Buscar histórico</button>
    </form>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <c:if test="${not empty bicicleta and empty erro}">

        <h2>Bicicleta encontrada</h2>

        <p>
            Marca: <c:out value="${bicicleta.marca}" /><br>
            Modelo: <c:out value="${bicicleta.modelo}" /><br>
            Número de série:
            <c:out value="${bicicleta.numeroSerie}" />
        </p>

        <h2>Serviços realizados</h2>

        <table border="1">
            <thead>
                <tr>
                    <th>OS</th>
                    <th>Data da execução</th>
                    <th>Cliente registrado na OS</th>
                    <th>Status</th>
                    <th>Total dos serviços</th>
                    <th>Desconto</th>
                    <th>Valor final</th>
                    <th>Ações</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="ordem" items="${ordens}">
                    <tr>
                        <td>
                            <c:out value="${ordem.id}" />
                        </td>

                        <td>
                            <c:out value="${ordem.dataExecucao}" />
                        </td>

                        <td>
                            <c:out value="${ordem.cliente.nome}" /><br>
                            CPF:
                            <c:out value="${ordem.cliente.cpf}" />
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${ordem.status eq 'PAGA'}">
                                    Paga
                                </c:when>
                                <c:otherwise>
                                    Executada — pagamento pendente
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <fmt:formatNumber
                                value="${ordem.valorTotal}"
                                type="currency"
                                currencySymbol="R$" />
                        </td>

                        <td>
                            <fmt:formatNumber
                                value="${ordem.desconto}"
                                type="currency"
                                currencySymbol="R$" />
                        </td>

                        <td>
                            <fmt:formatNumber
                                value="${ordem.valorTotal.subtract(ordem.desconto)}"
                                type="currency"
                                currencySymbol="R$" />
                        </td>

                        <td>
                            <c:url var="urlDetalhes" value="/mvc">
                                <c:param name="logica"
                                         value="DetalhesOrdemLogica" />
                                <c:param name="id"
                                         value="${ordem.id}" />
                            </c:url>

                            <a href="<c:out value='${urlDetalhes}' />">
                                Detalhes da ordem
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty ordens}">
                    <tr>
                        <td colspan="8">
                            Esta bicicleta ainda não possui serviços realizados.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <p>
            Para ordens com pagamento pendente, o valor final apresentado
            ainda não considera um possível desconto na confirmação do pagamento.
        </p>

    </c:if>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>