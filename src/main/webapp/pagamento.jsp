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

    <title>Pagamento — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <fmt:setLocale value="pt_BR" />

    <main class="container py-4 py-md-5">

        <section class="formulario-card pagamento-card"
                 aria-labelledby="titulo-pagamento">

            <h1 id="titulo-pagamento" class="h3 mb-2">
                Realizar pagamento
            </h1>

            <p class="formulario-descricao mb-4">
                Confira os serviços realizados e os valores
                antes de confirmar o pagamento.
            </p>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty ordem}">

                    <div class="dados-resumo mb-4">

                        <p class="mb-2">
                            <strong>OS:</strong>
                            <c:out value="${ordem.id}" />
                        </p>

                        <p class="mb-2">
                            <strong>Cliente:</strong>
                            <c:out value="${ordem.cliente.nome}" />
                        </p>

                        <p class="mb-2">
                            <strong>CPF:</strong>
                            <c:out value="${ordem.cliente.cpf}" />
                        </p>

                        <p class="mb-2">
                            <strong>Bicicleta:</strong>
                            <c:out value="${ordem.bicicleta.marca}" />
                            — <c:out value="${ordem.bicicleta.modelo}" />
                        </p>

                        <p class="mb-2">
                            <strong>Série:</strong>
                            <c:out value="${ordem.bicicleta.numeroSerie}" />
                        </p>

                        <p class="mb-0">
                            <strong>Data da execução:</strong>
                            <c:out value="${ordem.dataExecucao}" />
                        </p>

                    </div>

                    <h2 class="h5 mb-3">
                        Serviços realizados
                    </h2>

                    <div class="table-responsive tabela-container mb-3"
                         role="region"
                         aria-label="Tabela de serviços realizados"
                         tabindex="0">

                        <table class="table tabela-sistema tabela-pagamento-itens
                                      table-hover align-middle mb-0">

                            <caption class="visually-hidden">
                                Serviços realizados e valores aplicados à OS.
                            </caption>

                            <thead>
                                <tr>
                                    <th scope="col">Serviço</th>
                                    <th scope="col" class="text-end text-nowrap">
                                        Valor aplicado
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
                            </tbody>

                        </table>

                    </div>

                    <p class="formulario-descricao">
                        Quantidade de serviços realizados:
                        <strong>
                            <c:out value="${quantidadeExecutada}" />
                        </strong>
                    </p>

                    <div class="dados-resumo mb-4">
                        <p class="mb-0">
                            <strong>Total sem desconto:</strong>
                            <span class="d-inline-block">
                                <fmt:formatNumber
                                    value="${ordem.valorTotal}"
                                    type="currency"
                                    currencySymbol="R$" />
                            </span>
                        </p>
                    </div>

                    <form action="${pageContext.request.contextPath}/mvc"
                          method="post">

                        <input type="hidden"
                               name="logica"
                               value="RegistrarPagamentoLogica">

                        <input type="hidden"
                               name="id"
                               value="<c:out value='${ordem.id}' />">

                        <c:choose>
                            <c:when test="${permiteDesconto}">

                                <fieldset class="pagamento-desconto mb-4">

                                    <legend class="h5">
                                        Desconto opcional
                                    </legend>

                                    <p class="formulario-descricao">
                                        Esta OS possui três ou mais serviços
                                        realizados e permite desconto de 10%.
                                    </p>

                                    <p class="mb-2">
                                        <strong>Desconto:</strong>
                                        <span class="d-inline-block">
                                            <fmt:formatNumber
                                                value="${descontoPossivel}"
                                                type="currency"
                                                currencySymbol="R$" />
                                        </span>
                                    </p>

                                    <p class="mb-3">
                                        <strong>Total com desconto:</strong>
                                        <span class="d-inline-block">
                                            <fmt:formatNumber
                                                value="${totalComDesconto}"
                                                type="currency"
                                                currencySymbol="R$" />
                                        </span>
                                    </p>

                                    <div class="form-check">
                                        <input type="checkbox"
                                               class="form-check-input"
                                               id="aplicarDesconto"
                                               name="aplicarDesconto"
                                               value="true"
                                               aria-describedby="orientacao-desconto"
                                               ${param.aplicarDesconto eq 'true'
                                                   ? 'checked' : ''}>

                                        <label class="form-check-label"
                                               for="aplicarDesconto">
                                            Confirmo a aplicação do desconto de 10%.
                                        </label>
                                    </div>

                                    <p id="orientacao-desconto"
                                       class="form-text mt-2 mb-0">
                                        Sem marcar esta opção, o pagamento será
                                        registrado pelo total sem desconto.
                                    </p>

                                </fieldset>

                            </c:when>

                            <c:otherwise>
                                <p class="formulario-descricao mb-4">
                                    O desconto de 10% está disponível somente
                                    para OS com três ou mais serviços realizados.
                                </p>
                            </c:otherwise>
                        </c:choose>

                        <button type="submit" class="btn btn-destaque">
                            Confirmar pagamento
                        </button>

                    </form>

                </c:when>

                <c:otherwise>
                    <div class="alert alert-warning" role="alert">
                        Nenhuma OS foi carregada.
                        Acesse o pagamento pela listagem de pendências.
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/mvc?logica=ListarPendentesPagamentoLogica"
                   class="btn btn-outline-light">
                    Voltar aos pagamentos pendentes
                </a>
            </div>

        </section>

    </main>

    <c:import url="/WEB-INF/components/rodape.jsp" />
    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>