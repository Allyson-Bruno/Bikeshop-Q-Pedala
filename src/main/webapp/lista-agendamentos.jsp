<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BikeShop Q-Pedala — Agendamentos pendentes</title>
</head>
<body>

    <h1>Agendamentos pendentes</h1>

    <c:if test="${not empty erro}">
        <p><c:out value="${erro}" /></p>
    </c:if>
    
    <c:if test="${param.cancelado == 'true'}">
    	<p>Agendamento cancelado com sucesso.</p>
	</c:if>

	<c:if test="${param.cancelado == 'false'}">
    	<p>
        Não foi possível cancelar: a OS não existe ou já não está agendada.
    	</p>
	</c:if>

    <form action="${pageContext.request.contextPath}/mvc" method="get">

        <input type="hidden" name="logica"
               value="ListarAgendamentosLogica">

        <label for="data">Data:</label>
        <input type="date" id="data" name="data" required
               value="<c:out value='${dataFiltro}' />">

        <label for="modo">Consultar:</label>
        <select id="modo" name="modo">
            <option value="apartir"
                ${modoFiltro == 'apartir' ? 'selected' : ''}>
                A partir da data
            </option>

            <option value="exata"
                ${modoFiltro == 'exata' ? 'selected' : ''}>
                Somente na data
            </option>
        </select>

        <button type="submit">Consultar</button>
    </form>

    <c:if test="${empty erro}">
        <table border="1">
            <thead>
                <tr>
                    <th>OS</th>
                    <th>Data do agendamento</th>
                    <th>Cliente</th>
                    <th>Bicicleta</th>
                    <th>Serviços previstos</th>
                    <th>Ações</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="ordem" items="${agendamentos}">
                    <tr>
                        <td><c:out value="${ordem.id}" /></td>

                        <td>
                            <c:out value="${ordem.dataAgendamento}" />
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
                            <ul>
                                <c:forEach var="item" items="${ordem.itens}">
                                    <li>
                                        <c:out value="${item.servico.nome}" />
                                    </li>
                                </c:forEach>
                            </ul>
                        </td>
                        
                     	<td>
                    
    						<form action="${pageContext.request.contextPath}/mvc" method="post">

        						<input type="hidden" name="logica" 
        							value="CancelarAgendamentoLogica">

        						<input type="hidden" name="id" 
        							value="${ordem.id}">

        						<input type="hidden" name="data" 
        							value="<c:out value='${dataFiltro}' />">

        						<input type="hidden" name="modo" 
        							value="<c:out value='${modoFiltro}' />">

        						<button type="submit">Cancelar OS</button>
    				
    						</form>
						</td>
                        
                    </tr>

                </c:forEach>

                <c:if test="${empty agendamentos}">
                    <tr>
                        <td colspan="6">
                            Nenhum agendamento pendente encontrado para o filtro informado.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </c:if>

    <p>
        <a href="${pageContext.request.contextPath}/menu-principal.jsp">
            Voltar ao menu
        </a>
    </p>

</body>
</html>