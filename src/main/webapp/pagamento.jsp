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
<title>BikeShop Q-Pedala — Pagamento</title>
</head>
<body>

    <h1>Realizar pagamento</h1>

    <fmt:setLocale value="pt_BR" />

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>

    <c:choose>
        <c:when test="${not empty ordem}">

            <p>
                OS: <c:out value="${ordem.id}" />
            </p>

            <p>
                Cliente: <c:out value="${ordem.cliente.nome}" /><br>
                CPF: <c:out value="${ordem.cliente.cpf}" />
            </p>

            <p>
                Bicicleta:
                <c:out value="${ordem.bicicleta.marca}" />
                — <c:out value="${ordem.bicicleta.modelo}" /><br>
                Série:
                <c:out value="${ordem.bicicleta.numeroSerie}" />
            </p>

            <p>
                Data da execução:
                <c:out value="${ordem.dataExecucao}" />
            </p>

            <h2>Serviços realizados</h2>

            <table border="1">
                <thead>
                    <tr>
                        <th>Serviço</th>
                        <th>Valor aplicado</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="item" items="${ordem.itens}">
                        <tr>
                            <td>
                                <c:out value="${item.servico.nome}" />
                            </td>

                            <td>
                                <fmt:formatNumber
                                    value="${item.valor}"
                                    type="currency"
                                    currencySymbol="R$" />
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <p>
                Quantidade de serviços realizados:
                <c:out value="${quantidadeExecutada}" />
            </p>

            <p>
                <strong>Total sem desconto:</strong>
                <fmt:formatNumber
                    value="${ordem.valorTotal}"
                    type="currency"
                    currencySymbol="R$" />
            </p>

            <form action="${pageContext.request.contextPath}/mvc"
                  method="post">

                <input type="hidden"
                       name="logica"
                       value="RegistrarPagamentoLogica">

                <input type="hidden"
                       name="id"
                       value="<c:out value='${ordem.id}' />">

                <c:choose>
                    <c:when test="${permiteDesconto}">

                        <fieldset>
                            <legend>Desconto opcional</legend>

                            <p>
                                Esta OS possui três ou mais serviços
                                realizados e permite desconto de 10%.
                            </p>

                            <p>
                                Desconto:
                                <fmt:formatNumber
                                    value="${descontoPossivel}"
                                    type="currency"
                                    currencySymbol="R$" />
                            </p>

                            <p>
                                Total caso o desconto seja aplicado:
                                <fmt:formatNumber
                                    value="${totalComDesconto}"
                                    type="currency"
                                    currencySymbol="R$" />
                            </p>

                            <input type="checkbox"
                                   id="aplicarDesconto"
                                   name="aplicarDesconto"
                                   value="true"
                                   ${param.aplicarDesconto eq 'true'
                                       ? 'checked' : ''}>

                            <label for="aplicarDesconto">
                                Confirmo a aplicação do desconto de 10%.
                            </label>

                            <p>
                                Sem marcar esta opção, o pagamento será
                                registrado pelo total sem desconto.
                            </p>
                        </fieldset>

                    </c:when>

                    <c:otherwise>
                        <p>
                            O desconto de 10% está disponível somente
                            para OS com três ou mais serviços realizados.
                        </p>
                    </c:otherwise>
                </c:choose>

                <button type="submit">Confirmar pagamento</button>

            </form>

        </c:when>

        <c:otherwise>
            <p>
                Nenhuma OS foi carregada.
                Acesse o pagamento pela listagem de pendências.
            </p>
        </c:otherwise>
    </c:choose>

    <p>
        <a href="${pageContext.request.contextPath}/mvc?logica=ListarPendentesPagamentoLogica">
            Voltar aos pagamentos pendentes
        </a>
    </p>

</body>
</html>