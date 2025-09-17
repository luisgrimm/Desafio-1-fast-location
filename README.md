# FastLocation

FastLocation é um aplicativo Flutter que permite consultar endereços pelo CEP e buscar CEPs por endereços, utilizando a API pública do ViaCEP. O app possui gerenciamento de estado com MobX e armazenamento local com Hive.

## Funcionalidades

- 🔍 **Consulta por CEP**: Digite um CEP e obtenha o endereço completo
- 📍 **Busca por Endereço**: Encontre CEPs através de cidade, estado e logradouro
- 📋 **Histórico**: Visualize todas as consultas realizadas
- 💾 **Armazenamento Local**: Dados salvos automaticamente usando Hive
- 🗺️ **Integração com Mapas**: Visualize endereços no mapa ou trace rotas
- 🎨 **Interface Moderna**: Design Material 3 com temas claro e escuro
- 📱 **Responsivo**: Otimizado para dispositivos Android e iOS

## Arquitetura

O projeto segue uma arquitetura modular com as seguintes camadas:

```
lib/
├── src/
│   ├── shared/           # Componentes compartilhados
│   │   ├── colors/       # Cores do app
│   │   ├── components/   # Widgets reutilizáveis
│   │   ├── metrics/      # Constantes de espaçamento
│   │   └── storage/      # Configuração do Hive
│   ├── routes/           # Definição de rotas
│   ├── http/             # Configuração do Dio
│   └── modules/          # Módulos do app
│       ├── initial/      # Tela de abertura
│       ├── home/         # Tela principal
│       │   ├── components/
│       │   ├── controller/
│       │   ├── model/
│       │   ├── repositories/
│       │   ├── service/
│       │   └── page/
│       └── history/      # Histórico de consultas
│           ├── controller/
│           └── page/
├── main.dart
└── theme.dart
```

## Tecnologias Utilizadas

- **Flutter**: Framework principal
- **MobX**: Gerenciamento de estado reativo
- **Hive**: Banco de dados local NoSQL
- **Dio**: Cliente HTTP para API calls
- **Map Launcher**: Integração com aplicativos de mapas
- **Geocoding**: Conversão de endereços em coordenadas
- **Material Design 3**: Sistema de design

## Pré-requisitos

- Flutter SDK 3.6.0 ou superior
- Dart SDK 3.6.0 ou superior
- Android Studio / Xcode (para desenvolvimento)
- Device/Emulador Android ou iOS

## Instalação

1. **Clone o repositório**:
   ```bash
   git clone <repository-url>
   cd fastlocation
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Gere os arquivos de código automatizados**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## Execução

### Debug Mode
```bash
flutter run
```

### Release Mode
```bash
flutter run --release
```

### Executar em dispositivo específico
```bash
flutter devices  # Lista dispositivos disponíveis
flutter run -d <device-id>
```

## Estrutura de Dependências

### Dependências Principais
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.1.0
  dio: ^5.0.0
  flutter_mobx: ^2.0.0
  mobx: ^2.0.0
  hive: ^4.0.0
  hive_flutter: ^2.0.0
  path_provider: ^2.0.0
  map_launcher: ^4.0.0
  geocoding: ^4.0.0
```

### Dependências de Desenvolvimento
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  flutter_launcher_icons: ^0.13.1
  mobx_codegen: ^2.0.0
  build_runner: ^2.0.0
  hive_generator: ^2.0.0
```

## Funcionalidades Detalhadas

### 1. Consulta por CEP
- Digite um CEP de 8 dígitos
- Validação automática do formato
- Exibição de endereço completo
- Salvamento automático no histórico

### 2. Busca por Endereço
- Campos para cidade, estado (UF) e logradouro
- Retorna lista de CEPs encontrados
- Seleção de resultado específico
- Salvamento automático no histórico

### 3. Histórico de Consultas
- Lista cronológica de consultas
- Agrupamento por data
- Opção de exclusão individual
- Limpeza completa do histórico

### 4. Integração com Mapas
- Visualização no mapa padrão do sistema
- Direções/rotas para o endereço
- Suporte a múltiplos apps de mapas

## API Utilizada

O app utiliza a **API ViaCEP** (https://viacep.com.br/), que é gratuita e não requer autenticação:

- **Consulta por CEP**: `GET https://viacep.com.br/ws/{cep}/json/`
- **Busca por endereço**: `GET https://viacep.com.br/ws/{uf}/{cidade}/{logradouro}/json/`

## Tratamento de Erros

- Validação de entrada (CEP, campos obrigatórios)
- Timeout de conexão configurado
- Mensagens de erro user-friendly
- Estados de loading e erro bem definidos
- Retry automático em falhas de rede

## Armazenamento Local

O app utiliza **Hive** para persistência local:
- Histórico de consultas automático
- Dados offline disponíveis
- Performance otimizada
- Sincronização automática

## Build para Produção

### Android
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Permissões

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Este app precisa de acesso à localização para fornecer direções.</string>
```

## Troubleshooting

### Problemas Comuns

1. **Erro de build_runner**:
   ```bash
   flutter packages pub run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Erro de dependências**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Problemas com Hive**:
   ```bash
   # Limpar dados do app no dispositivo/emulador
   flutter run --hot-restart
   ```


**FastLocation** - Encontre endereços rapidamente! 📍
