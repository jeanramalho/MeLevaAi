# 🧪 Testes - MeLevaAi

**Versão:** 1.0  
**Data:** Janeiro 2025  
**Desenvolvedor:** Jean Ramalho  
**Projeto:** Aplicativo iOS de Caronas Compartilhadas

---

## 📖 Sumário Executivo

Este documento apresenta a estrutura de testes implementada no projeto MeLevaAi, incluindo testes unitários, testes de integração e testes de interface do usuário. A estratégia de testes visa garantir qualidade, confiabilidade e manutenibilidade do código.

### Objetivos dos Testes
- Garantir qualidade e confiabilidade do código
- Facilitar refatoração e manutenção
- Documentar comportamento esperado das funcionalidades
- Detectar regressões durante desenvolvimento
- Melhorar cobertura de código

---

## 🏗️ Estrutura de Testes

### Organização dos Arquivos
```
MeLevaAiTests/
├── MeLevaAiTests.swift          # Testes principais
├── RequestsViewModelTests.swift  # Testes do ViewModel de requisições
├── UserRequestModelTests.swift   # Testes do modelo de requisição
├── DriverTests.swift            # Testes do modelo Driver
├── AuthenticationTests.swift     # Testes de autenticação
├── ExtensionsTests.swift        # Testes das extensões
├── TestHelpers.swift            # Helpers e utilitários de teste
└── TestConfiguration.swift     # Configuração de testes

MeLevaAiUITests/
├── MeLevaAiUITests.swift        # Testes de UI principais
└── LoginUITests.swift          # Testes específicos de login
```

---

## 🔬 Tipos de Testes

### 1. Testes Unitários

#### RequestsViewModelTests
Testa a lógica de negócio do ViewModel de requisições:

```swift
func testValidateEmailWithValidEmail() throws {
    // Given
    let validEmail = "test@email.com"
    
    // When
    let isValid = viewModel.validateEmail(validEmail)
    
    // Then
    XCTAssertTrue(isValid, "Email válido deve retornar true")
}
```

**Cobertura:**
- Validação de email
- Cálculo de distâncias
- Verificação de proximidade
- Gestão de estado
- Performance de operações

#### UserRequestModelTests
Testa o modelo de dados de requisição:

```swift
func testCoordinateConversionWithValidValues() throws {
    // Given
    let userRequest = UserRequestModel(...)
    
    // When
    let coordinate = userRequest.coordinate
    
    // Then
    XCTAssertNotNil(coordinate, "Coordenada deve ser válida")
}
```

**Cobertura:**
- Inicialização de modelos
- Conversão de coordenadas
- Validação de estados
- Edge cases
- Performance

#### DriverTests
Testa o modelo Driver:

```swift
func testDriverInitializationWithCoordinate() throws {
    // Given
    let coordinate = CLLocationCoordinate2D(...)
    
    // When
    let driver = Driver(email: email, nome: nome, coordinate: coordinate)
    
    // Then
    XCTAssertEqual(driver.email, email)
    XCTAssertNotNil(driver.coordinate)
}
```

**Cobertura:**
- Inicialização com coordenadas
- Inicialização com dicionário
- Conversão para dicionário
- Validação de dados
- Performance

### 2. Testes de Integração

#### AuthenticationTests
Testa validações e sanitização de dados:

```swift
func testEmailValidationWithValidEmails() throws {
    let validEmails = ["test@email.com", "user.name@domain.co.uk"]
    
    for email in validEmails {
        let isValid = isValidEmail(email)
        XCTAssertTrue(isValid, "Email '\(email)' deve ser válido")
    }
}
```

**Cobertura:**
- Validação de email
- Validação de senha
- Validação de nome
- Sanitização de dados
- Performance

### 3. Testes de Interface (UI)

#### LoginUITests
Testa a interface de login:

```swift
func testLoginScreenElementsExist() throws {
    XCTAssertTrue(app.textFields["emailTextField"].exists)
    XCTAssertTrue(app.secureTextFields["passwordTextField"].exists)
    XCTAssertTrue(app.buttons["loginButton"].exists)
}
```

**Cobertura:**
- Existência de elementos
- Interação com campos
- Navegação entre telas
- Validação de formulários
- Acessibilidade
- Orientação de tela

---

## 🛠️ Ferramentas e Bibliotecas

### Frameworks Utilizados
- **XCTest**: Framework nativo de testes do iOS
- **XCUITest**: Framework para testes de interface
- **Firebase**: Para testes de integração (quando necessário)

### Helpers e Utilitários

#### TestHelpers
```swift
class TestHelpers {
    static func createMockUser() -> User { ... }
    static func createMockDriver() -> Driver { ... }
    static func createMockUserRequest() -> UserRequestModel { ... }
}
```

#### TestConfiguration
```swift
class TestConfiguration: XCTestCase {
    static func configureFirebaseForTesting() { ... }
}
```

#### TestDataFactory
```swift
class TestDataFactory {
    static func createTestUser(isDriver: Bool = false) -> User { ... }
    static func createTestDriver() -> Driver { ... }
}
```

---

## 📊 Métricas de Qualidade

### Cobertura de Código
- **Meta**: > 80% de cobertura
- **Foco**: ViewModels, Models e Services
- **Ferramenta**: Xcode Code Coverage

### Tipos de Testes por Cobertura
- **Unitários**: 70% da cobertura total
- **Integração**: 20% da cobertura total
- **UI**: 10% da cobertura total

### Métricas de Performance
- **Tempo de Execução**: < 30 segundos para suite completa
- **Testes Unitários**: < 5 segundos
- **Testes de Integração**: < 15 segundos
- **Testes de UI**: < 10 segundos

---

## 🚀 Execução dos Testes

### Comandos de Terminal
```bash
# Executar todos os testes
xcodebuild test -project MeLevaAi.xcodeproj -scheme MeLevaAi -destination 'platform=iOS Simulator,name=iPhone 14'

# Executar apenas testes unitários
xcodebuild test -project MeLevaAi.xcodeproj -scheme MeLevaAi -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:MeLevaAiTests

# Executar apenas testes de UI
xcodebuild test -project MeLevaAi.xcodeproj -scheme MeLevaAi -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:MeLevaAiUITests
```

### Execução no Xcode
1. **Cmd + U**: Executar todos os testes
2. **Cmd + Shift + U**: Executar testes com interface
3. **Cmd + Option + U**: Executar testes selecionados

---

## 📋 Checklist de Testes

### ✅ Testes Implementados
- [x] Testes unitários para ViewModels
- [x] Testes unitários para Models
- [x] Testes de validação de dados
- [x] Testes de extensões
- [x] Testes básicos de UI
- [x] Testes de performance
- [x] Helpers e utilitários de teste
- [x] Configuração de ambiente de teste

### 🔄 Em Desenvolvimento
- [ ] Testes de integração com Firebase
- [ ] Testes de mock para serviços externos
- [ ] Testes de acessibilidade completos
- [ ] Testes de diferentes dispositivos

### 📅 Próximas Etapas
- [ ] Integração com CI/CD
- [ ] Testes automatizados
- [ ] Relatórios de cobertura
- [ ] Testes de carga

---

## 🎯 Boas Práticas

### Estrutura AAA (Arrange, Act, Assert)
```swift
func testExample() throws {
    // Arrange (Given)
    let input = "test@email.com"
    
    // Act (When)
    let result = validateEmail(input)
    
    // Assert (Then)
    XCTAssertTrue(result)
}
```

### Nomenclatura Descritiva
- **Métodos**: `test[NomeDoComportamento]With[Condição]`
- **Variáveis**: Nomes descritivos e claros
- **Comentários**: Explicar o "porquê", não o "o que"

### Isolamento de Testes
- Cada teste deve ser independente
- Usar `setUp()` e `tearDown()` adequadamente
- Evitar dependências entre testes

### Dados de Teste
- Usar dados realistas mas não sensíveis
- Criar factories para dados complexos
- Usar constantes para valores repetidos

---

## 🔧 Configuração e Setup

### Pré-requisitos
- Xcode 14+
- iOS Simulator
- Projeto MeLevaAi configurado

### Configuração Inicial
1. Abrir projeto no Xcode
2. Selecionar scheme de teste
3. Executar testes para verificar configuração
4. Configurar Firebase para testes (se necessário)

### Ambiente de Teste
- **Simulador**: iPhone 14 (padrão)
- **iOS Version**: 16.0+
- **Orientação**: Portrait (padrão)
- **Idioma**: Português (Brasil)

---

## 📈 Relatórios e Métricas

### Relatórios Gerados
- **Cobertura de Código**: Relatório detalhado por arquivo
- **Performance**: Tempo de execução por teste
- **Falhas**: Log detalhado de erros
- **Sucesso**: Estatísticas de testes passando

### Métricas Importantes
- **Taxa de Sucesso**: > 95%
- **Cobertura de Código**: > 80%
- **Tempo de Execução**: < 30 segundos
- **Testes por Funcionalidade**: Mínimo 3 testes

---

## 🐛 Troubleshooting

### Problemas Comuns

#### Testes Falhando
- Verificar configuração do projeto
- Validar dependências
- Checar dados de teste

#### Performance Lenta
- Otimizar dados de teste
- Usar mocks quando apropriado
- Executar testes em paralelo

#### Cobertura Baixa
- Adicionar testes para edge cases
- Testar métodos privados indiretamente
- Focar em lógica de negócio

---

## 📚 Referências

### Documentação
- [XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [XCUITest Documentation](https://developer.apple.com/documentation/xcuitest)
- [Testing with Xcode](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/)

### Padrões e Práticas
- **AAA Pattern**: Arrange, Act, Assert
- **FIRST Principles**: Fast, Independent, Repeatable, Self-validating, Timely
- **Test Pyramid**: Unit > Integration > UI

---

**Documento elaborado por:** Jean Ramalho  
**Data de criação:** Janeiro 2025  
**Próxima revisão:** Conforme evolução dos testes
