Feature: Gerar token

  Scenario:
    Given url 'https://bookstore.demoqa.com/Account/v1/GenerateToken'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 200

    * def authToken = response.token
    * def result = { authToken: authToken }

# cenario negativo com payload invalido
  Scenario: Gerar token sem o password

    Given url 'https://bookstore.demoqa.com/Account/v1/GenerateToken'
    And request { "userName": "testuser" }
    When method POST
    Then status 400

