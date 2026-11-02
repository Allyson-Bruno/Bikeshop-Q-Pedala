<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Registrar execução — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <div class="agendamento-layout">

            <!-- Dados da ordem de serviço -->
            <section class="formulario-card agendamento-dados"
                     aria-labelledby="titulo-execucao">

                <h1 id="titulo-execucao" class="h3 mb-2">
                    Registrar execução
                </h1>

                <p class="formulario-descricao mb-4">
                    Informe a data e selecione os serviços
                    efetivamente realizados.
                </p>

                <c:if test="${not empty erro}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${erro}" />
                    </div>
                </c:if>

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
                        <strong>Data do agendamento:</strong>
                        <c:out value="${ordem.dataAgendamento}" />
                    </p>

                </div>

                <form action="${pageContext.request.contextPath}/mvc"
                      method="post"
                      id="form-execucao">

                    <input type="hidden"
                           name="logica"
                           value="RegistrarExecucaoLogica">

                    <input type="hidden"
                           name="id"
                           value="<c:out value='${ordem.id}' />">

                    <div class="row">
                        <div class="col-12 col-sm-6">
                            <label for="dataExecucao" class="form-label">
                                Data da execução
                            </label>

                            <input type="date"
                                   class="form-control"
                                   id="dataExecucao"
                                   name="dataExecucao"
                                   required
                                   value="<c:out value='${param.dataExecucao}' />">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-destaque mt-4">
                        Confirmar execução
                    </button>

                </form>

                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/mvc?logica=ListarAgendamentosLogica"
                       class="btn btn-outline-light">
                        Voltar aos agendamentos
                    </a>
                </div>

            </section>

            <!-- Serviços realizados e valores aplicados -->
            <section class="formulario-card agendamento-servicos"
                     aria-labelledby="titulo-servicos">

                <h2 id="titulo-servicos" class="h4 mb-2">
                    Serviços realizados
                </h2>

                <p class="formulario-descricao mb-3">
                    Marque os serviços realizados e confira o valor de cada um.
                    O preço atual do catálogo aparece como sugestão.
                    Se o serviço foi realizado anteriormente, informe
                    o valor aplicado naquela ocasião.
                </p>

                <p id="orientacao-valores" class="form-text mb-4">
                    Use vírgula ou ponto para os centavos,
                    sem separador de milhar. Ex.: 1500,50.
                </p>

                <fieldset class="servicos-selecao">
                    <legend class="visually-hidden">
                        Seleção dos serviços realizados e seus valores
                    </legend>

                    <c:forEach var="item" items="${ordem.itens}">

                        <%-- Recupera a seleção após uma validação inválida. --%>
                        <c:set var="selecionado" value="${false}" />

                        <c:forEach var="idSelecionado"
                                   items="${paramValues.idItens}">

                            <c:if test="${idSelecionado eq item.id.toString()}">
                                <c:set var="selecionado" value="${true}" />
                            </c:if>

                        </c:forEach>

                        <%-- Cada item mantém seu parâmetro de valor. --%>
                        <c:set var="nomeCampoValor"
                               value="valorItem_${item.id}" />

                        <%-- Preserva o valor enviado, inclusive vazio. --%>
                        <c:set var="valorExibido"
                               value="${item.servico.valor}" />

                        <c:if test="${param[nomeCampoValor] != null}">
                            <c:set var="valorExibido"
                                   value="${param[nomeCampoValor]}" />
                        </c:if>

                        <div class="execucao-item">

                            <div class="form-check mb-3">
                                <input type="checkbox"
                                       class="form-check-input"
                                       id="item-${item.id}"
                                       name="idItens"
                                       value="${item.id}"
                                       form="form-execucao"
                                       ${selecionado ? 'checked' : ''}>

                                <label class="form-check-label text-break"
                                       id="nome-item-${item.id}"
                                       for="item-${item.id}">
                                    <c:out value="${item.servico.nome}" />
                                </label>
                            </div>

                            <div class="execucao-valor">
                                <label for="valor-item-${item.id}"
                                       id="rotulo-valor-${item.id}"
                                       class="form-label">
                                    Valor aplicado (R$)
                                </label>

                                <input type="text"
                                       class="form-control"
                                       id="valor-item-${item.id}"
                                       name="${nomeCampoValor}"
                                       value="<c:out value='${valorExibido}' />"
                                       inputmode="decimal"
                                       placeholder="Ex.: 150,00"
                                       form="form-execucao"
                                       aria-labelledby="rotulo-valor-${item.id} nome-item-${item.id}"
                                       aria-describedby="orientacao-valores">
                            </div>

                        </div>

                    </c:forEach>

                </fieldset>

            </section>

        </div>

    </main>

    <c:import url="/WEB-INF/components/rodape.jsp" />

    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>