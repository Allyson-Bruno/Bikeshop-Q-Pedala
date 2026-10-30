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
<title>BikeShop Q-Pedala — Histórico por cliente</title>
</head>
<body>

    <h1>Histórico por cliente</h1>

    <fmt:setLocale value="pt_BR" />

    <form action="${pageContext.request.contextPath}/mvc"
          method="get">

        <input type="hidden" name="logica" value="HistoricoClienteLogica">

        <label for="cpf">CPF do cliente:</label><br>

        <input type="text"
               id="cpf"
               name="cpf"
               maxlength="11"
               inputmode="numeric"
               required
               placeholder="Somente números"
               value="<c:out value='${cpfBuscado}' />">

        <button type="submit">Buscar histórico</button>
    </form>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <c:if test="${not empty cliente and empty erro}">

        <h2>Cliente encontrado</h2>

        <p>
            Nome: <c:out value="${cliente.nome}" /><br>
            CPF: <c:out value="${cliente.cpf}" />
        </p>

        <h2>Serviços realizados</h2>

        <table border="1">
            <thead>
                <tr>
                    <th>OS</th>
                    <th>Data da execução</th>
                    <th>Bicicleta</th>
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
                            <c:out value="${ordem.bicicleta.marca}" />
                            — <c:out value="${ordem.bicicleta.modelo}" /><br>
                            Série:
                            <c:out value="${ordem.bicicleta.numeroSerie}" />
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
        						<c:param name="logica" value="DetalhesOrdemLogica" />
        						<c:param name="id" value="${ordem.id}" />
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
                            Este cliente ainda não possui serviços realizados.
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