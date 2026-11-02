<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Alterar valor — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <section class="formulario-card"
                 aria-labelledby="titulo-alteracao">

            <h1 id="titulo-alteracao" class="h3 mb-2">
                Alterar valor do serviço
            </h1>

            <p class="formulario-descricao mb-4">
                Atualize o valor do serviço no catálogo.
            </p>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <p class="mb-4 text-break">
                Serviço:
                <strong>
                    <c:out value="${servico.nome}" />
                </strong>
            </p>

            <form action="${pageContext.request.contextPath}/mvc"
                  method="post">

                <input type="hidden"
                       name="logica"
                       value="AlterarValorServicoLogica">

                <input type="hidden"
                       name="id"
                       value="<c:out value='${servico.id}' />">

                <div class="row">
                    <div class="col-12 col-sm-6">
                        <label for="valor" class="form-label">
                            Novo valor (R$)
                        </label>

                        <input type="text"
                               class="form-control"
                               id="valor"
                               name="valor"
                               inputmode="decimal"
                               required
                               placeholder="Ex.: 150,50"
                               aria-describedby="orientacaoValor"
                               value="<c:out value='${param.valor != null ? param.valor : servico.valor}' />">
                    </div>
                </div>

                <div id="orientacaoValor" class="form-text mt-2">
                    Use vírgula ou ponto para os centavos,
                    sem separador de milhar. Ex.: 1500,50.
                </div>

                <div class="d-flex flex-column flex-sm-row
                            align-items-start gap-2 mt-4">

                    <button type="submit" class="btn btn-destaque">
                        Salvar alteração
                    </button>

                    <a href="${pageContext.request.contextPath}/mvc?logica=ListarServicosLogica"
                       class="btn btn-outline-light">
                        Voltar à listagem
                    </a>

                </div>

            </form>

        </section>

    </main>

    <c:import url="/WEB-INF/components/rodape.jsp" />

    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>