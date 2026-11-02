<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container login-main py-5">

        <section class="login-card" aria-labelledby="titulo-login">

            <h1 id="titulo-login" class="h3 mb-2">
                Acesso do administrador
            </h1>

            <p class="login-descricao mb-4">
                Informe seu usuário e sua senha para entrar.
            </p>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/mvc"
                  method="post">

                <div class="mb-3">
                    <label for="usuario" class="form-label">
                        Usuário
                    </label>

                    <input type="text"
                           class="form-control"
                           id="usuario"
                           name="usuario"
                           autocomplete="username"
                           required
                           value="<c:out value='${param.usuario}' />"
                           placeholder="Digite aqui...">
                </div>

                <div class="mb-4">
                    <label for="senha" class="form-label">
                        Senha
                    </label>

                    <input type="password"
                           class="form-control"
                           id="senha"
                           name="senha"
                           autocomplete="current-password"
                           required
                           placeholder="Digite aqui...">
                </div>

                <input type="hidden" name="logica" value="LoginLogica">

                <button type="submit" class="btn btn-destaque w-100">
                    Entrar
                </button>

            </form>

        </section>

    </main>

    <c:import url="/WEB-INF/components/rodape.jsp" />

    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>