# Spotergs - Spotify-like Flutter App

## 🎵 Sobre o Projeto

Aplicativo Flutter estilo Spotify usando **GetX** para gerenciamento de estado, navegação e injeção de dependências. O projeto foi estruturado para ser modular, escalável e fácil de manter.

## 📋 Funcionalidades

- ✅ **Autenticação**
  - Login com email e senha
  - Cadastro de novos usuários
  - Modo convidado (guest) com nickname
  
- ✅ **Música**
  - Listagem de músicas com paginação
  - Busca de músicas por título, artista ou álbum
  - Player de áudio com controles (play/pause/seek)
  - Sistema de favoritos
  - Detalhes da música

- ✅ **Listen Together**
  - Criar salas para ouvir músicas sincronizadas
  - Entrar em salas existentes
  - Sincronização em tempo real via WebSocket

- ✅ **Player**
  - Bottom sheet persistente
  - Player full-screen
  - Controles de reprodução
  - Barra de progresso

## 🛠 Tecnologias

- **Flutter 2.29.2**
- **Dart 3.7.2**
- **GetX 4.6.6** - State management, navigation e dependency injection
- **Dio 4.0.6** - HTTP client
- **just_audio 0.9.36** - Audio player
- **flutter_secure_storage 8.0.0** - Secure storage
- **web_socket_channel 2.4.0** - WebSocket client
- **cached_network_image 3.2.3** - Image caching
- **share_plus 4.5.3** - Sharing functionality
- **connectivity_plus 4.0.2** - Network connectivity

## 📁 Estrutura do Projeto

```
lib/
├── app/
│   ├── core/
│   │   ├── services/
│   │   │   ├── api_service.dart        # HTTP client com Dio
│   │   │   ├── audio_service.dart      # Player de áudio
│   │   │   ├── storage_service.dart    # Armazenamento seguro
│   │   │   └── websocket_service.dart  # Cliente WebSocket
│   │   ├── theme/
│   │   │   └── app_theme.dart          # Tema escuro Spotify-like
│   │   └── widgets/
│   │       ├── music_card.dart         # Card de música
│   │       ├── primary_button.dart     # Botões primários
│   │       └── text_input_field.dart   # Campo de texto
│   ├── modules/
│   │   ├── login/                      # Módulo de autenticação
│   │   ├── home/                       # Módulo home (em desenvolvimento)
│   │   ├── search/                     # Módulo de busca (em desenvolvimento)
│   │   ├── player/                     # Módulo player (em desenvolvimento)
│   │   └── listen_together/            # Módulo listen together (em desenvolvimento)
│   ├── repositories/
│   │   ├── auth_repository.dart        # Repositório de autenticação
│   │   └── music_repository.dart       # Repositório de músicas
│   ├── routes/
│   │   └── app_routes.dart             # Rotas da aplicação (em desenvolvimento)
│   └── utils/
│       ├── constants.dart              # Constantes da aplicação
│       └── helpers.dart                # Funções auxiliares
└── main.dart                           # Ponto de entrada (em desenvolvimento)
```

## 🚀 Como Executar

### Pré-requisitos

- Flutter 2.29.2 ou superior
- Dart 3.7.2 ou superior

### Instalação

1. Clone o repositório
```bash
git clone https://github.com/Matheus-Silva02/spotergs.git
cd spotergs
```

2. Instale as dependências
```bash
flutter pub get
```

3. Configure as URLs do backend

Edite o arquivo `lib/app/utils/constants.dart` e configure as URLs da API e WebSocket:

```dart
static const String baseUrl = 'http://seu-backend:3000/api';
static const String wsUrl = 'ws://seu-backend:3000/ws';
```

4. Execute o aplicativo
```bash
flutter run
```

## 🔧 Configuração do Backend

O aplicativo espera os seguintes endpoints da API:

### Autenticação
- `POST /api/auth/login` - Login com email e senha (retorna dados do usuário)
- `POST /api/auth/register` - Cadastro de novo usuário (retorna dados do usuário)
- *Nota:* Login como convidado é gerado localmente pelo aplicativo e não exige `/api/auth/guest`.
- `POST /api/auth/logout` - Logout (se suportado pelo backend)

### Músicas
- `GET /api/tracks?page=1&pageSize=20` - Listar músicas
- `GET /api/tracks/{id}` - Detalhes da música
- `GET /api/tracks/search?q=query` - Buscar músicas
- `POST /api/tracks/{id}/favorite` - Toggle favorito

### Listen Together
- `POST /api/rooms/create` - Criar sala
- `POST /api/rooms/{id}/join` - Entrar na sala
- `POST /api/rooms/{id}/leave` - Sair da sala
- `GET /api/rooms` - Listar salas ativas

### WebSocket

O WebSocket usa mensagens JSON com o seguinte formato:

```json
{
  "type": "join|play|pause|seek|track_change",
  "room": "roomId",
  "position": 12345,
  "timestamp": "2025-01-01T00:00:00Z"
}
```

## 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS
- ⚠️ Web (limitações no just_audio)
- ⚠️ Windows/Linux/macOS (requer configuração adicional)

## 🎨 Design

O aplicativo segue o design do Spotify com:
- Tema escuro predominante
- Verde Spotify (#1DB954) como cor primária
- Tipografia clara e legível
- Cards com bordas arredondadas
- Animações suaves

## 🔐 Segurança

- Autenticação simplificada: o app armazena localmente `userId` e `nickname` (quando aplicável) usando `flutter_secure_storage`.
- O modo convidado (guest) é gerado localmente e não requer chamada ao backend.
- O `ApiService` usa um fluxo sem autenticação por header localmente; o interceptor não anexa cabeçalhos de autorização por padrão.
- Tratamento de sessões expiradas (401) é tratado pelo `ApiService`, que pode redirecionar para a tela de login quando aplicável.
- Validação de inputs no cliente

## 📝 Padrão de Código

- **Controllers**: Gerenciam estado e lógica de negócio
- **Repositories**: Fazem requisições HTTP
- **Services**: Serviços compartilhados (audio, storage, etc)
- **Bindings**: Injeção de dependências do GetX
- **Pages**: Views/UI
- **Widgets**: Componentes reutilizáveis

### Uso de `dynamic`

Conforme requisitado, o projeto usa `dynamic` para respostas da API:

```dart
Future<dynamic> getTracks() async {
  final response = await _apiService.get('/tracks');
  // response é Map<String, dynamic> ou List<dynamic>
  return response;
}
```

## 🧪 Testes

```bash
# Testes unitários
flutter test

# Testes de widget
flutter test test/widget_test.dart
```

## 📦 Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🐛 Problemas Conhecidos

- O backend precisa ser implementado separadamente
- WebSocket requer servidor compatível
- just_audio tem limitações no Web
- Modo offline não implementado

## 📚 Próximos Passos

1. ✅ Implementar módulos restantes (home, search, player, listen_together)
2. ✅ Criar rotas e navegação completa
3. ✅ Implementar player bottom sheet arrastável
4. ✅ Sincronização completa do Listen Together
5. ⚠️ Testes unitários e de integração
6. ⚠️ Documentação da API
7. ⚠️ CI/CD com GitHub Actions

## 👥 Contribuição

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 🔗 Links Úteis

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [just_audio Documentation](https://pub.dev/packages/just_audio)
- [Dio Documentation](https://pub.dev/packages/dio)

## 📧 Contato

Matheus Silva - [@Matheus-Silva02](https://github.com/Matheus-Silva02)

---

Desenvolvido com ❤️ usando Flutter e GetX
