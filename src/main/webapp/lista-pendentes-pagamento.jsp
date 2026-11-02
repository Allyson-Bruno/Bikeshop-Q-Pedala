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

    <title>Pagamentos pendentes — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <fmt:setLocale value="pt_BR" />

    <main class="container py-4 py-md-5">

        <section class="listagem-card"
                 aria-labelledby="titulo-pagamentos">

            <h1 id="titulo-pagamentos" class="h3 mb-2">
                Pagamentos pendentes
            </h1>

            <p class="listagem-descricao mb-4">
                Consulte as ordens de serviço executadas
                que aguardam pagamento.
            </p>

            <c:if test="${param.pago == 'true'}">
                <div class="alert alert-success" role="status">
                    Pagamento registrado com sucesso.
                </div>
            </c:if>

            <div class="table-responsive tabela-container"
                 role="region"
                 aria-label="Tabela de pagamentos pendentes"
                 tabindex="0">

                <table class="table tabela-sistema tabela-pagamentos
                              table-hover align-middle mb-0">

                    <caption class="visually-hidden">
                        Ordens de serviço pendentes de pagamento,
                        clientes, bicicletas e totais dos serviços.
                    </caption>

                    <thead>
                        <tr>
                            <th scope="col">OS</th>
                            <th scope="col">Data da execução</th>
                            <th scope="col">Cliente</th>
                            <th scope="col">Bicicleta</th>
                            <th scope="col" class="text-end">
                                Total dos serviços
                            </th>
                            <th scope="col" class="text-center">
                                Ações
                            </th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="ordem" items="${ordens}">
                            <tr>
                                <td class="text-nowrap">
                                    <c:out value="${ordem.id}" />
                                </td>

                                <td class="text-nowrap">
                                    <c:out value="${ordem.dataExecucao}" />
                                </td>

                                <td>
                                    <c:out value="${ordem.cliente.nome}" />

                                    <span class="d-block text-nowrap">
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

                                <td class="text-end text-nowrap">
                                    <fmt:formatNumber
                                        value="${ordem.valorTotal}"
                                        type="currency"
                                        currencySymbol="R$" />
                                </td>

                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/mvc?logica=FormularioPagamentoLogica&amp;id=${ordem.id}"
                                       class="btn btn-outline-info btn-sm text-nowrap">
                                        Realizar pagamento
                                        <span class="visually-hidden">
                                            da OS <c:out value="${ordem.id}" />
                                        </span>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty ordens}">
                            <tr>
                                <td colspan="6" class="text-center py-4">
                                    Nenhuma ordem de serviço
                                    pendente de pagamento.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>

                </table>

            </div>

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