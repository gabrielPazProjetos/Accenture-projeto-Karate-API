Feature: Buscar livro por ISBN

  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'

    # busca concluida de forma correta
  Scenario: Buscar livro por ISBN válido

    Given url baseUrl + '/BookStore/v1/Book'
    And param ISBN = '9781449325862'
    When method GET
    Then status 200
    And match response.isbn == '9781449325862'
    * print 'Livro encontrado:', response.title

    # cenario negativo
  Scenario: Buscar livro por ISBN inválido

    Given url baseUrl + '/BookStore/v1/Book'
    And param ISBN = '0000000000000'
    When method GET
    Then status 400
    And match response.message == 'ISBN supplied is not available in Books Collection!'
    * print 'Nenhum livro encontrado para o ISBN fornecido.'
