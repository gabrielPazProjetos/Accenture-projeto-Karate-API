Feature: Listar os livros

  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'
    * header Authorization = 'Bearer ' + token

 # listar todos os livros
  Scenario: Listar todos os livros

    Given url baseUrl + '/BookStore/v1/Books'
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And match response.books != null
    * assert response.books.length > 0
    * print 'Quantidade de livros retornados:', response.books.length

    # cenario negativo
  Scenario: retorna os livros mesmo com o parametro invalido

    Given url baseUrl + '/BookStore/v1/Books?invalidParam=abc'
    When method GET
    Then status 200
    And match response.books != null
    * assert response.books.length > 0
    * print 'Quantidade de livros retornados mesmo com parâmetro inválido:', response.books.length
