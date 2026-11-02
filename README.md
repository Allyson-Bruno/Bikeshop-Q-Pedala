# BikeShop Q-Pedala 

Sistema web para gerenciamento dos serviços de uma oficina de bicicletas, desenvolvido como trabalho da disciplina de **Programação Web**, no **4º período do curso Técnico em Informática do IF Sudeste MG — Campus Barbacena**.

A aplicação permite cadastrar clientes, bicicletas e serviços, acompanhar ordens de serviço desde o agendamento até o pagamento e consultar históricos e relatórios.

## Funcionalidades

### Acesso ao sistema
- Login de administrador com verificação de senha utilizando BCrypt.
- Proteção das páginas e operações por autenticação.
- Encerramento da sessão após dois minutos de inatividade.
- Logout.

### Cadastros
- Cadastro e listagem de clientes.
- Cadastro e listagem de bicicletas, com proprietário opcional.
- Cadastro e listagem dos serviços oferecidos pela oficina.
- Alteração do valor dos serviços.

### Ordens de serviço
- Agendamento com seleção do cliente, de uma de suas bicicletas e de um ou mais serviços.
- Consulta de agendamentos a partir de uma data ou em uma data específica.
- Cancelamento de ordens agendadas, com confirmação.
- Registro dos serviços efetivamente realizados e da data de execução.
- Armazenamento do valor aplicado a cada serviço no momento da execução.
- Consulta das ordens pendentes de pagamento.
- Registro do pagamento, com desconto opcional de 10% para ordens com três ou mais serviços realizados.

### Históricos e relatórios
- Histórico de serviços por cliente e por bicicleta.
- Visualização dos detalhes de cada ordem.
- Preservação do cliente registrado na OS, mesmo que a bicicleta mude de proprietário.
- Relatório de serviços por período de execução.
- Apresentação dos valores, descontos e total do período.
- Exportação do relatório em PDF.

## Tecnologias utilizadas

| Tecnologia | Utilização |
|---|---|
| Java 25 | Linguagem utilizada no desenvolvimento do backend |
| Maven | Gerenciamento de dependências, testes e empacotamento |
| Apache Tomcat 11 | Execução da aplicação web |
| Jakarta Servlets | Recebimento e tratamento das requisições |
| JSP e Jakarta Tags (JSTL) | Construção das páginas dinâmicas |
| PostgreSQL | Armazenamento dos dados |
| JDBC | Acesso ao banco de dados |
| Bootstrap 5 e CSS | Estilização e responsividade |
| BCrypt — jBCrypt | Geração e verificação dos hashes de senha |
| JUnit Jupiter | Testes automatizados das validações e dos cálculos |
| Apache PDFBox | Geração dos relatórios em PDF |

O projeto foi desenvolvido utilizando o **Eclipse IDE**.

## Organização do projeto

A aplicação utiliza o padrão MVC, com uma única Servlet Controladora.

A `ControllerServlet` recebe as requisições pelo caminho `/mvc`, verifica a autenticação e identifica a operação pelo parâmetro `logica`. Em seguida, encaminha sua execução para a classe responsável.

As classes de lógica validam os dados recebidos, utilizam os DAOs para acessar o banco e encaminham os resultados às páginas JSP.

| Pacote | Responsabilidade |
|---|---|
| `bikeshop.servlet` | Servlet Controladora |
| `bikeshop.logica` | Tratamento das operações e encaminhamento das requisições |
| `bikeshop.modelo` | Classes que representam os dados da aplicação |
| `bikeshop.dao` | Consultas e operações no banco de dados |
| `bikeshop.jdbc` | Configuração e abertura das conexões |
| `bikeshop.validacao` | Validações e cálculos das regras de negócio |
| `bikeshop.excecao` | Exceções específicas da aplicação |
| `bikeshop.hash` | Geração e verificação dos hashes de senha |
| `bikeshop.relatorio` | Geração do relatório em PDF |

### Arquivos e recursos

| Local | Conteúdo |
|---|---|
| `src/main/java` | Código-fonte Java |
| `src/main/webapp` | Páginas JSP e recursos da interface |
| `src/main/webapp/WEB-INF/components` | Componentes compartilhados de cabeçalho, rodapé, estilos e scripts |
| `src/main/webapp/resources` | CSS, imagens e arquivos do Bootstrap |
| `src/main/resources/fontes` | Fontes utilizadas na geração dos PDFs |
| `src/test/java` | Testes e utilitários de verificação |
| `Script Sql` | Scripts de estrutura e dados de exemplo |
| `docs/modelagem` | Diagrama de modelagem da aplicação |

A modelagem está disponível em:
[Diagrama de classes](docs/modelagem/bikeshop-modelagem.drawio).

O arquivo pode ser aberto no diagrams.net.

## Regras de negócio

### Clientes e bicicletas

- Um cliente pode possuir várias bicicletas.
- Uma bicicleta pode estar vinculada a, no máximo, um proprietário.
- O cadastro de uma bicicleta permite deixar o proprietário em branco.
- Para agendar um serviço, é necessário selecionar um cliente e uma bicicleta vinculada a ele.

### Ordens de serviço

- Uma OS deve conter pelo menos um serviço.
- Uma bicicleta não pode possuir duas OS com status `AGENDADA` para a mesma data.
- Somente ordens agendadas podem ser canceladas ou ter sua execução registrada.
- O cancelamento altera o status da OS, preservando seu registro no banco.
- Ao registrar a execução, devem ser selecionados os serviços efetivamente realizados.
- O total da OS considera apenas os serviços selecionados como realizados.

| Status | Significado |
|---|---|
| `AGENDADA` | Aguarda o registro da execução |
| `EXECUTADA` | Possui serviços realizados e aguarda pagamento |
| `PAGA` | Pagamento registrado |
| `CANCELADA` | Agendamento cancelado |

### Valores e pagamento

- Cada item executado armazena o valor aplicado ao serviço naquela ocasião.
- Alterações posteriores no preço do catálogo não modificam os valores registrados nas execuções anteriores.
- O sistema oferece desconto de 10% quando três ou mais serviços foram efetivamente realizados na OS.
- O desconto somente é aplicado mediante confirmação do administrador.
- Sem essa confirmação, o pagamento é registrado pelo valor integral.
- Somente ordens com status `EXECUTADA` podem ter o pagamento registrado.
- Os valores e o direito ao desconto são conferidos no servidor.

### Históricos e relatórios

- Os históricos apresentam ordens executadas e pagas.
- O cliente apresentado no histórico é aquele registrado na OS, mesmo que a bicicleta posteriormente mude de proprietário.
- O relatório utiliza a data de execução e inclui as duas datas informadas no filtro.
- O total do relatório considera ordens executadas e pagas, descontando os descontos já registrados.
- Esse total não representa apenas pagamentos recebidos.
- Ordens ainda pendentes de pagamento podem receber desconto posteriormente, alterando os valores de uma nova consulta ao relatório.

## Pré-requisitos

- JDK 25, conforme configurado no `pom.xml`.
- Apache Tomcat 11.
- PostgreSQL e cliente de linha de comando `psql`.
- Eclipse IDE com suporte a projetos Java Web e Maven.
- Git.
- Maven, caso deseje executar testes e gerar o WAR pelo terminal.

O arquivo `bikeshop-completo.sql` foi exportado utilizando PostgreSQL 18.4. Para reproduzir o ambiente, utilize essa versão do servidor e do cliente `psql`.

## Configuração e execução

### 1. Clonar o repositório

No terminal, execute:

```bash
git clone https://github.com/Allyson-Bruno/Bikeshop-Q-Pedala.git
```

Entre na pasta criada:

```bash
cd Bikeshop-Q-Pedala
```

### 2. Importar o projeto no Eclipse

1. Acesse **File → Import → Maven → Existing Maven Projects**.
2. Selecione a pasta do repositório, que contém o `pom.xml`.
3. Conclua a importação.
4. Clique com o botão direito no projeto e selecione **Maven → Update Project**.
5. Aguarde o download das dependências.

Em **Window → Preferences → Java → Installed JREs**, adicione e selecione o JDK 25.

Confira também se o projeto está utilizando esse JDK em **Properties → Java Build Path**.

### 3. Criar o banco de dados

Com o PostgreSQL em execução, crie um banco vazio chamado `bikeshop`.

Pelo terminal:

```bash
psql -U postgres -c "CREATE DATABASE bikeshop;"
```

O comando solicitará a senha do usuário do PostgreSQL. Se utilizar outro usuário, substitua `postgres` pelo nome correspondente.

### 4. Importar a estrutura e os dados de exemplo

Na pasta raiz do repositório, execute:

```bash
psql -U postgres -d bikeshop -v ON_ERROR_STOP=1 -f "Script Sql/bikeshop-completo.sql"
```

O arquivo completo já cria as tabelas, os relacionamentos, os índices e os dados de exemplo. Não execute o `bikeshop.sql` antes dele no mesmo banco.

O dump contém comandos próprios do `psql`, como `\restrict`. Por isso, utilize o terminal com o cliente `psql`, em vez de colar todo o conteúdo no Query Tool do pgAdmin.

Os dados de exemplo incluem:

- 3 clientes;
- 4 bicicletas;
- 10 serviços;
- 11 ordens de serviço, distribuídas entre agendadas, executadas, pagas e canceladas.

O arquivo também contém um administrador com senha armazenada como hash. A criação de um administrador próprio será explicada na seção de acesso ao sistema.

> As datas dos exemplos são fixas. A listagem de agendamentos utiliza a data atual como filtro inicial. Para visualizar agendamentos antigos, informe uma data anterior no filtro. Para consultar os serviços executados dos exemplos, utilize um período que inclua outubro de 2026.

### 5. Configurar o Tomcat no Eclipse

1. Abra a aba **Servers**.
2. Selecione **New → Server → Apache → Tomcat v11.0 Server**.
3. Informe a pasta de instalação do Tomcat.
4. Selecione o JDK 25 para executar o servidor.
5. Adicione o projeto ao servidor.

### 6. Configurar a conexão com o banco

A classe `ConnectionFactory` lê as configurações por variáveis de ambiente:

| Variável | Exemplo |
|---|---|
| `BIKESHOP_DB_URL` | `jdbc:postgresql://localhost:5432/bikeshop` |
| `BIKESHOP_DB_USER` | `postgres` |
| `BIKESHOP_DB_PASSWORD` | Senha do usuário do PostgreSQL |

Essas credenciais pertencem ao banco de dados e são diferentes do usuário e da senha utilizados no login da aplicação.

Para configurar no Eclipse:

1. Dê dois cliques no servidor na aba **Servers**.
2. Abra **Open launch configuration**.
3. Na aba **Environment**, adicione as três variáveis.
4. Salve as alterações.
5. Reinicie o Tomcat caso já esteja em execução.

As variáveis precisam estar disponíveis para o processo do Tomcat. Configurá-las apenas em um terminal separado não altera o ambiente de um servidor já iniciado pelo Eclipse.

### 7. Iniciar a aplicação

Inicie o Tomcat pela aba **Servers** e acesse:

```text
http://localhost:8080/BikeShopQPedala/
```

Esse endereço considera a porta padrão `8080` e o contexto `BikeShopQPedala`. Caso a configuração do servidor seja diferente, ajuste o endereço.

A página inicial apresenta o formulário de login. Antes de entrar, siga a próxima seção para criar seu próprio administrador.

## Criação do administrador

O sistema não possui uma tela de cadastro de administradores. O cadastro é realizado diretamente no banco, utilizando uma senha protegida por hash BCrypt.

### 1. Gerar o hash da senha

No Eclipse, abra:

```text
src/main/java/bikeshop/hash/GerarHash.java
```

No construtor da classe, localize:

```java
String senha = "";
```

Preencha temporariamente com a senha escolhida:

```java
String senha = "SUBSTITUA_PELA_SUA_SENHA";
```

Salve o arquivo e execute a classe por **Run As → Java Application**.

O console exibirá o hash gerado pelo BCrypt. Copie o resultado completo, preservando todos os caracteres.

Após copiar, remova a senha do código, deixando novamente:

```java
String senha = "";
```

Salve o arquivo. Não faça commit da sua senha no repositório.

> O BCrypt utiliza um salt aleatório. Por isso, executar a classe duas vezes com a mesma senha produz hashes diferentes, mas ambos permitem verificar a senha original.

### 2. Cadastrar o administrador no banco

No Query Tool do pgAdmin, conectado ao banco `bikeshop`, ou em uma sessão do `psql`, execute:

```sql
INSERT INTO public.administrador (usuario, senha)
VALUES ('meu_admin', 'COLE_AQUI_O_HASH_COMPLETO');
```

Substitua:

- `meu_admin` pelo nome de usuário desejado;
- `COLE_AQUI_O_HASH_COMPLETO` pelo hash gerado na etapa anterior.

Não informe o ID: ele é gerado automaticamente pelo banco. O nome de usuário deve ser único.

### 3. Acessar o sistema

Abra a aplicação e informe:

- **Usuário:** o nome cadastrado no banco.
- **Senha:** a senha original escolhida antes de gerar o hash.

Não utilize o hash como senha na tela de login.

### Administrador incluído nos dados de exemplo

O SQL completo também importa um administrador de exemplo. Criar uma nova conta não remove nem desativa essa conta existente.

Se desejar removê-la da sua instalação, primeiro confirme que consegue entrar com o administrador recém-criado. Em seguida, consulte os usuários:

```sql
SELECT id, usuario
FROM public.administrador
ORDER BY id;
```

Após identificar a conta de exemplo, exclua somente o registro correspondente:

```sql
DELETE FROM public.administrador
WHERE id = ID_DO_ADMINISTRADOR_DE_EXEMPLO;
```

Substitua `ID_DO_ADMINISTRADOR_DE_EXEMPLO` pelo ID numérico identificado na consulta. Preserve a conta que acabou de criar.

### Sessão e logout

Após dois minutos sem requisições à aplicação, a sessão expira. Na próxima tentativa de acessar uma funcionalidade protegida, será necessário fazer login novamente.

Movimentar o mouse ou digitar em um formulário, sem enviar uma requisição, não renova a sessão.

Para encerrar o acesso manualmente, utilize a opção **Sair** na barra de navegação.

## Testes

Os testes automatizados estão em `src/test/java/bikeshop/validacao` e verificam regras de validação e cálculos utilizados pela aplicação.

Entre os cenários estão:

- Validação dos dados de clientes, bicicletas e serviços.
- Validação das datas e da seleção de serviços no agendamento.
- Validação dos itens e valores informados na execução.
- Cálculo do total dos serviços realizados.
- Condições para aplicação do desconto no pagamento.
- Validação do período e cálculo do total do relatório.

### Executar pelo Eclipse

1. Clique com o botão direito no pacote `bikeshop.validacao`, dentro de `src/test/java`.
2. Selecione **Run As → JUnit Test**.
3. Confira os resultados na aba **JUnit**.

### Executar pelo Maven

Na pasta que contém o `pom.xml`, execute:

```bash
mvn test
```

O Maven deve estar configurado para utilizar o JDK 25. Confira o ambiente com:

```bash
mvn -version
```

Após a execução, os relatórios dos testes ficam em:

```text
target/surefire-reports/
```

Os testes de validação não substituem a verificação dos fluxos completos com Tomcat e PostgreSQL em execução.

### Verificação manual

Para conferir o funcionamento integrado, utilize este roteiro:

- Acessar uma página protegida sem login e verificar o encaminhamento ao login.
- Fazer login, aguardar mais de dois minutos sem requisições e tentar acessar uma funcionalidade.
- Cadastrar cliente, bicicleta e serviço com dados válidos e inválidos.
- Tentar agendar duas OS para a mesma bicicleta e data.
- Cancelar uma OS agendada.
- Registrar apenas parte dos serviços previstos e conferir o total.
- Alterar o preço de um serviço no catálogo e verificar se o valor de uma execução anterior foi preservado.
- Registrar pagamentos com e sem desconto.
- Consultar os históricos por cliente e por bicicleta.
- Gerar um relatório com resultados e outro para um período vazio.
- Exportar o relatório em PDF e conferir os valores.
- Verificar a navegação e as tabelas em telas pequenas.

## Personalização dos dados de exemplo

Os dados importados pelo SQL podem ser adaptados em uma instalação de testes.

Antes de alterar um cliente, consulte seu ID:

```sql
SELECT id, nome
FROM public.cliente
ORDER BY id;
```

Para substituir os dados de um cliente de exemplo, utilize `UPDATE`, preservando o ID:

```sql
UPDATE public.cliente
SET nome = 'Cliente Demonstração',
    email = 'cliente.demo@example.com',
    telefone = '(32) 00000-0000',
    data_nascimento = DATE '1990-01-15'
WHERE id = ID_DO_CLIENTE;
```

Substitua `ID_DO_CLIENTE` pelo ID numérico identificado na consulta.

O exemplo mantém o CPF atual. Caso também queira alterá-lo, utilize um CPF destinado a testes que passe pela validação da aplicação e não esteja cadastrado para outro cliente.

### Preservação dos relacionamentos

Não altere o ID do cliente para trocar seus dados de demonstração. Bicicletas e ordens de serviço utilizam esse identificador nos relacionamentos.

A alteração do nome ou CPF do cliente será refletida nas consultas das OS vinculadas a ele. Por isso, essa substituição é apropriada para preparar dados de demonstração, não para representar uma transferência de bicicleta entre pessoas.

Para representar outro cliente real, crie um novo cadastro. Preservar o cliente registrado na OS significa manter seu vínculo com aquela pessoa, independentemente do proprietário atual da bicicleta.

### Cuidados com alterações diretas no banco

Comandos SQL executados manualmente não passam pelas validações Java da aplicação. Confira os dados antes de executar as alterações.

Se modificar os exemplos para a entrega acadêmica, mantenha pelo menos:

- 3 clientes;
- 4 bicicletas;
- 5 serviços;
- 8 ordens de serviço, contemplando os status agendada, executada, paga e cancelada.

