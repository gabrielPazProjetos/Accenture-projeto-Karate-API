# Accenture-projeto-Karate-API-BookStore

## Ferramentas usadas
- Api:  https://bookstore.demoqa.com/swagger/ 
- Intellij IDEA (extensões: Cucumber for Java + Gherkin)
- Jdk 21
- Maven

## Features
POST /Account/v1/User/ - Cria um usuário. nele também há o conteúdo do callSingle que usado para reaproveitamento de token e userID.
Cenário negativo - Falha na criação de token com password incorreto.

- POST /Account/v1/GenerateToken - Feature para criação de tokens que permite acesso a api completa, já que em algumas ações é exigido uma.
Cenario negativo - Usando payload invalido.

- DELETE /Account/v1/User/{{UUID}} - Deletar usuário usando o seu id, nessa feature, organizei a criação de um usuário dentro exclusivamente para ser deletado com a feature. 
Cenario negativo - Tentativa de deletar um usuário sem autenticação.

- GET /BookStore/v1/Books - Lista o catalogo de livros da api, que retorna os livros registrados nela para usar em outras features.
Cenario negativo - Como o método so permite 200 na api, tentei fazer com que retornasse livros com o parâmetro invalido, e realmente retornou.
Cenario Outline: executa uma busca com parâmetro valido X invalido.

- POST /BookStore/v1/Books - Adiciona livro ao usuário usando a lista do GET /Books para anexar o primeiro ISBN de forma dinâmica.
Cenario negativo - Falha ao adicionar livro do usuário causado por um token invalido.
Cenario Outline - Adiciona vários livros para o usuário, os mesmos livros disponíveis no GET da lista de livros.

- GET /BookStore/v1/Book - Busca os livros usando seu ISBN único.
Cenario negativo - Tenta buscar um livro com ISBN invalido.
Cenario Outline - Busca quase todos os livros que estão disponíveis na api.

- PUT /BookStore/v1/Books/{ISBN} - Primeiramente, cria um usuário para ser usado nessa feature, token valido e adiciona o primeiro livro ao usuário, que em seguida terá o ISBN atualizado por outro.
Cenario negativo - Atualização de ISBN usando um token invalido.
Cenario Outline - Repete o processo com praticamente quase todos os livros disponíveis da api.

## Detalhes sobre o projeto
- No karate.config, configurei o reaproveitamento da token e UID por meio de callsingle que, nesta api, seria o mais adequado e mais consistente aqui.

- Há um runner que rodara todos as features dentro da /features/. Ele ajudou bastante em economizar tempo. Alem do runner, para o teste rodar, também pode usar o mvn test no terminal, sera gerado um relatório html sobre todas as features e seus devidos resultados (o mesmo do runner).

- Em algumas features, fiz cenários outline, que melhoram ainda mais a absorção de resultados em um teste, repetindo-os varias vezes com dados diferentes

- Validações básicas em todas as features usando match e status.

- Criação e reaproveitamento de algumas variáveis básicas, como a de url etc.

- Organização em forma de comentários, para melhor entendimento.

## NOTA: todas as senhas e nomes de usuario são falsos e inventados por mim, não tem nenhum dado real que seja considerado sensivel.
