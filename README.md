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

## docker-composer:

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

run na raiz do projeto:docker-compose up --build

# Desenvolvimento da aplicação

# Criação do porjeto Produtc API com java, spring boot e PostgresSQl

Inicializar a api de produtos: java srping boot

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

abra a pasta do projeto no vscode para baixar as dependncias

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

## Criação de uma controller padrão

criar a pasta: controllers
cria o arquivo: StatusController.java
src/main/java/br/com/aes/productapi/controllers/StatusController.java

### cria a classe: StatusController.java

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

### configurações para mudar o local host:

Arquivo resources: configuraçoes
trocar application.properties para application.yml

inserir:
server:
port: ${PORT:8081}

spring:
application:
name: Product-api

## Criação de uma controller padrão

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
