<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Bicicletas — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <section class="listagem-card"
                 aria-labelledby="titulo-bicicletas">

            <div class="d-flex flex-column flex-sm-row
                        justify-content-between align-items-start gap-3 mb-4">

                <div>
                    <h1 id="titulo-bicicletas" class="h3 mb-2">
                        Bicicletas cadastradas
                    </h1>

                    <p class="listagem-descricao mb-0">
                        Consulte os dados das bicicletas e seus proprietários.
                    </p>
                </div>

                <a href="${pageContext.request.contextPath}/mvc?logica=FormularioBicicletaLogica"
                   class="btn btn-destaque flex-shrink-0">
                    Cadastrar bicicleta
                </a>

            </div>

            <div class="table-responsive tabela-container"
                 role="region"
                 aria-label="Tabela de bicicletas"
                 tabindex="0">

                <table class="table tabela-sistema tabela-bicicletas
                              table-hover align-middle mb-0">

                    <caption class="visually-hidden">
                        Bicicletas cadastradas e seus proprietários.
                    </caption>

                    <thead>
                        <tr>
                            <th scope="col">Marca</th>
                            <th scope="col">Modelo</th>
                            <th scope="col">Tipo</th>
                            <th scope="col">Tamanho do quadro</th>
                            <th scope="col">Número de série</th>
                            <th scope="col">Ano de fabricação</th>
                            <th scope="col">Proprietário</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="bicicleta" items="${bicicletas}">
                            <tr>
                                <td>
                                    <c:out value="${bicicleta.marca}" />
                                </td>

                                <td>
                                    <c:out value="${bicicleta.modelo}" />
                                </td>

                                <td>
                                    <c:out value="${bicicleta.tipo}" />
                                </td>

                                <td>
                                    <c:out value="${bicicleta.tamanhoQuadro}" />
                                </td>

                                <td class="tabela-numero-serie">
                                    <c:out value="${bicicleta.numeroSerie}" />
                                </td>

                                <td>
                                    <c:out value="${bicicleta.anoFabricacao}" />
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty bicicleta.proprietario}">
                                            <c:out value="${bicicleta.proprietario.nome}" />

                                            <span class="d-block text-nowrap">
                                                CPF:
                                                <c:out value="${bicicleta.proprietario.cpf}" />
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            Sem proprietário
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty bicicletas}">
                            <tr>
                                <td colspan="7" class="text-center py-4">
                                    Nenhuma bicicleta cadastrada.
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