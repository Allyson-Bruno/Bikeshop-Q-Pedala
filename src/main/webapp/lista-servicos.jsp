<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Serviços</title>
</head>
<body>

    <h1>Serviços oferecidos</h1>

    <fmt:setLocale value="pt_BR" />
    
    <c:if test="${param.alterado == 'true'}">
    	<p>Valor do serviço alterado com sucesso.</p>
	</c:if>

    <table border="1">
        <thead>
            <tr>
                <th>Nome</th>
                <th>Valor</th>
                <th>Ações</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach var="servico" items="${servicos}">
                <tr>
                    <td><c:out value="${servico.nome}" /></td>

                    <td>
                        <fmt:formatNumber value="${servico.valor}" type="currency" currencyCode="BRL" />
                    </td>
                    
                    <td>
    					<a href="${pageContext.request.contextPath}/mvc?logica=FormularioAlterarValorServicoLogica&amp;id=${servico.id}">
    						Alterar valor
						</a>
					</td>
                </tr>
            </c:forEach>

            <c:if test="${empty servicos}">
                <tr>
                    <td colspan="3">Nenhum serviço cadastrado.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <p>
        <a href="${pageContext.request.contextPath}/cadastro-servico.jsp">
            Cadastrar serviço
        </a>
    </p>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>