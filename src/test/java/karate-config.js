function fn() {
  var config = {};
  config.baseUrl = 'https://bookstore.demoqa.com';

// açao para um nome unico
  var timestamp = new Date().getTime();
  var user = {
    userName: 'usuario_' + timestamp,
    password: 'Senha@123'
  };


// chama a feature criarUsuario.feature com callsingle
  var authResult = karate.callSingle('classpath:features/criarUsuario.feature', user);


// caso o o userId nao vier no retorno, cria um valor que seja alternativo por causa do timestamp.
  var safeUserId = authResult.userId || ('uid_' + timestamp);


// cria objeto config.user com userName e userId e config.token com o token gerado.
  config.user = { userName: authResult.userName, userId: safeUserId };
  config.token = authResult.authToken;


// faz com que seja exibido o userId e token no console.
  karate.log('Token gerado no config:', config.token, 'UserId:', config.user.userId);

// retorna o objeto config para ser usado em todas as features do projeto.
  return config;
}
