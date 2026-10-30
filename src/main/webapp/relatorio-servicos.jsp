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
<title>BikeShop Q-Pedala — Relatório de serviços</title>
</head>
<body>

    <h1>Relatório de serviços prestados</h1>

    <fmt:setLocale value="pt_BR" />

    <form action="${pageContext.request.contextPath}/mvc"
          method="get">

        <input type="hidden"
               name="logica"
               value="RelatorioServicosLogica">

        <label for="dataInicial">Data inicial:</label>
        <input type="date"
               id="dataInicial"
               name="dataInicial"
               required
               value="<c:out value='${dataInicialFiltro}' />">

        <label for="dataFinal">Data final:</label>
        <input type="date"
               id="dataFinal"
               name="dataFinal"
               required
               value="<c:out value='${dataFinalFiltro}' />">

        <button type="submit">Consultar</button>
    </form>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <c:if test="${consultaRealizada eq true and empty erro}">

        <h2>Resultado da consulta</h2>

        <p>
            Período de execução:
            <c:out value="${dataInicialFiltro}" />
            a
            <c:out value="${dataFinalFiltro}" />,
            incluindo as duas datas.
        </p>

        <table border="1">
            <thead>
                <tr>
                    <th>OS</th>
                    <th>Data da execução</th>
                    <th>Cliente</th>
                    <th>Bicicleta</th>
                    <th>Serviços realizados</th>
                    <th>Status</th>
                    <th>Valor dos serviços</th>
                    <th>Desconto</th>
                    <th>Valor final da prestação</th>
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
                            <c:out value="${ordem.bicicleta.marca}" />
                            — <c:out value="${ordem.bicicleta.modelo}" /><br>
                            Série:
                            <c:out value="${ordem.bicicleta.numeroSerie}" />
                        </td>

                        <td>
                            <ul>
                                <c:forEach var="item" items="${ordem.itens}">
                                    <li>
                                        <c:out value="${item.servico.nome}" />
                                        —
                                        <fmt:formatNumber
                                            value="${item.valor}"
                                            type="currency"
                                            currencySymbol="R$" />
                                    </li>
                                </c:forEach>
                            </ul>
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
                        <td colspan="10">
                            Nenhum serviço realizado no período informado.
                        </td>
                    </tr>
                </c:if>
            </tbody>

            <tfoot>
                <tr>
                    <th colspan="8" scope="row">
                        Total faturado no período
                    </th>

                    <td>
                        <strong>
                            <fmt:formatNumber
                                value="${totalRelatorio}"
                                type="currency"
                                currencySymbol="R$" />
                        </strong>
                    </td>

                    <td></td>
                </tr>
            </tfoot>
        </table>

        <p>
            O total inclui ordens executadas e pagas, considerando os
            descontos já registrados. Não representa apenas pagamentos
            recebidos.
        </p>

        <p>
            Ordens com pagamento pendente ainda podem receber desconto
            na confirmação do pagamento.
        </p>

    </c:if>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>