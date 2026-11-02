<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Agendamentos pendentes — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <section class="listagem-card"
                 aria-labelledby="titulo-agendamentos">

            <div class="d-flex flex-column flex-sm-row
                        justify-content-between align-items-start gap-3 mb-4">

                <div>
                    <h1 id="titulo-agendamentos" class="h3 mb-2">
                        Agendamentos pendentes
                    </h1>

                    <p class="listagem-descricao mb-0">
                        Consulte os agendamentos e registre os serviços realizados.
                    </p>
                </div>

                <a href="${pageContext.request.contextPath}/mvc?logica=FormularioAgendamentoLogica"
                   class="btn btn-destaque flex-shrink-0">
                    Novo agendamento
                </a>

            </div>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <c:if test="${param.cancelado == 'true'}">
                <div class="alert alert-success" role="status">
                    Agendamento cancelado com sucesso.
                </div>
            </c:if>

            <c:if test="${param.cancelado == 'false'}">
                <div class="alert alert-warning" role="alert">
                    Não foi possível cancelar:
                    a OS não existe ou já não está agendada.
                </div>
            </c:if>

            <c:if test="${param.executada == 'true'}">
                <div class="alert alert-success" role="status">
                    Execução registrada com sucesso.
                </div>
            </c:if>

            <!-- Filtro de consulta -->
            <form action="${pageContext.request.contextPath}/mvc"
                  method="get"
                  class="filtro-listagem mb-4">

                <input type="hidden"
                       name="logica"
                       value="ListarAgendamentosLogica">

                <div class="row g-3 align-items-end">

                    <div class="col-12 col-sm-6 col-lg-3">
                        <label for="data" class="form-label">
                            Data
                        </label>

                        <input type="date"
                               class="form-control"
                               id="data"
                               name="data"
                               required
                               value="<c:out value='${dataFiltro}' />">
                    </div>

                    <div class="col-12 col-sm-6 col-lg-4">
                        <label for="modo" class="form-label">
                            Consultar
                        </label>

                        <select class="form-select"
                                data-bs-theme="dark"
                                id="modo"
                                name="modo">

                            <option value="apartir"
                                ${modoFiltro == 'apartir' ? 'selected' : ''}>
                                A partir da data
                            </option>

                            <option value="exata"
                                ${modoFiltro == 'exata' ? 'selected' : ''}>
                                Somente na data
                            </option>

                        </select>
                    </div>

                    <div class="col-12 col-lg-auto">
                        <button type="submit" class="btn btn-destaque">
                            Consultar
                        </button>
                    </div>

                </div>

            </form>

            <c:if test="${empty erro}">

                <div class="table-responsive tabela-container"
                     role="region"
                     aria-label="Tabela de agendamentos pendentes"
                     tabindex="0">

                    <table class="table tabela-sistema tabela-agendamentos
                                  table-hover align-middle mb-0">

                        <caption class="visually-hidden">
                            Ordens de serviço agendadas, clientes,
                            bicicletas, serviços previstos e ações.
                        </caption>

                        <thead>
                            <tr>
                                <th scope="col">OS</th>
                                <th scope="col">Data do agendamento</th>
                                <th scope="col">Cliente</th>
                                <th scope="col">Bicicleta</th>
                                <th scope="col">Serviços previstos</th>
                                <th scope="col">Ações</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="ordem" items="${agendamentos}">
                                <tr>
                                    <td class="text-nowrap">
                                        <c:out value="${ordem.id}" />
                                    </td>

                                    <td class="text-nowrap">
                                        <c:out value="${ordem.dataAgendamento}" />
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

                                    <td>
                                        <ul class="mb-0 ps-3">
                                            <c:forEach var="item"
                                                       items="${ordem.itens}">
                                                <li>
                                                    <c:out value="${item.servico.nome}" />
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </td>

                                    <td>
                                        <div class="d-flex flex-column
                                                    align-items-start gap-2">

                                            <a href="${pageContext.request.contextPath}/mvc?logica=FormularioExecucaoLogica&amp;id=${ordem.id}"
                                               class="btn btn-outline-info btn-sm text-nowrap">
                                                Registrar execução
                                                <span class="visually-hidden">
                                                    da OS <c:out value="${ordem.id}" />
                                                </span>
                                            </a>

                                            <form action="${pageContext.request.contextPath}/mvc"
                                                  method="post"
                                                  class="m-0"
                                                  onsubmit="return confirm('Deseja realmente cancelar essa ordem de serviço?');">

                                                <input type="hidden"
                                                       name="logica"
                                                       value="CancelarAgendamentoLogica">

                                                <input type="hidden"
                                                       name="id"
                                                       value="${ordem.id}">

                                                <input type="hidden"
                                                       name="data"
                                                       value="<c:out value='${dataFiltro}' />">

                                                <input type="hidden"
                                                       name="modo"
                                                       value="<c:out value='${modoFiltro}' />">

                                                <button type="submit"
                                                        class="btn btn-outline-danger btn-sm text-nowrap">
                                                    Cancelar OS
                                                    <span class="visually-hidden">
                                                        <c:out value="${ordem.id}" />
                                                    </span>
                                                </button>

                                            </form>

                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty agendamentos}">
                                <tr>
                                    <td colspan="6" class="text-center py-4">
                                        Nenhum agendamento pendente encontrado
                                        para o filtro informado.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>

                    </table>

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