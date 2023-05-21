# Projeto: Comunicação entre Microsserviços

servidor 3: product-api-java
Requisitos: docker já instalando no terminal linux

1. Instalando o banco de dados postgres via docker
2. Criar o docker-compoer no projeto para subir o banco de dados
3. Criação do porjeto Produtc API com java, spring boot e PostgresSQl

comando docker para listar as imagens e os containers:
images:
docker images

container:
docker ps

# Preparação do ambiente de desenvolvimento docker:

## Criando o projeto no github

product-api-java

## Banco de dados: PostgresSql

Criação do banco de dados postgresSql no docker
comunicação com o banco de dados via ide vscode

Subir o ambiente via docker: instancia do docker para produtos

Imagem docker do postgres: https://hub.docker.com/_/postgres

cria a imagem docker: start a postgres instance

mapeamento de porta: como o container é um ambiente isolado o postgress solicita a porta 5432, mas
como queremos a comunicação com o docker, iremos utilizar a porta 5433
minha potrta 5432 já está sendo usada pelo posgres já instalado
--name: product-db-java
-e: variáveis de ambiente
-d: não ver os logs na tela

### Baixar a imagem:

docker pull postgres

### rodar o container da imagem:

docker run --name db-product -p 5433:5432 -e POSTGRES_DB=db-product -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root postgres

listar o container: docker ps
visualizar no vscode: client no banco de dados
conectar postgres
host: localhost
database: db-product
user: root
password: root

criaremos tabela posteriormente.
comandos:
docker ps
docker stop <ID>
remover todos os dokcers parados: docker container prune
docker rm <ID>
docker logs --follow ID

## docker-composer: docker-compose.yml

Dentro do nosso projeto temos como criar os container e renicia-lo via docker composer

criar um arquivo na raiz do projeto: docker-compose.yml

version: "3"
services:

product-db:
image: postgres
container_name: db-product
restart: always
environment: - POSTGRES_DB=db-product - POSTGRES_USER=root - POSTGRES_PASSWORD=root
ports: - 5433:5432

vai criar a network ( nosso projeto não precisa de uma rede específica)

run na raiz do projeto: docker-compose up --build

# Desenvolvimento da aplicação

# Criação do projeto Produtc API com java, spring boot e PostgresSQl

Inicializar a api de produtos: java srping boot

Criando projeto java maven:
criar nosso projeto baseado no Spring Boot a partir do template do spring Initializr.

Maven é uma ferramenta de automação de construção baseada em Modelo de objeto do projeto POM para abreviar . O Maven é usado para construção de projetos, gerenciamento de dependências e documentação. O pom.xmlarquivo de um projeto baseado em maven contém todas as dependências, repositórios etc. necessários para construir e executar esse projeto.

Vamos iniciar o nosso projeto criando o arquivo Spring-Boot.Configure os metadados básicos do seu projeto, quais dependências do Spring nós vamos utilizar (Web no caso) e pronto!

Baixe o código do Spring-Boot configurado Acesse https://start.spring.io/
Maven
Spring Boot estável
group> br.com.aes
Artifact (nome do projeto): simple-db Name: product-api
Packaging (linguagem java): jar versão: 17 (LTS)
Adicionar dependências:
Spring Boot DevTools
Spring Web WEB Build web ( rest rota get...)
Lombok (abstrait getter e setter)
Spring Data JPA SQL (banco de dados)
PostgreSQL Driver SQL (banco de dados na nuven) A JDBC and R2DBC driver that allows
Spring for RabbitMQ
OpenFeign
Generate Project

## arquivo de incialização:

abra a pasta do projeto no vscode para baixar as dependências

vá até o arquivo: src/main/java/br/com/aes/simpledb/SimpleDbApplication.java

Com o projeto criado, vá no vscode e abra a pasta que acabamos de criar. O vscode irá tentar inicializar as extensões, e atualizar as dependências Maven suportar o projeto, então, aguarde até que o processo termine antes de continuar:

atualização no menu inferior do vscode

as dependencias fica no arquivo pow.xml
opicional: pode-se comnetar as dependenciasa seguir, pois não uasremos agora e toda a hora que o projeto iniciar vai configurra o acesso ao banco de dados.
Spring Data JPA SQL (banco de dados)
PostgreSQL Driver SQL

cometar as dependencias que não utilizaremos agora:jpa e postgresql
Caso não comnete dará um erro posi não configuramos ainda o acesso ao banco de dados

<!-- <dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-jpa</artifactId>
		</dependency>-->
<!-- <dependency>
			<groupId>org.postgresql</groupId>
			<artifactId>postgresql</artifactId>
			<scope>runtime</scope>
		</dependency> -->

## Criação de uma controller padrão: Criando um serviço REST

criar a pasta: controllers
cria o arquivo: StatusController.java
src/main/java/br/com/aes/productapi/controllers/StatusController.java

### cria a classe: StatusController.java

Vamos criar uma controller contendo apenas um método Http Get retornando uma simples String com o conteúdo: "Hello world". Então vamos criar uma classe, com o nome de HelloController e adicionar o seguinte conteúdo:

package br.com.aes.productapi.controllers;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
public class StatusController {

@GetMapping(value = "/")
public String getMethodName() {
return "Olá Mundo";
}

}

# rodar o projeto para teste

run
http://localhost:8080

### modificar a classe: StatusController.java

src/main/java/br/com/aes/productapi/controllers/StatusController.java
StatusController.java

@RestController
@RequestMapping("/api/status")
public class StatusController {

@GetMapping("status")
public ResponseEntity<HashMap<String, Object>> getApiStatus(){
var response = new HashMap<String, Object>();

    response.put("service", "Produtct-API");
    response.put("status", "up");
    response.put("httpStatus", HttpStatus.OK.value());

    return ResponseEntity.ok(response)

}
}

# rodar o projeto

run

acessar
http://localhost:8080/api/status

### opicional: configurações para mudar o local host:

Arquivo resources: configuraçoes
trocar application.properties para application.yml

inserir:
server:
port: ${PORT:8081}

spring:
application:
name: Product-api

# opicional: rodar o maven no container - (Dockerfile)

Dockerizing é o processo de compactação, implantação e execução de aplicativos usando contêineres do Docker.

Criação do dockerfile do projeto Product-API
Criando e enviando imagem Docker com Java e Maven
Apache Maven, ou Maven, é uma ferramenta de automação de compilação, gerenciamento, construção e implantação de projetos.

    Um * Dockerfile é um arquivo de configuração de texto/script que contém coleções de comandos que serão executados automaticamente, em sequência, no ambiente Docker para criar uma nova imagem do Docker.

Create a Dockerfile

#

# Build stage

#

FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

#

# Package stage

#

FROM openjdk:11-jre-slim
COPY --from=build /home/app/target/demo-0.0.1-SNAPSHOT.jar /usr/local/lib/demo.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]

O primeiro estágio é usado para construir o código. O segundo estágio contém apenas o jar construído e um JRE para executá-lo (observe como o jar é copiado entre os estágios).

Construa a imagem:
docker build -t demo .

docker logs --follow ID

docker do Maven: https://hub.docker.com/_/maven

sundindo com o docker-compose: arquivo docker-compose.yml
posso subit o postgres e se configurado o product-api/Dockerfile
posso subir tambpem o docker do mavem

# BANCO DE DADOS

# configurando o postgres na aplicação

descomentar as dependencias :

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>

## Realizar a configuração para conexão

Configuraçẽos do banco de dados de teste: application-test.properties
Configurando o MySQL em projetos Spring Boot

Após efetuar o download das dependências, vamos configurar as propriedades do MySQL e do JPA no projeto.

// Criar a conexão com banco de dados MySQL
host: "localhost",
user: "root",
password: "root",
database: "db-product",

<!-- server host: localhost
port 3306
database: database
nome de uusário: root
senha: root -->

# application.properties : banco mysql db-product

Para isso edite o arquivo de configuração application.properties e adicione o seguinte conteúdo:

codigo base:----

spring.jpa.database=POSTGRESQL
spring.datasource.platform=postgres
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=create-drop
spring.database.driverClassName=org.postgresql.Driver
spring.datasource.url=jdbc:postgresql://localhost:5433/db-product
spring.datasource.username=root
spring.datasource.password=root
server.port=8080

----fim do codigo.

# opicional: application.yml : banco postgres

server:
port: ${PORT:8081}

spring:
main:
allow-bean-definition-overriding: true

application:
name: product-api

datasource:
driver-class-name: org.postgresql.Driver # url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5433}/${DB_NAME:db-databases}
url: jdbc:postgresql://localhost:5433/db-databases # username: ${DB_USER:root} # password: ${DB_PASSWORD:root}
username: root
password: root

jpa:
hibernate:
ddl-auto: create-drop
show_sql: true
properties:
hibernate:
dialect: org.hibernate.dialect.PostgreSQL9Dialect

### Configurando o modelo para gerar uma tabela no banco de dados

Vamos criar uma entidade que será convertida em tabela no nosso mysql.
As entidades para representar o relacionamento de tabelas de uma Livaria. Onde teremos a tabela Book

# Mapeamento das tabelas em classes

Aqui vamos aplicar a técnica de Mapeamento objeto-relacional (ORM), que é utilizada para reduzir a impedância da programação orientada aos objetos utilizando bancos de dados relacionais.

## criando uma classe Entity: rota de categoria, produto e fornecedor

product-api/src/main/java/br/com/aes/productapi/modules

atributos: variáveis e os tipos
construtor sem argumento public Entity() { }
construtor com argumento public Entity() { }
métodos getter e setter para encapsulamento
métodos hascode e equals para comparar 2 objetos (comparar se 2 gamers são iguais ou não dentro de uma lista)

# ORM - Mapeamento objeto relacional

Para fazer o mapeamento relacional para que tenhas o registro na tabela é necessários algumas configurações:

1- cria-se os atibutos da classe
2-anotations da classe
@Data: criará os geters e setters tostring hascode
@NoArgsConstructor: contrutor vazio
@AllArgsConstructor: contrutor
@Entity: informa o persistence que isso é uma entidade
@Table(name = "CATEGORY"): cria a tabla com o nome
3- anotations dos atributos:
@Id
@GeneratedValue(strategy = GenerationType.SEQUENCE): método de gerar
@Column(name = "DESCRIPTION", nullable = false): mudar o campo da tabela

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "CATEGORY")
public class Category {

@Id
@GeneratedValue(strategy = GenerationType.SEQUENCE)
private Integer id;
@Column(name = "DESCRIPTION", nullable = false)
private String description;

}

Adicionais:

id_product | name | id_supplier
1|name1|1
1|name1|2
2|name1|3
2|name2|1
2|name2|2
2|name2|3

@ManyToOne: Varios suppliers para cada produto
@JoinColumn(name = "FK_SUPPLIER", nullable = false): chave estartngeira

@ManyToOne
@JoinColumn(name = "FK_SUPPLIER", nullable = false)
private Supplier supplier;

É necessário: nome da tabela, os campos, os tipos, chave primaria

        // anotations
        //Entity: especifica a criação da tabela
        @Entity
        @Table(name = "tb_product")
        public class Entity { ...


    Em cima do nome da classe: anotation @Entity (anotation vai configurar o classe java para que ela seja equivalente a uma tabela do banco de dados)
    Em cima do nome da classe tem como customizar o nome da tabela do banco: @Table(name = "tb_product")
    Em cima do atributo tem como configurar a chave primária e autoincremental:
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    Modificando um nome de uma coluna:
    @Column(name = "game_year") private Integer year;
    Modificandoo tipo de uma coluna: @Column(columnDefinition = "TEXT") private String shortDescription

    todo atributo tem que ter o getter e setter: selecione o atributo e clique na lampada e peça para gersra o get e set

# classe Category:

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "CATEGORY")
public class Category {

@Id
@GeneratedValue(strategy = GenerationType.SEQUENCE)
private Integer id;
@Column(name = "DESCRIPTION", nullable = false)
private String description;

}

# classe supplier:

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "SUPPLIER")
public class Supplier {

@Id
@GeneratedValue(strategy = GenerationType.SEQUENCE)
private Integer id;

@Column(name = "NAME", nullable = false)
private String name;

}

# classe Product:

@Data
@Entity
// @Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "PRODUCT")
public class Product {

@Id
@GeneratedValue(strategy = GenerationType.SEQUENCE)
private Integer id;

@Column(name = "NAME", nullable = false)
private String name;

@ManyToOne
@JoinColumn(name = "FK_SUPPLIER", nullable = false)
private Supplier supplier;

@ManyToOne
@JoinColumn(name = "FK_CATEGORY", nullable = false)
private Category category;

}

# Testando a criação da tabela

run
utilize o spring boot dashboard

# Inserindo dados no banco de dados

crie o arqruivo import.sql
product-api/src/main/resources/import.sql

INSERT INTO CATEGORY (ID, DESCRIPTION) VALUES (1000, 'Comic Books');
INSERT INTO PRODUCT (ID, NAME, FK_SUPPLIER, FK_CATEGORY, QUANTITY_AVAILABLE, CREATED_AT) VALUES (1001, 'Crise nas Infinitas Terras', 1000, 1000, 10, CURRENT_TIMESTAMP);

o java vai compilar esse arquivo em resource

# Criando a estrutura de cada módulo: DTO, Repository, Service e Controller

# módulo: Product

(fazer)

# Criar nosso repositório

Camada de persistencias: parte do projeto onde podemos realizar ações no banco de dados (cadastros/seleções/atualizações/exclusões)

vamos criar algumas interfaces que serão responsáveis por todas as operações das nossas tabelas com o banco de dados.

repositories:
src/main/java/br/com/aes/simpledb/repositories/BookRepository.java

public interface BookRepository extends JpaRepository<Book, Long> {

}

Ao herdarmos JpaRepository o Spring Data será responsável por criar uma implementação das nossas interfaces em tempo de execução, e com isso ganhamos produtividade, pois essas interfaces vão prover inúmeros métodos para manipular os objetos diretamente no banco de dados.

# Interagindo com o banco de dados

Agora vamos criar uma classe que vai popular nosso banco de dados e por fim realizar algumas consultas.

# Controller

anotation @Autowired: é um atalho onde não há necessiadde de isntanciar objetos (injeção de dependências)

src/main/java/br/com/aes/simpledb/controllers/BookController.java

@RestController
@RequestMapping(value = "/book")
public class BookController {

@Autowired
private BookRepository bookRepository;

// @GetMapping("getAll")
// public List<Book> getData() {
// return bookRepository.findAll();
// }

@GetMapping
public List<Book> findAll() {
List<Book> result = bookRepository.findAll();
return result;
}

}

# Service

src/main/java/br/com/aes/simpledb/services/BookService.java

public class BookService {

}

Componente responsável por implementar lógica de negócio(regras)

Registrar os componentes: @Component ou apelido: @Service

public retorno função(){

}

public List findAll() {

}

é necessário injetar a dependência para acessar os métodos do repository (puxando uma isntância)

@Autowired private GameRepository gameRepository;

trazer a lista do banco dedados

public List findAll() { List result = gameRepository.findAll(); return result; }

# Testar a classe: run

fonte
https://www.gasparbarancelli.com/post/banco-de-dados-mysql-com-spring-boot

# Projeto completo

Projeto de sistema de vendas com microserviços:
Parte Java: product-api-java / postgress
Parte Php: product-api-java / banco web
Parte typescript: sales-api / mongodb
Parte typescript: product-api-java / mysql

login -> vendas(carrinho de compras) -> estoque
(token) -> mensagem -> estoque

4 servidores:
servidor 1-> Api de Login: (Primeiro app em javascript/typescript) autenticação do usuário num servidor com banco de dados postgres. Usuário faz o login e recebe um token de acesso aos outros serviços(app - servidores)
servidor 2-> Api de vendas(carrinho de compras): (Segundo app em javascript) registrar vendas com banco de dados postgres
**servidor 3-> Api de estoques de produtos: (terceiro app em java com Spring Boot) estoque de produtos com banco de dados mongodb**
servidor 4-> RabbitMQ para sistema de mensagerias assíncronas entre vendas e produtos

Uma venda será realizada e Api de vendas:
1- Requisitará a api de produtos, os ids dos produtos para listar no carrinho de compra
2- Enviará uma mensagem a api de produtos para atualizar o estoque
3- Receberá uma mensagem da api de produtos se tudo está ok

Para o sistema de mensageria, será utilizado o RabbitMQ.

## Tecnologias

- **Java 11**
- **Spring Boot**
- **Javascript ES6**
- **Node.js 14**
- **ES6 Modules**
- **Express.js**
- **MongoDB (Container e Cloud MongoDB)**
- **API REST**
- **PostgreSQL (Container e Heroku Postgres)**
- **RabbitMQ (Container e CloudAMQP)**
- **Docker**
- **docker-compose**
- **JWT**
- **Spring Cloud OpenFeign**
- **Axios**
- **Heroku**
- **Coralogix Logging**
- **Kibana**

## Arquitetura Proposta

No curso, desenvolveremos a seguinte aquitetura:

![Arquitetura Proposta](https://github.com/vhnegrisoli/curso-udemy-comunicacao-microsservicos/blob/master/Conte%C3%BAdos/Arquitetura%20Proposta.png)

Teremos 3 APIs:

- **Auth-API**: API de Autenticação com Node.js 14, Express.js, Sequelize, PostgreSQL, JWT e Bcrypt.
- **Sales-API**: API de Vendas com Node.js 14, Express.js, MongoDB, Mongoose, validação de JWT, RabbitMQ e Axios para clients HTTP.
- **Product-API**: API de Produtos com Java 11, Spring Boot, Spring Data JPA, PostgreSQL, validação de JWT, RabbitMQ e Spring Cloud OpenFeign para clients HTTP.

Também teremos toda a arquitetura rodando em containers docker via docker-compose.

### Fluxo de execução de um pedido

O fluxo para realização de um pedido irá depender de comunicações **síncronas** (chamadas HTTP via REST) e **assíncronas** (mensageria com RabbitMQ).

O fluxo está descrito abaixo:

- 01 - O início do fluxo será fazendo uma requisição ao endpoint de criação de pedido.
- 02 - O payload (JSON) de entrada será uma lista de produtos informando o ID e a quantidade desejada.
- 03 - Antes de criar o pedido, será feita uma chamada REST à API de produtos para validar se há estoque para a compra de todos os produtos.
- 04 - Caso algum produto não tenha estoque, a API de produtos retornará um erro, e a API de vendas irá lançar uma mensagem de erro informando que não há estoque.
- 05 - Caso exista estoque, então será criado um pedido e salvo no MongoDB com status pendente (PENDING).
- 06 - Ao salvar o pedido, será publicada uma mensagem no RabbitMQ informando o ID do pedido criado, e os produtos com seus respectivos IDs e quantidades.
- 07 - A API de produtos estará ouvindo a fila, então receberá a mensagem.
- 08 - Ao receber a mensagem, a API irá revalidar o estoque dos produtos, e caso todos estejam ok, irá atualizar o estoque de cada produto.
- 09 - Caso o estoque seja atualizado com sucesso, a API de produtos publicará uma mensagem na fila de confirmação de vendas com status APPROVED.
- 10 - Caso dê algum problema na atualização, a API de produtos publicará uma mensagem na fila de confirmação de vendas com status REJECTED.
- 11 - Por fim, a API de pedidos irá receber a mensagem de confirmação e atualizará o pedido com o status retornado na mensagem.

## Logs e Tracing da API

Todos os endpoints necessitam um header chamado **transactionid**, pois representará o ID que irá percorrer toda a requisição no serviço, e, caso essa aplicação chame outros microsserviços, esse **transactionid** será repassado. Todos os endpoints de entrada e saída irão logar os dados de entrada (JSON ou parâmetros) e o **transactionid**.

A cada requisição pra cada microsserviço, teremos um atributo **serviceid** gerado apenas para os logs desse serviço em si. Teremos então o **transactionid** que irá circular entre todos os microsserviços envolvidos na requisição, e cada microsserviço terá seu próprio **serviceid**.

Fluxo de tracing nas requisições:

**POST** - **/api/order** com **transactionid**: ef8347eb-2207-4610-86c0-657b4e5851a3

```
service-1:
transactionid: ef8347eb-2207-4610-86c0-657b4e5851a3
serviceid    : 6116a0f4-6c9f-491f-b180-ea31bea2d9de
|
| HTTP Request
|----------------> service-2:
                   transactionid: ef8347eb-2207-4610-86c0-657b4e5851a3
                   serviceid    : 4e1261c1-9a0c-4a5d-bfc2-49744fd159c6
                   |
                   | HTTP Request
                   |----------------> service-3: /api/check-stock
                                      transactionid: ef8347eb-2207-4610-86c0-657b4e5851a3
                                      serviceid    : b4fbc082-a49a-440d-b1d6-2bd0557fd189
```

Como podemos ver no fluxo acima, o **transactionid** ef8347eb-2207-4610-86c0-657b4e5851a3 manteve-se o mesmo nos 3 serviços, e cada serviço possui
seu próprio **serviceid**.

Exemplo de um fluxo completo chamando 5 serviços e gerando **transactionid** e **serviceid**:

![Tracing](https://github.com/vhnegrisoli/curso-udemy-comunicacao-microsservicos/blob/master/Conte%C3%BAdos/Tracing.png)

Exemplo de logs nas APIs desenvolvidas:

Auth-API:

```
Request to POST login with data {"email":"testeuser1@gmail.com","password":"123456"} | [transactionID: e3762030-127a-4079-9dee-ba961d7e77ce | serviceID: 6b07b6c2-009e-4799-be96-3bf972338b17]

Response to POST login with data {"status":200,"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoVXNlciI6eyJpZCI6MSwibmFtZSI6IlVzZXIgVGVzdCAxIiwiZW1haWwiOiJ0ZXN0ZXVzZXIxQGdtYWlsLmNvbSJ9LCJpYXQiOjE2MzQwNTE4ODQsImV4cCI6MTYzNDEzODI4NH0.NJ-h2i5XPT8NwZyZ_43bif1NIS00ROfCtRecBkxy5A8"} | [transactionID: e3762030-127a-4079-9dee-ba961d7e77ce | serviceID: 6b07b6c2-009e-4799-be96-3bf972338b17]
```

Product-API:

```
Request to POST product stock with data {"products":[{"productId":1001,"quantity":1},{"productId":1002,"quantity":1},{"productId":1003,"quantity":1}]} | [transactionID: 8817508e-805c-48fb-9cb4-6a1e5a6e71e9 | serviceID: ea146e74-55cf-4a53-860e-9010d6e3f61b]

Response to POST product stock with data {"status":200,"message":"The stock is ok!"} | [transactionID: 8817508e-805c-48fb-9cb4-6a1e5a6e71e9 | serviceID: ea146e74-55cf-4a53-860e-9010d6e3f61b]
```

Sales-API:

```
Request to POST new order with data {"products":[{"productId":1001,"quantity":1},{"productId":1002,"quantity":1},{"productId":1003,"quantity":1}]} | [transactionID: 8817508e-805c-48fb-9cb4-6a1e5a6e71e9 | serviceID: 5f553f02-e830-4bed-bc04-8f71fe16cf28]

Response to POST login with data {"status":200,"createdOrder":{"products":[{"productId":1001,"quantity":1},{"productId":1002,"quantity":1},{"productId":1003,"quantity":1}],"user":{"id":1,"name":"User Test 1","email":"testeuser1@gmail.com"},"status":"PENDING","createdAt":"2021-10-12T16:34:49.778Z","updatedAt":"2021-10-12T16:34:49.778Z","transactionid":"8817508e-805c-48fb-9cb4-6a1e5a6e71e9","serviceid":"5f553f02-e830-4bed-bc04-8f71fe16cf28","_id":"6165b92addaf7fc9dd85dad0","__v":0}} | [transactionID: 8817508e-805c-48fb-9cb4-6a1e5a6e71e9 | serviceID: 5f553f02-e830-4bed-bc04-8f71fe16cf28]
```

RabbitMQ:

```
Sending message to product update stock: {"salesId":"6165b92addaf7fc9dd85dad0","products":[{"productId":1001,"quantity":1},{"productId":1002,"quantity":1},{"productId":1003,"quantity":1}],"transactionid":"8817508e-805c-48fb-9cb4-6a1e5a6e71e9"}

Recieving message with data: {"salesId":"6165b92addaf7fc9dd85dad0","products":[{"productId":1001,"quantity":1},{"productId":1002,"quantity":1},{"productId":1003,"quantity":1}],"transactionid":"8817508e-805c-48fb-9cb4-6a1e5a6e71e9"} and TransactionID: 8817508e-805c-48fb-9cb4-6a1e5a6e71e9

Sending message: {"salesId":"6165b92addaf7fc9dd85dad0","status":"APPROVED","transactionid":"8817508e-805c-48fb-9cb4-6a1e5a6e71e9"}

Recieving message from queue: {"salesId":"6165b92addaf7fc9dd85dad0","status":"APPROVED","transactionid":"8817508e-805c-48fb-9cb4-6a1e5a6e71e9"}
```

## Documentação dos endpoints

A documentação da API se faz presente no arquivo [API_DOCS.md](https://github.com/vhnegrisoli/curso-udemy-comunicacao-microsservicos/blob/master/API_DOCS.md).

## Deploy no Heroku

As 3 APIs foram publicadas no Heroku, o repositório que foram publicados são esses:

- Auth-API - https://github.com/vhnegrisoli2018/auth-api (PostgreSQL e Coralogix Logging)
- Product-API - https://github.com/vhnegrisoli2018/product-api (Coralogix Logging, Cloud MongoDB e CloudAQMP)
- Sales-API - https://github.com/vhnegrisoli2018/sales-api (Coralogix Logging Heroku Postgres e CloudAQMP)

As URL base são:

- Auth-API - https://microsservicos-auth-api.herokuapp.com/
- Product-API - https://microsservicos-product-api.herokuapp.com/
- Sales-API - https://microsservicos-sales-api.herokuapp.com/

## Tracing com Coralogix Logging e Kibana

O Coralogix Logging é um add-on do Heroku para adicionarmos um dashboard de status e visualização de logs das aplicações.

Exemplo do dashboard do Coralogix Logging da aplicação Product-API:

![Dashboard Product-API](https://github.com/vhnegrisoli/curso-udemy-comunicacao-microsservicos/blob/master/Conte%C3%BAdos/Coralogix%20Logging%20Dashboard.png)

No Heroku, conseguimos realizar o tracing da aplicação através do nosso header **TransactionID** que é obrigatório em todos os endpoints.

Abaixo foi mostrado um exemplo de tracing realizado com um pedido criado para o **TransactionID** com valor **1c75be8c-efbe-44d7-99ea-60564465c77a**.

![Requisição](https://github.com/vhnegrisoli/curso-udemy-comunicacao-microsservicos/blob/master/Conte%C3%BAdos/Exemplo%20Rastreamento%20Requisi%C3%A7%C3%A3o.png)

Após realizada a requisição, vamos ao nosso Kibana disponibilizado pelo Coralogix Logging da aplicaçãode Sales-API e pesquisaremos os logs pelo valor **1c75be8c-efbe-44d7-99ea-60564465c77a**:

![Kibana Sales-API](https://github.com/vhnegrisoli/curso-udemy-comunicacao-microsservicos/blob/master/Conte%C3%BAdos/Tracing%20Sales-API.png)

Podemos ver vários logs de entrada e saída, contendo o JSON de entrada e saída. Também podemos visualizar que foi feita uma chamada ao microsserviço de Product-API via HTTP REST, e também uma comunicação via mensagem do Rabbit, e conseguimos visualizar esses logs sendo recebidos lá na aplicação de Product-API:

![Kibana Product-API](https://github.com/vhnegrisoli/curso-udemy-comunicacao-microsservicos/blob/master/Conte%C3%BAdos/Tracing%20Product-API.png)

Com isso, conseguimos rastrear todos os dados de entrada e saída dos endpoints, o ID da transação que circula entre eles via chamada REST e via mensageria, facilitando no acompanhamento de logs de uma requisição específica e, principalmente, no processo de troubleshooting.

## Comandos Docker

Abaixo serão listados alguns dos comandos executados durante o curso para criação dos containers
dos bancos de dados PostgreSQL, MongoDB e do message broker RabbitMQ:

#### Container Auth-DB

`docker run --name auth-db -p 5432:5432 -e POSTGRES_DB=auth-db -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=123456 postgres:11`

#### Container Product-DB

`docker run --name product-db -p 5433:5432 -e POSTGRES_DB=product-db -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=123456 postgres:11`

#### Container Sales-DB

`docker run --name sales-db -p 27017:27017 -p 28017:28017 -e MONGODB_USER="admin" -e MONGODB_DATABASE="sales" -e MONGODB_PASS="123456" -v  c:/db tutum/mongodb`

#### Conexão no Mongoshell

`mongo "mongodb://admin:123456@localhost:27017/sales"`

#### Container RabbitMQ

`docker run --name sales_rabbit -p 5672:5672 -p 25676:25676 -p 15672:15672 rabbitmq:3-management`

### Execução docker-compose

`docker-compose up --build`

Para ignorar os logs, adicione a flag `-d`.

## Autor

### Victor Hugo Negrisoli

### Desenvolvedor de Software Back-End
