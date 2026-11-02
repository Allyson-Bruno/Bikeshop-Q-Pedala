<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Clientes — BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container py-4 py-md-5">

        <section class="listagem-card"
                 aria-labelledby="titulo-clientes">

            <div class="d-flex flex-column flex-sm-row
                        justify-content-between align-items-start gap-3 mb-4">

                <div>
                    <h1 id="titulo-clientes" class="h3 mb-2">
                        Clientes cadastrados
                    </h1>

                    <p class="listagem-descricao mb-0">
                        Consulte os dados dos clientes da loja.
                    </p>
                </div>

                <a href="${pageContext.request.contextPath}/cadastro-cliente.jsp"
                   class="btn btn-destaque flex-shrink-0">
                    Cadastrar cliente
                </a>

            </div>

            <div class="table-responsive tabela-container"
                 role="region"
                 aria-label="Tabela de clientes"
                 tabindex="0">

                <table class="table tabela-sistema tabela-clientes table-hover align-middle mb-0">

                    <caption class="visually-hidden">
                        Clientes cadastrados: nome, CPF, data de nascimento,
                        e-mail e telefone.
                    </caption>

                    <thead>
                        <tr>
                            <th scope="col">Nome</th>
                            <th scope="col">CPF</th>
                            <th scope="col" class="text-nowrap">
                                Data de nascimento
                            </th>
                            <th scope="col">E-mail</th>
                            <th scope="col">Telefone</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="cliente" items="${clientes}">
                            <tr>
                                <td>
                                    <c:out value="${cliente.nome}" />
                                </td>

                                <td class="text-nowrap">
                                    <c:out value="${cliente.cpf}" />
                                </td>

                                <td class="text-nowrap">
                                    <c:out value="${cliente.dataNascimento}" />
                                </td>

                                <td class="tabela-email">
                                    <c:out value="${cliente.email}" />
                                </td>

                                <td class="text-nowrap">
                                    <c:out value="${cliente.telefone}" />
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty clientes}">
                            <tr>
                                <td colspan="5" class="text-center py-4">
                                    Nenhum cliente cadastrado.
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