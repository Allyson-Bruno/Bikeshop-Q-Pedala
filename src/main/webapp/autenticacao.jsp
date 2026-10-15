<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:if test="${sessionScope.usuarioLogado != true}">
    <jsp:forward page="/login-admin.jsp" />
</c:if>