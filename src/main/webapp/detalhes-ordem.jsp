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

    <title>Detalhes da ordem — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <fmt:setLocale value="pt_BR" />

    <main class="container py-4 py-md-5">

        <section class="listagem-card detalhes-ordem-card"
                 aria-labelledby="titulo-detalhes">

            <h1 id="titulo-detalhes" class="h3 mb-2">
                Detalhes da ordem de serviço
            </h1>

            <p class="listagem-descricao mb-4">
                Consulte os dados da ordem, os serviços realizados
                e os valores registrados.
            </p>

            <c:choose>
                <c:when test="${not empty ordem}">

                    <div class="dados-resumo mb-4">

                        <p class="mb-2">
                            <strong>OS:</strong>
                            <c:out value="${ordem.id}" />
                        </p>

                        <p class="mb-3">
                            <strong>Status:</strong>

                            <c:choose>
                                <c:when test="${ordem.status eq 'PAGA'}">
                                    <span class="badge text-bg-success">
                                        Paga
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    Executada
                                    <span class="badge text-bg-warning">
                                        Pagamento pendente
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="row g-3">

                            <div class="col-12 col-md-6">
                                <p class="mb-2">
                                    <strong>Cliente registrado na OS:</strong>
                                    <span class="d-block">
                                        <c:out value="${ordem.cliente.nome}" />
                                    </span>
                                </p>

                                <p class="mb-0">
                                    <strong>CPF:</strong>
                                    <c:out value="${ordem.cliente.cpf}" />
                                </p>
                            </div>

                            <div class="col-12 col-md-6">
                                <p class="mb-2">
                                    <strong>Bicicleta:</strong>
                                    <span class="d-block">
                                        <c:out value="${ordem.bicicleta.marca}" />
                                        — <c:out value="${ordem.bicicleta.modelo}" />
                                    </span>
                                </p>

                                <p class="mb-0">
                                    <strong>Série:</strong>
                                    <c:out value="${ordem.bicicleta.numeroSerie}" />
                                </p>
                            </div>

                            <div class="col-12 col-md-6">
                                <p class="mb-0">
                                    <strong>Data do agendamento:</strong>
                                    <c:out value="${ordem.dataAgendamento}" />
                                </p>
                            </div>

                            <div class="col-12 col-md-6">
                                <p class="mb-0">
                                    <strong>Data da execução:</strong>
                                    <c:out value="${ordem.dataExecucao}" />
                                </p>
                            </div>

                        </div>

                    </div>

                    <h2 class="h5 mb-3">
                        Serviços realizados
                    </h2>

                    <div class="table-responsive tabela-container mb-4"
                         role="region"
                         aria-label="Serviços realizados na ordem"
                         tabindex="0">

                        <table class="table tabela-sistema tabela-detalhes-itens
                                      table-hover align-middle mb-0">

                            <caption class="visually-hidden">
                                Serviços realizados e valores registrados
                                na execução.
                            </caption>

                            <thead>
                                <tr>
                                    <th scope="col">Serviço</th>
                                    <th scope="col" class="text-end">
                                        Valor registrado na execução
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="item" items="${ordem.itens}">
                                    <tr>
                                        <td>
                                            <c:out value="${item.servico.nome}" />
                                        </td>

                                        <td class="text-end text-nowrap">
                                            <fmt:formatNumber
                                                value="${item.valor}"
                                                type="currency"
                                                currencySymbol="R$" />
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty ordem.itens}">
                                    <tr>
                                        <td colspan="2" class="text-center py-4">
                                            Nenhum serviço realizado encontrado.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>

                        </table>

                    </div>

                    <div class="dados-resumo mb-4">

                        <h2 class="h5 mb-3">
                            Valores da ordem
                        </h2>

                        <p class="mb-2">
                            <strong>Total dos serviços:</strong>
                            <span class="d-inline-block">
                                <fmt:formatNumber
                                    value="${ordem.valorTotal}"
                                    type="currency"
                                    currencySymbol="R$" />
                            </span>
                        </p>

                        <p class="mb-2">
                            <strong>Desconto aplicado:</strong>
                            <span class="d-inline-block">
                                <fmt:formatNumber
                                    value="${ordem.desconto}"
                                    type="currency"
                                    currencySymbol="R$" />
                            </span>
                        </p>

                        <p class="fs-5 mb-0">
                            <strong>Valor final:</strong>
                            <span class="d-inline-block">
                                <fmt:formatNumber
                                    value="${ordem.valorTotal.subtract(ordem.desconto)}"
                                    type="currency"
                                    currencySymbol="R$" />
                            </span>
                        </p>

                    </div>

                    <c:if test="${ordem.status eq 'EXECUTADA'}">
                        <div class="alert alert-warning">
                            Pagamento pendente. O valor apresentado ainda
                            não considera um possível desconto na
                            confirmação do pagamento.
                        </div>
                    </c:if>

                    <c:url var="urlHistoricoCliente" value="/mvc">
                        <c:param name="logica"
                                 value="HistoricoClienteLogica" />
                        <c:param name="cpf"
                                 value="${ordem.cliente.cpf}" />
                    </c:url>

                    <c:url var="urlHistoricoBicicleta" value="/mvc">
                        <c:param name="logica"
                                 value="HistoricoBicicletaLogica" />
                        <c:param name="numeroSerie"
                                 value="${ordem.bicicleta.numeroSerie}" />
                    </c:url>

                    <div class="d-flex flex-column flex-sm-row flex-wrap gap-2">
                        <a href="<c:out value='${urlHistoricoCliente}' />"
                           class="btn btn-outline-info">
                            Ver histórico deste cliente
                        </a>

                        <a href="<c:out value='${urlHistoricoBicicleta}' />"
                           class="btn btn-outline-info">
                            Ver histórico desta bicicleta
                        </a>
                    </div>

                </c:when>

                <c:otherwise>
                    <div class="alert alert-warning" role="alert">
                        Nenhuma OS foi carregada.
                        Acesse os detalhes pela listagem do histórico.
                    </div>
                </c:otherwise>
            </c:choose>

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