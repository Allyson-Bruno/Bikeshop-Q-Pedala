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

    <title>Serviços — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <fmt:setLocale value="pt_BR" />

    <main class="container py-4 py-md-5">

        <section class="listagem-card"
                 aria-labelledby="titulo-servicos">

            <div class="d-flex flex-column flex-sm-row
                        justify-content-between align-items-start gap-3 mb-4">

                <div>
                    <h1 id="titulo-servicos" class="h3 mb-2">
                        Serviços oferecidos
                    </h1>

                    <p class="listagem-descricao mb-0">
                        Consulte os serviços e atualize seus valores.
                    </p>
                </div>

                <a href="${pageContext.request.contextPath}/cadastro-servico.jsp"
                   class="btn btn-destaque flex-shrink-0">
                    Cadastrar serviço
                </a>

            </div>

            <c:if test="${param.alterado == 'true'}">
                <div class="alert alert-success" role="status">
                    Valor do serviço alterado com sucesso.
                </div>
            </c:if>

            <div class="table-responsive tabela-container"
                 role="region"
                 aria-label="Tabela de serviços"
                 tabindex="0">

                <table class="table tabela-sistema tabela-servicos
                              table-hover align-middle mb-0">

                    <caption class="visually-hidden">
                        Serviços oferecidos, seus valores e opção de alteração.
                    </caption>

                    <thead>
                        <tr>
                            <th scope="col">Nome</th>
                            <th scope="col" class="text-end">Valor</th>
                            <th scope="col" class="text-center">Ações</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="servico" items="${servicos}">
                            <tr>
                                <td class="tabela-servico-nome">
                                    <c:out value="${servico.nome}" />
                                </td>

                                <td class="text-end text-nowrap">
                                    <fmt:formatNumber
                                        value="${servico.valor}"
                                        type="currency"
                                        currencyCode="BRL" />
                                </td>

                                <td class="text-center text-nowrap">
                                    <a href="${pageContext.request.contextPath}/mvc?logica=FormularioAlterarValorServicoLogica&amp;id=${servico.id}"
                                       class="btn btn-outline-info btn-sm">
                                        Alterar valor
                                        <span class="visually-hidden">
                                            de <c:out value="${servico.nome}" />
                                        </span>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty servicos}">
                            <tr>
                                <td colspan="3" class="text-center py-4">
                                    Nenhum serviço cadastrado.
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