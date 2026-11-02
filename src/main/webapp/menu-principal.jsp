<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ include file="autenticacao.jsp" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Menu BikeShop Q-Pedala</title>

    <c:import url="/WEB-INF/components/estilos.jsp" />
</head>
<body>

    <c:import url="/WEB-INF/components/cabecalho.jsp" />

    <main class="container inicio-main">

    <section class="inicio-apresentacao"
             aria-labelledby="titulo-inicio">

        <div class="inicio-visual">
            <div class="inicio-painel">
                <img
                    src="${pageContext.request.contextPath}/resources/img/ciclista.png"
                    class="inicio-ciclista"
                    alt="Ciclista realizando uma manobra de BMX">
            </div>
        </div>

        <div class="inicio-texto">
            <h1 id="titulo-inicio">
                Bem-vindo ao sistema
                <span>BikeShop Q-Pedala</span>
            </h1>

            <p>
                Gerencie clientes, bicicletas e serviços
                em um só lugar.
            </p>

            <p class="inicio-orientacao">
                Utilize o menu acima para acessar as funcionalidades.
            </p>
        </div>

    </section>

</main>
    
    
	<c:import url="/WEB-INF/components/rodape.jsp" />

    <c:import url="/WEB-INF/components/scripts.jsp" />

</body>
</html>