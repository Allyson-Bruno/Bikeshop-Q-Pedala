<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<header class="site-header">
    <nav class="navbar navbar-expand-xl"
         data-bs-theme="dark"
         aria-label="Navegação principal">

        <div class="container">

            <a class="navbar-brand fw-bold"
               href="${pageContext.request.contextPath}${sessionScope.usuarioLogado == true ? '/menu-principal.jsp' : '/login-admin.jsp'}">
                BikeShop Q-Pedala
            </a>

            <c:if test="${sessionScope.usuarioLogado == true}">

                <button class="navbar-toggler"
                        type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#menuPrincipal"
                        aria-controls="menuPrincipal"
                        aria-expanded="false"
                        aria-label="Abrir ou fechar menu">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="menuPrincipal">

                    <ul class="navbar-nav ms-auto mb-2 mb-xl-0">

                        <li class="nav-item dropdown">
                            <button class="nav-link dropdown-toggle"
                                    type="button"
                                    data-bs-toggle="dropdown"
                                    aria-expanded="false">
                                Cadastros
                            </button>

                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/cadastro-cliente.jsp">
                                        Clientes
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=FormularioBicicletaLogica">
                                        Bicicletas
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/cadastro-servico.jsp">
                                        Serviços
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <li class="nav-item dropdown">
                            <button class="nav-link dropdown-toggle"
                                    type="button"
                                    data-bs-toggle="dropdown"
                                    aria-expanded="false">
                                Listagens
                            </button>

                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=ListarClientesLogica">
                                        Clientes
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=ListarBicicletasLogica">
                                        Bicicletas
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=ListarServicosLogica">
                                        Serviços
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <li class="nav-item dropdown">
                            <button class="nav-link dropdown-toggle"
                                    type="button"
                                    data-bs-toggle="dropdown"
                                    aria-expanded="false">
                                Atendimento
                            </button>

                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=FormularioAgendamentoLogica">
                                        Agendar serviço
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=ListarAgendamentosLogica">
                                        Agendamentos pendentes
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=ListarPendentesPagamentoLogica">
                                        Pagamentos pendentes
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <li class="nav-item dropdown">
                            <button class="nav-link dropdown-toggle"
                                    type="button"
                                    data-bs-toggle="dropdown"
                                    aria-expanded="false">
                                Históricos
                            </button>

                            <ul class="dropdown-menu">
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=HistoricoClienteLogica">
                                        Por cliente
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/mvc?logica=HistoricoBicicletaLogica">
                                        Por bicicleta
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link"
                               href="${pageContext.request.contextPath}/mvc?logica=RelatorioServicosLogica">
                                Relatório
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link"
                               href="${pageContext.request.contextPath}/mvc?logica=LogoutLogica">
                                Sair
                            </a>
                        </li>

                    </ul>
                </div>
            </c:if>

        </div>
    </nav>
</header>