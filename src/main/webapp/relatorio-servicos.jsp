<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Relatório de serviços — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <fmt:setLocale value="pt_BR" />

    <main class="container py-4 py-md-5">

        <section class="listagem-card"
                 aria-labelledby="titulo-relatorio">

            <h1 id="titulo-relatorio" class="h3 mb-2">
                Relatório de serviços prestados
            </h1>

            <p class="listagem-descricao mb-4">
                Consulte os serviços realizados em um período
                e exporte os resultados em PDF.
            </p>

            <form action="${pageContext.request.contextPath}/mvc"
                  method="get"
                  class="filtro-listagem mb-4">

                <input type="hidden"
                       name="logica"
                       value="RelatorioServicosLogica">

                <div class="row g-3 align-items-end">

                    <div class="col-12 col-sm-6 col-lg-4">
                        <label for="dataInicial" class="form-label">
                            Data inicial
                        </label>

                        <input type="date"
                               class="form-control"
                               id="dataInicial"
                               name="dataInicial"
                               required
                               value="<c:out value='${dataInicialFiltro}' />">
                    </div>

                    <div class="col-12 col-sm-6 col-lg-4">
                        <label for="dataFinal" class="form-label">
                            Data final
                        </label>

                        <input type="date"
                               class="form-control"
                               id="dataFinal"
                               name="dataFinal"
                               required
                               value="<c:out value='${dataFinalFiltro}' />">
                    </div>

                    <div class="col-12 col-lg-auto">
                        <button type="submit" class="btn btn-destaque">
                            Consultar
                        </button>
                    </div>

                </div>

            </form>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <c:if test="${consultaRealizada eq true and empty erro}">

                <c:url var="urlExportarPdf" value="/mvc">
                    <c:param name="logica"
                             value="ExportarRelatorioPdfLogica" />
                    <c:param name="dataInicial"
                             value="${dataInicialFiltro}" />
                    <c:param name="dataFinal"
                             value="${dataFinalFiltro}" />
                </c:url>

                <div class="d-flex flex-column flex-md-row
                            justify-content-between align-items-start gap-3 mb-4">

                    <div>
                        <h2 class="h5 mb-2">
                            Resultado da consulta
                        </h2>

                        <p class="listagem-descricao mb-0">
                            Período de execução:
                            <c:out value="${dataInicialFiltro}" />
                            a
                            <c:out value="${dataFinalFiltro}" />,
                            incluindo as duas datas.
                        </p>
                    </div>

                    <a href="<c:out value='${urlExportarPdf}' />"
                       class="btn btn-outline-info flex-shrink-0">
                        Exportar PDF
                    </a>

                </div>

                <div class="table-responsive tabela-container"
                     role="region"
                     aria-label="Relatório de serviços prestados"
                     tabindex="0">

                    <table class="table tabela-sistema tabela-relatorio
                                  table-hover align-middle mb-0">

                        <caption class="visually-hidden">
                            Ordens de serviço realizadas no período,
                            clientes, bicicletas, serviços, status e valores.
                        </caption>

                        <thead>
                            <tr>
                                <th scope="col">OS</th>
                                <th scope="col">Data da execução</th>
                                <th scope="col">Cliente</th>
                                <th scope="col">Bicicleta</th>
                                <th scope="col">Serviços realizados</th>
                                <th scope="col">Status</th>
                                <th scope="col" class="text-end">
                                    Valor dos serviços
                                </th>
                                <th scope="col" class="text-end">
                                    Desconto
                                </th>
                                <th scope="col" class="text-end">
                                    Valor final da prestação
                                </th>
                                <th scope="col" class="text-center">
                                    Ações
                                </th>
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
                                        <c:out value="${ordem.cliente.nome}" />

                                        <span class="d-block">
                                            CPF:
                                            <c:out value="${ordem.cliente.cpf}" />
                                        </span>
                                    </td>

                                    <td>
                                        <c:out value="${ordem.bicicleta.marca}" />
                                        — <c:out value="${ordem.bicicleta.modelo}" />

                                        <span class="d-block">
                                            Série:
                                            <c:out value="${ordem.bicicleta.numeroSerie}" />
                                        </span>
                                    </td>

                                    <td>
                                        <ul class="mb-0 ps-3">
                                            <c:forEach var="item"
                                                       items="${ordem.itens}">
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
                                                <span class="badge text-bg-success">
                                                    Paga
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="d-block mb-1">
                                                    Executada
                                                </span>
                                                <span class="badge text-bg-warning">
                                                    Pagamento pendente
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end">
                                        <fmt:formatNumber
                                            value="${ordem.valorTotal}"
                                            type="currency"
                                            currencySymbol="R$" />
                                    </td>

                                    <td class="text-end">
                                        <fmt:formatNumber
                                            value="${ordem.desconto}"
                                            type="currency"
                                            currencySymbol="R$" />
                                    </td>

                                    <td class="text-end">
                                        <fmt:formatNumber
                                            value="${ordem.valorTotal.subtract(ordem.desconto)}"
                                            type="currency"
                                            currencySymbol="R$" />
                                    </td>

                                    <td class="text-center">

                                        <c:url var="urlDetalhes" value="/mvc">
                                            <c:param name="logica"
                                                     value="DetalhesOrdemLogica" />
                                            <c:param name="id"
                                                     value="${ordem.id}" />
                                        </c:url>

                                        <a href="<c:out value='${urlDetalhes}' />"
                                           class="btn btn-outline-info btn-sm text-nowrap">
                                            Detalhes da ordem
                                            <span class="visually-hidden">
                                                <c:out value="${ordem.id}" />
                                            </span>
                                        </a>

                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty ordens}">
                                <tr>
                                    <td colspan="10" class="text-center py-4">
                                        Nenhum serviço realizado
                                        no período informado.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>

                        <tfoot>
                            <tr>
                                <th colspan="8" scope="row">
                                    Total faturado no período
                                </th>

                                <td class="text-end">
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

                </div>

                <div class="dados-resumo mt-4">
                    <p class="mb-2">
                        O total inclui ordens executadas e pagas,
                        considerando os descontos já registrados.
                        Não representa apenas pagamentos recebidos.
                    </p>

                    <p class="mb-0">
                        Ordens com pagamento pendente ainda podem receber
                        desconto na confirmação do pagamento.
                    </p>
                </div>

            </c:if>

            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/menu-principal.jsp"
                   class="btn btn-outline-light">
                    Voltar ao início
                </a>
            </div>

        </section>

    </main>

    <c:import url="/WEB-INF/components/rodape.jsp" />
    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>