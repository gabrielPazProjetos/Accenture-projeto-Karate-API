Feature: Criar usuário e adicionar livros outLine
# cenario outline do adicionarLivroAoUsuario
    Background:
        * def baseUrl = 'https://bookstore.demoqa.com'

# criar usuario para a feature
        * def userName = 'gabriel_user_' + java.util.UUID.randomUUID()
        * def password = 'Senha@qualquer123'

        Given url baseUrl + '/Account/v1/User'
        And request { userName: '#(userName)', password: '#(password)' }
        When method POST
        Then status 201
        * def userId = response.userID

# gerar token valido para o teste
        Given url baseUrl + '/Account/v1/GenerateToken'
        And request { userName: '#(userName)', password: '#(password)' }
        When method POST
        Then status 200
        * def authToken = response.token

    Scenario Outline: Adicionar livro ao usuário com ISBNs diferentes
# o cenario outline usa o mesmo usuario e token criados no background e adiciona cada ISBN que foi listado na tabela

        Given url baseUrl + '/BookStore/v1/Books'
        And header Authorization = 'Bearer ' + authToken
        And request
    """
    {
      "userId": "#(userId)",
      "collectionOfIsbns": [
        { "isbn": "<isbn>" }
      ]
    }
    """
        When method POST
        Then status 201
        * match response.books[0].isbn == "<isbn>"
        * print 'Livro adicionado com ISBN:', '<isbn>'

    # validar o livro que foi adicionado
        Given url baseUrl + '/BookStore/v1/Book'
        And param ISBN = '<isbn>'
        When method GET
        Then status 200
        * match response.isbn == '<isbn>'
        * match response.title == '<title>'
        * print 'Validação concluída:', response.title

        Examples:
            | isbn           | title                                      |
            | 9781449325862  | Git Pocket Guide                           |
            | 9781449331818  | Learning JavaScript Design Patterns        |
            | 9781449337711  | Designing Evolvable Web APIs with ASP.NET  |
            | 9781449365035  | Speaking JavaScript                        |
            | 9781491950296  | Programming JavaScript Applications        |
            | 9781593275846  | Eloquent JavaScript, Second Edition        |
            | 9781593277574  | Understanding ECMAScript 6                 |