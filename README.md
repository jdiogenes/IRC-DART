# IRC Chat

## Funcionalidades


* _NICK_: Da ao usuário a capacidade de alterar seu _nickname_. O servidor informa uma mensagem de erro se um usuário tentar usar um apelido já recebido.

* _USUARIO_: Especifa o nome de usuário, _hostname_ e nome real de um usuário.

* _SAIR_: Finaliza a sessão do cliente. O servidor anuncia a saída do cliente para
todos os outros usuários que compartilham o canal com o cliente que parte.

* _ENTRAR_: Comece a ouvir um canal específico. Embora o protocolo padrão de IRC permita que um cliente entre em múltiplos canais simultaneamente, o nosso servidor restringe um cliente a ser um membro de no máximo um canal.

* _SAIRC_: Saia de um canal específico.

* _LISTAR_: Lista todos os canais existentes apenas no servidor local.

## Execução

Para inicializar o servidor IRC, executa-se, no terminal:

```
dart bin/server.dart
```

Para conectar-se ao servidor, utiliza-se, no terminal:

```
telnet localhost 4040
```
