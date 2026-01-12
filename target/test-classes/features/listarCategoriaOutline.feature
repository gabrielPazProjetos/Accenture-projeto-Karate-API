Feature: Listar os livros outLine
# cenario outline do listarCatalogo
  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'
    * header Authorization = 'Bearer ' + token

  Scenario Outline: Listar livros com diferentes parâmetros
    Given url baseUrl + '/BookStore/v1/Books<param>'
    When method GET
    Then status 200
    And match response.books != null
    * assert response.books.length > 0
    * print '<mensagem>', response.books.length

    Examples:
      | param              | mensagem                                                   |
      |                    | Quantidade de livros retornados:                           |
      | ?invalidParam=abc  | Quantidade de livros retornados mesmo com parâmetro inválido: |
