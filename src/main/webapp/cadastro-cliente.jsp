<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Cadastro de cliente — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <section class="formulario-card"
                 aria-labelledby="titulo-cadastro">

            <h1 id="titulo-cadastro" class="h3 mb-2">
                Cadastro de cliente
            </h1>

            <p class="formulario-descricao mb-4">
                Preencha os dados abaixo. Todos os campos são obrigatórios.
            </p>

            <c:if test="${not empty erro}">
                <div class="alert alert-danger" role="alert">
                    <c:out value="${erro}" />
                </div>
            </c:if>

            <c:if test="${param.sucesso == 'true'}">
                <div class="alert alert-success" role="status">
                    Cliente cadastrado com sucesso.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/mvc"
                  method="post">

                <div class="row g-3">

                    <div class="col-12">
                        <label for="nome" class="form-label">
                            Nome
                        </label>

                        <input type="text"
                               class="form-control"
                               id="nome"
                               name="nome"
                               maxlength="120"
                               autocomplete="name"
                               placeholder="Digite o nome completo"
                               required
                               value="<c:out value='${param.nome}' />">
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="cpf" class="form-label">
                            CPF
                        </label>

                        <input type="text"
                               class="form-control"
                               id="cpf"
                               name="cpf"
                               maxlength="11"
                               pattern="[0-9]{11}"
                               inputmode="numeric"
                               placeholder="Somente os 11 números"
                               required
                               value="<c:out value='${param.cpf}' />">
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="datanasci" class="form-label">
                            Data de nascimento
                        </label>

                        <input type="date"
                               class="form-control"
                               id="datanasci"
                               name="datanasci"
                               autocomplete="bday"
                               required
                               value="<c:out value='${param.datanasci}' />">
                    </div>

                    <div class="col-12 col-md-7">
                        <label for="email" class="form-label">
                            E-mail
                        </label>

                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               maxlength="254"
                               autocomplete="email"
                               placeholder="nome@exemplo.com"
                               required
                               value="<c:out value='${param.email}' />">
                    </div>

                    <div class="col-12 col-md-5">
                        <label for="telefone" class="form-label">
                            Telefone
                        </label>

                        <input type="tel"
                               class="form-control"
                               id="telefone"
                               name="telefone"
                               maxlength="20"
                               autocomplete="tel"
                               placeholder="(32) 99999-9999"
                               required
                               value="<c:out value='${param.telefone}' />">
                    </div>

                </div>

                <input type="hidden"
                       name="logica"
                       value="CadastroClienteLogica">

                <div class="d-flex flex-column flex-sm-row gap-2 mt-4">
                    <button type="submit" class="btn btn-destaque">
                        Cadastrar cliente
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