Feature: Atualizar ISBN do livro do usuário outLine
# cenario outline do atualizacaoISBN
  Background:
    * def baseUrl = 'https://bookstore.demoqa.com'

  Scenario Outline: Atualizar ISBN do livro com diferentes combinações

    # criar usuario unico para a feature outLine
    * def userName = 'usuario_' + java.util.UUID.randomUUID()
    * def password = 'Senha@123'

    Given url baseUrl
    And path '/Account/v1/User'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 201
    * def userId = response.userID

    # gerar token para a feature
    Given url baseUrl
    And path '/Account/v1/GenerateToken'
    And request { userName: '#(userName)', password: '#(password)' }
    When method POST
    Then status 200
    * def authToken = response.token

    # adicionar o primeiro livro ao usuario
    Given url baseUrl
    And path '/BookStore/v1/Books'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "userId": "#(userId)",
      "collectionOfIsbns": [
        { "isbn": "<isbnAntigo>" }
      ]
    }
    """
    When method POST
    Then status 201

    # atualizar o ISBN do livro
    Given url baseUrl
    And path '/BookStore/v1/Books', '<isbnAntigo>'
    And header Authorization = 'Bearer ' + authToken
    And request { userId: '#(userId)', isbn: '<isbnNovo>' }
    When method PUT
    Then status 200
    * match response.books[0].isbn == '<isbnNovo>'
    * print 'Livro atualizado de <isbnAntigo> para <isbnNovo>'

    Examples:
# ISBN dos livros disponibilizados na api
      | isbnAntigo     | isbnNovo       |
      | 9781449325862  | 9781449331818  |
      | 9781449337711  | 9781449365035  |
      | 9781491950296  | 9781593275846  |
      | 9781593277574  | 9781449325862  |

