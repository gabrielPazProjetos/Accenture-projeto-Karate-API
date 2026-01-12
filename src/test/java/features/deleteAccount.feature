Feature: Deletar Usuário

  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'

  Scenario: Criar usuário para a feature de DELETE
    # cria um usuario temporario e em seguida deleta-lo usando autenticaçao basic.

    * def randomId = java.util.UUID.randomUUID().toString()
    * def userName = 'testuser_' + randomId
    * def password = 'Test@1234'

    # criaçao de usuario apenas para ser deletado no final
    Given url baseUrl + '/Account/v1/User'
    And request { userName: '#(userName)', password: '#(password)' }
    When method post
    Then status 201

    # guardar o ID retornado para que o usuario criado seja deletado com sucesso
    * def userId = response.userID
    * print 'Usuário criado:', userId

    # preparando autenticaçao basic para o usuario recem criado ser deletado
    * def basicAuth = java.util.Base64.getEncoder().encodeToString((userName + ':' + password).getBytes('UTF-8'))
    * print 'Header Authorization:', 'Basic ' + basicAuth

    # deletar usuario usando o ID que acabou de ser criado
    Given url baseUrl + '/Account/v1/User/' + userId
    And header Authorization = 'Basic ' + basicAuth
    When method delete
    * def success = responseStatus == 200 || responseStatus == 204
    * match success == true
    * print 'Usuário deletado'

    # cenario negativo
  Scenario: Deletar usuário sem autenticação

    Given url baseUrl + '/Account/v1/User/00000000-0000-0000-0000-000000000000'
    When method delete
    Then status 401
