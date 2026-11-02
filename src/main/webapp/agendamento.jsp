<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Agendamento — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <div class="agendamento-layout">

            <!-- Cartão da esquerda: cliente e dados do agendamento -->
            <section class="formulario-card agendamento-dados"
                     aria-labelledby="titulo-agendamento">

                <h1 id="titulo-agendamento" class="h3 mb-2">
                    Agendamento de serviço
                </h1>

                <p class="formulario-descricao mb-4">
                    Busque o cliente pelo CPF para selecionar
                    a bicicleta e os serviços.
                </p>

                <c:if test="${not empty erro}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${erro}" />
                    </div>
                </c:if>

                <c:if test="${param.sucesso == 'true'}">
                    <div class="alert alert-success" role="status">
                        Agendamento realizado com sucesso.
                    </div>
                </c:if>

                <!-- Busca do cliente -->
                <form action="${pageContext.request.contextPath}/mvc"
                      method="get">

                    <input type="hidden"
                           name="logica"
                           value="FormularioAgendamentoLogica">

                    <div class="row g-3 align-items-end">

                        <div class="col-12 col-sm-7">
                            <label for="cpf" class="form-label">
                                CPF do cliente
                            </label>

                            <input type="text"
                                   class="form-control"
                                   id="cpf"
                                   name="cpf"
                                   required
                                   maxlength="11"
                                   pattern="[0-9]{11}"
                                   inputmode="numeric"
                                   placeholder="Somente os 11 números"
                                   value="<c:out value='${param.cpf}' />">
                        </div>

                        <div class="col-12 col-sm-5">
                            <button type="submit" class="btn btn-destaque">
                                Buscar cliente
                            </button>
                        </div>

                    </div>

                </form>

                <c:if test="${not empty cliente}">

                    <section class="dados-resumo mt-4"
                             aria-labelledby="titulo-cliente">

                        <h2 id="titulo-cliente" class="h5 mb-3">
                            Cliente encontrado
                        </h2>

                        <p class="mb-2">
                            <strong>Nome:</strong>
                            <c:out value="${cliente.nome}" />
                        </p>

                        <p class="mb-2">
                            <strong>CPF:</strong>
                            <c:out value="${cliente.cpf}" />
                        </p>

                        <p class="mb-0">
                            <strong>Telefone:</strong>
                            <c:out value="${cliente.telefone}" />
                        </p>

                    </section>

                    <c:if test="${empty bicicletas}">
                        <div class="alert alert-warning mt-4" role="status">
                            Este cliente não possui bicicletas cadastradas.
                        </div>
                    </c:if>

                    <c:if test="${empty servicos}">
                        <div class="alert alert-warning mt-4" role="status">
                            Nenhum serviço disponível para agendamento.
                        </div>
                    </c:if>

                    <c:if test="${not empty bicicletas and not empty servicos}">

                        <!-- Confirmação do agendamento -->
                        <form action="${pageContext.request.contextPath}/mvc"
                              method="post"
                              id="form-agendamento"
                              class="mt-4">

                            <input type="hidden"
                                   name="logica"
                                   value="AgendarServicoLogica">

                            <input type="hidden"
                                   name="idCliente"
                                   value="<c:out value='${cliente.id}' />">

                            <input type="hidden"
                                   name="cpf"
                                   value="<c:out value='${cliente.cpf}' />">

                            <div class="mb-3">
                                <label for="idBicicleta" class="form-label">
                                    Bicicleta
                                </label>

                                <select class="form-select"
                                        data-bs-theme="dark"
                                        id="idBicicleta"
                                        name="idBicicleta"
                                        required>

                                    <option value="">Selecione</option>

                                    <c:forEach var="bicicleta"
                                               items="${bicicletas}">

                                        <option value="${bicicleta.id}"
                                            ${param.idBicicleta == bicicleta.id.toString()
                                                ? 'selected' : ''}>

                                            <c:out value="${bicicleta.marca}" />
                                            — <c:out value="${bicicleta.modelo}" />
                                            — Série:
                                            <c:out value="${bicicleta.numeroSerie}" />

                                        </option>

                                    </c:forEach>

                                </select>
                            </div>

                            <div class="row">
                                <div class="col-12 col-sm-6">
                                    <label for="dataAgendamento"
                                           class="form-label">
                                        Data do agendamento
                                    </label>

                                    <input type="date"
                                           class="form-control"
                                           id="dataAgendamento"
                                           name="dataAgendamento"
                                           required
                                           value="<c:out value='${param.dataAgendamento}' />">
                                </div>
                            </div>

                            <button type="submit"
                                    class="btn btn-destaque mt-4">
                                Confirmar agendamento
                            </button>

                        </form>

                    </c:if>

                </c:if>

                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/menu-principal.jsp"
                       class="btn btn-outline-light">
                        Voltar ao início
                    </a>
                </div>

            </section>

            <!-- Cartão da direita: seleção dos serviços -->
            <c:if test="${not empty cliente
                          and not empty bicicletas
                          and not empty servicos}">

                <section class="formulario-card agendamento-servicos"
                         aria-labelledby="titulo-servicos">

                    <h2 id="titulo-servicos" class="h4 mb-2">
                        Serviços
                    </h2>

                    <p class="formulario-descricao mb-3">
                        Selecione um ou mais serviços para a bicicleta.
                    </p>

                    <fieldset class="servicos-selecao">
                        <legend class="visually-hidden">
                            Serviços que serão realizados
                        </legend>

                        <c:forEach var="servico" items="${servicos}">

                            <c:set var="selecionado" value="${false}" />

                            <c:forEach var="idSelecionado"
                                       items="${paramValues.idServicos}">

                                <c:if test="${idSelecionado == servico.id.toString()}">
                                    <c:set var="selecionado" value="${true}" />
                                </c:if>

                            </c:forEach>

                            <div class="form-check servico-opcao">
                                <input type="checkbox"
                                       class="form-check-input"
                                       id="servico-${servico.id}"
                                       name="idServicos"
                                       value="${servico.id}"
                                       form="form-agendamento"
                                       ${selecionado ? 'checked' : ''}>

                                <label class="form-check-label"
                                       for="servico-${servico.id}">
                                    <c:out value="${servico.nome}" />
                                </label>
                            </div>

                        </c:forEach>

                    </fieldset>

                </section>

            </c:if>

        </div>

    </main>

    <c:import url="/WEB-INF/components/rodape.jsp" />

    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>