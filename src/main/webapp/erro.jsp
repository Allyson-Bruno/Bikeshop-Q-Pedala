<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Erro — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <section class="formulario-card"
                 aria-labelledby="titulo-erro">

            <c:set var="codigo"
                   value="${requestScope['jakarta.servlet.error.status_code']}" />

            <h1 id="titulo-erro" class="h3 mb-3">
                Não foi possível concluir
            </h1>

            <c:if test="${not empty codigo}">
                <p class="formulario-descricao">
                    Código do erro: <c:out value="${codigo}" />
                </p>
            </c:if>

            <div class="alert alert-warning" role="alert">
                <c:choose>
                    <c:when test="${codigo eq 400}">
                        Os dados enviados são inválidos ou estão incompletos.
                        Retorne à página da operação e confira as informações.
                    </c:when>

                    <c:when test="${codigo eq 404}">
                        A página ou o registro solicitado não foi encontrado.
                    </c:when>

                    <c:when test="${codigo eq 405}">
                        Esta operação não permite essa forma de acesso.
                        Utilize os botões e formulários do sistema.
                    </c:when>

                    <c:when test="${codigo eq 409}">
                        O registro não está mais disponível para essa operação.
                        Consulte novamente a listagem para verificar sua situação.
                    </c:when>

                    <c:otherwise>
                        Ocorreu uma falha inesperada.
                        Se estava salvando uma operação, confira a listagem
                        antes de tentar novamente.
                        Caso o problema continue, entre em contato com
                        o responsável pelo sistema.
                    </c:otherwise>
                </c:choose>
            </div>

            <c:choose>
                <c:when test="${sessionScope.usuarioLogado eq true}">
                    <a href="${pageContext.request.contextPath}/menu-principal.jsp"
                       class="btn btn-destaque">
                        Voltar ao início
                    </a>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login-admin.jsp"
                       class="btn btn-destaque">
                        Ir para o login
                    </a>
                </c:otherwise>
            </c:choose>

        </section>

    </main>

    <c:import url="/WEB-INF/components/rodape.jsp" />
    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>