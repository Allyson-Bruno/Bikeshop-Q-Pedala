<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Cadastro de serviço — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <section class="formulario-card"
                 aria-labelledby="titulo-cadastro">

            <h1 id="titulo-cadastro" class="h3 mb-2">
                Cadastro de serviço
            </h1>

            <p class="formulario-descricao mb-4">
                Informe o nome e o valor do serviço.
                Todos os campos são obrigatórios.
            </p>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <c:if test="${param.sucesso == 'true'}">
                <div class="alert alert-success" role="status">
                    Serviço cadastrado com sucesso.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/mvc"
                  method="post">

                <div class="mb-3">
                    <label for="nome" class="form-label">
                        Nome do serviço
                    </label>

                    <input type="text"
                           class="form-control"
                           id="nome"
                           name="nome"
                           required
                           maxlength="120"
                           placeholder="Ex.: Revisão completa"
                           value="<c:out value='${param.nome}' />">
                </div>

                <div class="row">
                    <div class="col-12 col-sm-6">
                        <label for="valor" class="form-label">
                            Valor (R$)
                        </label>

                        <input type="text"
                               class="form-control"
                               id="valor"
                               name="valor"
                               inputmode="decimal"
                               required
                               placeholder="Ex.: 150,50"
                               aria-describedby="orientacaoValor"
                               value="<c:out value='${param.valor}' />">
                    </div>
                </div>

                <div id="orientacaoValor" class="form-text mt-2">
                    Use vírgula ou ponto para os centavos,
                    sem separador de milhar. Ex.: 1500,50.
                </div>

                <input type="hidden"
                       name="logica"
                       value="CadastroServicoLogica">

                <div class="d-flex flex-column flex-sm-row
                            align-items-start gap-2 mt-4">

                    <button type="submit" class="btn btn-destaque">
                        Cadastrar serviço
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