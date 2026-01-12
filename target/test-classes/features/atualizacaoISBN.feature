Feature: Atualizar ISBN do livro do usuário

  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'

  Scenario: Criar usuário e atualizar ISBN

    # criar usuario unico apenas para a feature funcionar corretamente
    * def userName = 'usuario_' + java.util.UUID.randomUUID()
    * def password = 'Senha@123'

    Given url baseUrl
    And path '/Account/v1/User'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 201
    * def userId = response.userID
    * print 'Novo UserId criado:', userId

    # gerar token
    Given url baseUrl
    And path '/Account/v1/GenerateToken'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 200
    * def authToken = response.token
    * print 'Token gerado:', authToken

    # buscar lista dos livros que estao disponiveis
    Given url baseUrl
    And path '/BookStore/v1/Books'
    When method GET
    Then status 200
    * def firstIsbn = response.books[0].isbn
    * def secondIsbn = response.books[1].isbn
    * print 'ISBN inicial:', firstIsbn, 'ISBN novo:', secondIsbn

    # adicionar um primeiro livro ao usuario
    Given url baseUrl
    And path '/BookStore/v1/Books'
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

    # atualizar ISBN do livro
    Given url baseUrl
    And path '/BookStore/v1/Books', firstIsbn
    And header Authorization = 'Bearer ' + authToken
    And request { userId: '#(userId)', isbn: '#(secondIsbn)' }
    When method PUT
    Then status 200
    * match response.books[0].isbn == secondIsbn
    * print 'Livro atualizado para ISBN:', secondIsbn

    # cenario negativo
  Scenario: Tentar atualizar ISBN com token inválido

    * def tokenInvalido = 'Bearer 1234567890'

    Given url baseUrl
    And path '/BookStore/v1/Books', '9781449325862'
    And header Authorization = tokenInvalido
    And request { userId: 'qualquer-id', isbn: '9781449331818' }
    When method PUT
    Then status 401
    * match response.message == 'User Id not correct!'
    * print 'Erro esperado:', response
