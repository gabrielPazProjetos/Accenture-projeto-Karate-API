Feature: Cenário negativo da autenticação de usuario
# separado para evitar problemas com o callSingle

  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'

  Scenario: Gerar token com senha inválida

    * def userName = 'usuario_' + java.util.UUID.randomUUID()
    * def password = 'Senha@123'

# criaçao de usuario para o teste negativo
    Given url baseUrl + '/Account/v1/User'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 201
    * def createdUserId = response.userID

# falha ao gerar token causado pela senha incorreta
    Given url baseUrl + '/Account/v1/GenerateToken'
    And request { userName: '#(userName)', password: 'SenhaErrada@123' }
    When method POST
    Then status 200
    * match response.result == 'User authorization failed.'
    * print 'Erro esperado:', response
