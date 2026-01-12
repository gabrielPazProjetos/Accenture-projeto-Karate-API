Feature: Buscar livro por ISBN outLine

  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'

  Scenario Outline: Buscar livro por ISBN listado no catálogo
# o placeHolder sera subsituido pelos respectivos campos no final do codigo, garantindo a busca corretamente

    Given url baseUrl + '/BookStore/v1/Book'
    And param ISBN = '<isbn>'
    When method GET
    Then status 200
    And match response.isbn == '<isbn>'
    And match response.title == '<title>'
    * print 'Livro encontrado:', response.title

    Examples:
# livros disponibilizados no catalogo da api que serao usados no cenario outLine
      | isbn           | title                                      |
      | 9781449325862  | Git Pocket Guide                           |
      | 9781449331818  | Learning JavaScript Design Patterns        |
      | 9781449337711  | Designing Evolvable Web APIs with ASP.NET  |
      | 9781449365035  | Speaking JavaScript                        |
      | 9781491950296  | Programming JavaScript Applications        |
      | 9781593275846  | Eloquent JavaScript, Second Edition        |
      | 9781593277574  | Understanding ECMAScript 6                 |
