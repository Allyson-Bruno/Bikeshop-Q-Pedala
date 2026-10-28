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
<title>BikeShop Q-Pedala — Pagamentos pendentes</title>
</head>
<body>

    <h1>Ordens de serviço pendentes de pagamento</h1>

    <fmt:setLocale value="pt_BR" />
    
    <c:if test="${param.pago == 'true'}">
    	<p>Pagamento registrado com sucesso.</p>
	</c:if>

    <table border="1">
        <thead>
            <tr>
                <th>OS</th>
                <th>Data da execução</th>
                <th>Cliente</th>
                <th>Bicicleta</th>
                <th>Total dos serviços</th>
				<th>Ações</th>
            </tr>
            
        </thead>

        <tbody>
            <c:forEach var="ordem" items="${ordens}">
                <tr>
                    <td>
                        <c:out value="${ordem.id}" />
                    </td>

                    <td>
                        <c:out value="${ordem.dataExecucao}" />
                    </td>

                    <td>
                        <c:out value="${ordem.cliente.nome}" /><br>
                        CPF: <c:out value="${ordem.cliente.cpf}" />
                    </td>

                    <td>
                        <c:out value="${ordem.bicicleta.marca}" />
                        — <c:out value="${ordem.bicicleta.modelo}" /><br>
                        Série:
                        <c:out value="${ordem.bicicleta.numeroSerie}" />
                    </td>

                    <td>
                        <fmt:formatNumber
                            value="${ordem.valorTotal}"
                            type="currency"
                            currencySymbol="R$" />
                    </td>
                    
                    <td>
    					<a href="${pageContext.request.contextPath}/mvc?logica=FormularioPagamentoLogica&amp;id=${ordem.id}">
        					Realizar pagamento
    					</a>
					</td>
                </tr>
            </c:forEach>

            <c:if test="${empty ordens}">
                <tr>
                    <td colspan="6">
                        Nenhuma ordem de serviço pendente de pagamento.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>