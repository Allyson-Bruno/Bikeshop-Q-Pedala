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

    <title>Histórico por bicicleta — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <fmt:setLocale value="pt_BR" />

    <main class="container py-4 py-md-5">

        <section class="listagem-card"
                 aria-labelledby="titulo-historico">

            <h1 id="titulo-historico" class="h3 mb-2">
                Histórico por bicicleta
            </h1>

            <p class="listagem-descricao mb-4">
                Consulte os serviços realizados em uma bicicleta
                pelo número de série.
            </p>

            <form action="${pageContext.request.contextPath}/mvc"
                  method="get"
                  class="filtro-listagem mb-4">

                <input type="hidden"
                       name="logica"
                       value="HistoricoBicicletaLogica">

                <div class="row g-3 align-items-end">

                    <div class="col-12 col-sm-7 col-lg-4">
                        <label for="numeroSerie" class="form-label">
                            Número de série
                        </label>

                        <input type="text"
                               class="form-control"
                               id="numeroSerie"
                               name="numeroSerie"
                               maxlength="50"
                               required
                               value="<c:out value='${numeroSerieBuscado}' />">
                    </div>

                    <div class="col-12 col-sm-auto">
                        <button type="submit" class="btn btn-destaque">
                            Buscar histórico
                        </button>
                    </div>

                </div>

            </form>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <c:if test="${not empty bicicleta and empty erro}">

                <div class="dados-resumo mb-4">

                    <h2 class="h5 mb-3">
                        Bicicleta encontrada
                    </h2>

                    <p class="mb-2">
                        <strong>Marca:</strong>
                        <c:out value="${bicicleta.marca}" />
                    </p>

                    <p class="mb-2">
                        <strong>Modelo:</strong>
                        <c:out value="${bicicleta.modelo}" />
                    </p>

                    <p class="mb-0">
                        <strong>Número de série:</strong>
                        <c:out value="${bicicleta.numeroSerie}" />
                    </p>

                </div>

                <h2 class="h5 mb-3">
                    Serviços realizados
                </h2>

                <div class="table-responsive tabela-container"
                     role="region"
                     aria-label="Histórico de serviços da bicicleta"
                     tabindex="0">

                    <table class="table tabela-sistema tabela-historico
                                  table-hover align-middle mb-0">

                        <caption class="visually-hidden">
                            Ordens de serviço, datas de execução,
                            clientes registrados, situação dos pagamentos
                            e valores.
                        </caption>

                        <thead>
                            <tr>
                                <th scope="col">OS</th>
                                <th scope="col">Data da execução</th>
                                <th scope="col">Cliente registrado na OS</th>
                                <th scope="col">Status</th>
                                <th scope="col" class="text-end">
                                    Total dos serviços
                                </th>
                                <th scope="col" class="text-end">
                                    Desconto
                                </th>
                                <th scope="col" class="text-end">
                                    Valor final
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
                                    <td colspan="8" class="text-center py-4">
                                        Esta bicicleta ainda não possui
                                        serviços realizados.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>

                    </table>

                </div>

                <p class="listagem-descricao mt-3 mb-0">
                    Para ordens com pagamento pendente, o valor final
                    apresentado ainda não considera um possível desconto
                    na confirmação do pagamento.
                </p>

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