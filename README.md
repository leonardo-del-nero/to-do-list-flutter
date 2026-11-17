# To-Do Nero

App de lista de tarefas feito em Flutter. O usuário cria uma conta, faz login e consegue criar, ver, editar, concluir e excluir as suas tarefas. Cada usuário só vê as próprias tarefas.

Versão web: https://leonardo-del-nero.github.io/to-do-list-flutter/

Na versão web os dados ficam salvos no navegador de quem estiver usando.

## Funcionalidades

- Cadastro de usuário (nome, e-mail e senha)
- Login e logout
- Telas protegidas: a Home e o formulário só abrem com usuário logado
- CRUD de tarefas: criar, listar, editar e excluir
- Marcar tarefa como concluída
- Validação dos formulários (campo vazio, e-mail inválido, senha curta)
- Mensagens de erro (login inválido, e-mail já cadastrado)

## Tecnologias

- Flutter e Dart
- sqflite (SQLite)
- sqflite_common_ffi_web (SQLite na versão web)
- path
- crypto (hash da senha com SHA-256)
- Rotas nomeadas do Flutter

## Como rodar

Precisa do Flutter instalado e de um emulador Android aberto (ou celular conectado).

```bash
git clone https://github.com/leonardo-del-nero/to-do-list-flutter.git
cd to-do-list-flutter
flutter pub get
flutter run
```

Para rodar no navegador: `flutter run -d chrome`

Para rodar o teste: `flutter test`

O site é publicado no GitHub Pages pelo GitHub Actions toda vez que tem push na `main` (arquivo `.github/workflows/pages.yml`).

## Autenticação

Fica no `auth_service.dart` e usa o próprio SQLite.

- Cadastro: verifica se o e-mail já existe. Se não existir, salva o usuário com a senha em hash SHA-256, então a senha original não fica gravada no banco.
- Login: busca um usuário com o e-mail e o hash da senha. Se não encontrar, mostra "E-mail ou senha inválidos".
- Logout: limpa o usuário logado e volta para a tela de login.
- Proteção das telas: a função `protegida()` no `main.dart` mostra o login se não tiver ninguém logado.

## Banco de dados

SQLite (`agenda.db`), criado no `database_service.dart`.

Tabelas:

- usuarios: id, nome, email (único), senha (hash)
- tarefas: id, usuario_id, titulo, descricao, concluida (0 ou 1)

As tarefas são sempre buscadas pelo `usuario_id` de quem está logado.

No celular o banco é um arquivo no aparelho. Na web é usado o `sqflite_common_ffi_web`, que roda o SQLite em WebAssembly e salva no navegador. Essa troca acontece no `DatabaseService.configurar()`, chamado no `main()`. O resto do código é igual.

## Estrutura

```
lib/
  main.dart
  models/
    usuario.dart
    tarefa.dart
  services/
    auth_service.dart
    database_service.dart
  screens/
    login_screen.dart
    register_screen.dart
    home_screen.dart
    tarefa_form_screen.dart
  widgets/
    tarefa_tile.dart
test/
  widget_test.dart
web/
```

- models: classes Usuario e Tarefa
- services: autenticação e acesso ao banco
- screens: telas do app
- widgets: componentes reutilizáveis (item da lista)

## Autor

Leonardo Del Nero, 5º semestre de DSM
