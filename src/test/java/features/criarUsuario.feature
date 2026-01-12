Feature: Criar usuário e gerar token

  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'

  Scenario: Criar usuário dinâmico e gerar token
# retorna os dados para serem reutilizados nas outras features desse projeto.

    * def args = karate.get('__arg') || {}
    * def userName = 'usuario_' + java.util.UUID.randomUUID()
    * def password = 'Senha@123'

    # criar o usuario
    Given url baseUrl + '/Account/v1/User'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 201
    * def createdUserId = response.userID
    * match response.username == userName
    * match response.books == []
    * print 'UserId retornado:', createdUserId

    # gerar o token
    Given url baseUrl + '/Account/v1/GenerateToken'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 200
    * def authToken = response.token
    * match response.result == 'User authorized successfully.'
    * match authToken != null
    * print 'Token gerado:', authToken

    # retorno para o callSingle
    * def result = { authToken: authToken, userName: userName, userId: createdUserId }
