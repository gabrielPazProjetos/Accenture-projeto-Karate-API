Feature: Criar usuário e adicionar livro

  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'

    # adicionar livro e validar, esse username e password sao diferentes por motivos de testes antigos, mas nao afeta a feature.
  Scenario: Consultar lista de livros e adicionar o primeiro ISBN dinamicamente
    * def userName = 'gabriel_user_' + java.util.UUID.randomUUID()
    * def password = 'Senha@qualquer123'

    Given url baseUrl + '/Account/v1/User'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 201
    * match response.userID != null
    * def userId = response.userID
    * print 'Usuário criado:', userName, 'userID:', userId

    # gerar o token
    Given url baseUrl + '/Account/v1/GenerateToken'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 200
    * match response.token != null
    * def authToken = response.token
    * print 'Token gerado:', authToken

    # lista de livros da api
    Given url baseUrl + '/BookStore/v1/Books'
    When method GET
    Then status 200
    * match response.books != []
    * assert response.books.length > 0
    * def firstIsbn = response.books[0].isbn
    * print 'Primeiro ISBN capturado:', firstIsbn

    # adicionando o livro ao usuario
    Given url baseUrl + '/BookStore/v1/Books'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "userId": "#(userId)",
      "collectionOfIsbns": [
        { "isbn": "#(firstIsbn)" }
      ]
    }
    """
    When method POST
    Then status 201
    * print 'Livro adicionado com sucesso ao usuário:', userName

    # validando o livro que sera adicionado usando seu respectivo ISBN
    Given url baseUrl + '/BookStore/v1/Book'
    And param ISBN = firstIsbn
    When method GET
    Then status 200
    * match response.isbn == firstIsbn
    * match response.title != null
    * match response.author != null
    * print 'Validação do livro concluída:', response.title, '-', response.author

    # cenario negativo
  Scenario: Falha ao adicionar livro com token inválido

    # criar usuario dinamicamente
    * def userName = 'gabriel_user_' + java.util.UUID.randomUUID()
    * def password = 'Senha@qualquer123'

    Given url baseUrl + '/Account/v1/User'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 201
    * def userId = response.userID

    # pegar lista de livros para o cenario negativo
    Given url baseUrl + '/BookStore/v1/Books'
    When method GET
    Then status 200
    * def firstIsbn = response.books[0].isbn

    # tentando adicionar livro usando um token invalido
    Given url baseUrl + '/BookStore/v1/Books'
    And header Authorization = 'Bearer INVALID_TOKEN'
    And request
    """
    {
      "userId": "#(userId)",
      "collectionOfIsbns": [
        { "isbn": "#(firstIsbn)" }
      ]
    }
    """
    When method POST
    Then status 401
    * match response.message == 'User not authorized!' || response.message == 'Invalid token'
    * print 'Mensagem de erro ao adicionar livro com token inválido:', response.message
