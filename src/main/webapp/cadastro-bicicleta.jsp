<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Cadastro de bicicleta — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <section class="formulario-card"
                 aria-labelledby="titulo-cadastro">

            <h1 id="titulo-cadastro" class="h3 mb-2">
                Cadastro de bicicleta
            </h1>

            <p class="formulario-descricao mb-4">
                Preencha os dados da bicicleta.
                O proprietário é opcional.
            </p>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <c:if test="${param.sucesso == 'true'}">
                <div class="alert alert-success" role="status">
                    Bicicleta cadastrada com sucesso.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/mvc"
                  method="post">

                <div class="row g-3">

                    <div class="col-12 col-md-6">
                        <label for="marca" class="form-label">
                            Marca
                        </label>

                        <input type="text"
                               class="form-control"
                               id="marca"
                               name="marca"
                               required
                               maxlength="60"
                               placeholder="Digite a marca"
                               value="<c:out value='${param.marca}' />">
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="modelo" class="form-label">
                            Modelo
                        </label>

                        <input type="text"
                               class="form-control"
                               id="modelo"
                               name="modelo"
                               required
                               maxlength="100"
                               placeholder="Digite o modelo"
                               value="<c:out value='${param.modelo}' />">
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="tipo" class="form-label">
                            Tipo
                        </label>

                        <select class="form-select"
                                data-bs-theme="dark"
                                id="tipo"
                                name="tipo"
                                required>

                            <option value="">Selecione</option>

                            <option value="MTB"
                                ${param.tipo == 'MTB' ? 'selected' : ''}>
                                MTB
                            </option>

                            <option value="Road"
                                ${param.tipo == 'Road' ? 'selected' : ''}>
                                Road
                            </option>

                            <option value="Gravel"
                                ${param.tipo == 'Gravel' ? 'selected' : ''}>
                                Gravel
                            </option>

                            <option value="BMX"
                                ${param.tipo == 'BMX' ? 'selected' : ''}>
                                BMX
                            </option>

                            <option value="Elétrica"
                                ${param.tipo == 'Elétrica' ? 'selected' : ''}>
                                Elétrica
                            </option>

                        </select>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="tamanhoQuadro" class="form-label">
                            Tamanho do quadro
                        </label>

                        <input type="text"
                               class="form-control"
                               id="tamanhoQuadro"
                               name="tamanhoQuadro"
                               required
                               maxlength="30"
                               placeholder="Ex.: 17, 54 cm ou M"
                               value="<c:out value='${param.tamanhoQuadro}' />">
                    </div>

                    <div class="col-12">
                        <label for="numeroSerie" class="form-label">
                            Número de série
                        </label>

                        <input type="text"
                               class="form-control"
                               id="numeroSerie"
                               name="numeroSerie"
                               required
                               maxlength="50"
                               placeholder="Digite o número de série"
                               value="<c:out value='${param.numeroSerie}' />">
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="anoFabricacao" class="form-label">
                            Ano de fabricação
                        </label>

                        <input type="number"
                               class="form-control"
                               id="anoFabricacao"
                               name="anoFabricacao"
                               required
                               min="1800"
                               step="1"
                               placeholder="Ex.: 2024"
                               value="<c:out value='${param.anoFabricacao}' />">
                    </div>

                    <div class="col-12">
                        <label for="idProprietario" class="form-label">
                            Proprietário (opcional)
                        </label>

                        <select class="form-select"
                                data-bs-theme="dark"
                                id="idProprietario"
                                name="idProprietario"
                                aria-describedby="ajuda-proprietario">

                            <option value="">Sem proprietário</option>

                            <c:forEach var="cliente" items="${clientes}">
                                <option value="${cliente.id}"
                                    ${param.idProprietario == cliente.id.toString()
                                        ? 'selected' : ''}>

                                    <c:out value="${cliente.nome}" />
                                    — <c:out value="${cliente.cpf}" />

                                </option>
                            </c:forEach>

                        </select>

                        <div id="ajuda-proprietario"
                             class="form-text">
                            Selecione um cliente ou mantenha
                            “Sem proprietário”.
                        </div>
                    </div>

                </div>

                <input type="hidden"
                       name="logica"
                       value="CadastroBicicletaLogica">

                <div class="d-flex flex-column flex-sm-row
                            align-items-start gap-2 mt-4">

                    <button type="submit" class="btn btn-destaque">
                        Cadastrar bicicleta
                    </button>

                    <a href="${pageContext.request.contextPath}/menu-principal.jsp"
                       class="btn btn-outline-light">
                        Voltar ao início
                    </a>

                </div>

            </form>

        </section>

    </main>

    <c:import url="/WEB-INF/components/rodape.jsp" />

    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>