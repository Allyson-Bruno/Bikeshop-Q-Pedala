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
<title>BikeShop Q-Pedala — Detalhes da ordem</title>
</head>
<body>

    <h1>Detalhes da ordem de serviço</h1>

    <fmt:setLocale value="pt_BR" />

    <c:choose>
        <c:when test="${not empty ordem}">

            <p>
                <strong>OS:</strong>
                <c:out value="${ordem.id}" />
            </p>

            <p>
                <strong>Status:</strong>

                <c:choose>
                    <c:when test="${ordem.status eq 'PAGA'}">
                        Paga
                    </c:when>
                    <c:otherwise>
                        Executada — pagamento pendente
                    </c:otherwise>
                </c:choose>
            </p>

            <p>
                <strong>Cliente registrado na OS:</strong>
                <c:out value="${ordem.cliente.nome}" /><br>

                CPF: <c:out value="${ordem.cliente.cpf}" />
            </p>

            <p>
                <strong>Bicicleta:</strong>
                <c:out value="${ordem.bicicleta.marca}" />
                — <c:out value="${ordem.bicicleta.modelo}" /><br>

                Série:
                <c:out value="${ordem.bicicleta.numeroSerie}" />
            </p>

            <p>
                <strong>Data do agendamento:</strong>
                <c:out value="${ordem.dataAgendamento}" /><br>

                <strong>Data da execução:</strong>
                <c:out value="${ordem.dataExecucao}" />
            </p>

            <h2>Serviços realizados</h2>

            <table border="1">
                <thead>
                    <tr>
                        <th>Serviço</th>
                        <th>Valor registrado na execução</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="item" items="${ordem.itens}">
                        <tr>
                            <td>
                                <c:out value="${item.servico.nome}" />
                            </td>

                            <td>
                                <fmt:formatNumber
                                    value="${item.valor}"
                                    type="currency"
                                    currencySymbol="R$" />
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <h2>Valores da ordem</h2>

            <p>
                <strong>Total dos serviços:</strong>
                <fmt:formatNumber
                    value="${ordem.valorTotal}"
                    type="currency"
                    currencySymbol="R$" />
            </p>

            <p>
                <strong>Desconto aplicado:</strong>
                <fmt:formatNumber
                    value="${ordem.desconto}"
                    type="currency"
                    currencySymbol="R$" />
            </p>

            <p>
                <strong>Valor final:</strong>
                <fmt:formatNumber
                    value="${ordem.valorTotal.subtract(ordem.desconto)}"
                    type="currency"
                    currencySymbol="R$" />
            </p>

            <c:if test="${ordem.status eq 'EXECUTADA'}">
                <p>
                    Pagamento pendente. O valor apresentado ainda não
                    considera um possível desconto na confirmação do pagamento.
                </p>
            </c:if>

            <c:url var="urlHistoricoCliente" value="/mvc">
                <c:param name="logica" value="HistoricoClienteLogica" />
                <c:param name="cpf" value="${ordem.cliente.cpf}" />
            </c:url>

            <p>
                <a href="<c:out value='${urlHistoricoCliente}' />">
                    Ver histórico deste cliente
                </a>
            </p>

        </c:when>

        <c:otherwise>
            <p>
                Nenhuma OS foi carregada.
                Acesse os detalhes pela listagem do histórico.
            </p>
        </c:otherwise>
    </c:choose>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>