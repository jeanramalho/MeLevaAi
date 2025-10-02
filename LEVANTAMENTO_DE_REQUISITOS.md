# 📋 Levantamento de Requisitos - MeLevaAi

**Versão:** 1.0  
**Data:** Janeiro 2025  
**Desenvolvedor:** Jean Ramalho  
**Projeto:** Aplicativo iOS de Caronas Compartilhadas

---

## 📖 Sumário Executivo

O MeLevaAi é uma aplicação móvel iOS desenvolvida para conectar passageiros e motoristas através de um sistema de caronas compartilhadas. O projeto visa facilitar o transporte urbano oferecendo uma alternativa prática e segura para deslocamentos diários, com interface intuitiva e funcionalidades em tempo real.

### Objetivos do Projeto
- Conectar passageiros que precisam de transporte com motoristas disponíveis
- Fornecer interface nativa e responsiva para ambas as personas
- Implementar sistema de localização em tempo real para melhor experiência
- Garantir segurança através de autenticação robusta e validação de dados

---

## 🎯 Requisitos Funcionais

### RF01 - Sistema de Autenticação
**Descrição:** O sistema deve permitir cadastro e login de usuários com diferenciação entre passageiros e motoristas.

**Critérios de Aceitação:**
- Usuário pode se cadastrar com nome, sobrenome, email e senha
- Sistema diferencia automaticamente entre passageiro e motorista
- Validação de email e senha com mínimo de 6 caracteres
- Login seguro com Firebase Authentication
- Persistência de sessão entre aberturas do app
- Logout seguro com limpeza de dados sensíveis

**Prioridade:** Alta  
**Complexidade:** Média

### RF02 - Gestão de Perfil de Usuário
**Descrição:** Usuários devem ter perfis distintos baseados em seu tipo (passageiro/motorista).

**Critérios de Aceitação:**
- Perfil de passageiro: visualização de corridas solicitadas
- Perfil de motorista: visualização de corridas disponíveis e histórico
- Dados pessoais armazenados de forma segura
- Possibilidade de alternar entre tipos de usuário durante cadastro

**Prioridade:** Alta  
**Complexidade:** Baixa

### RF03 - Solicitação de Caronas (Passageiro)
**Descrição:** Passageiros devem poder solicitar caronas informando destino e localização atual.

**Critérios de Aceitação:**
- Detecção automática da localização atual do passageiro
- Campo para inserção de endereço de destino
- Validação e geocodificação do endereço de destino
- Confirmação do endereço antes de enviar solicitação
- Possibilidade de cancelar solicitação antes da aceitação
- Status visual da solicitação (pendente, aceita, em andamento)

**Prioridade:** Alta  
**Complexidade:** Alta

### RF04 - Visualização de Solicitações (Motorista)
**Descrição:** Motoristas devem visualizar solicitações de caronas disponíveis com informações relevantes.

**Critérios de Aceitação:**
- Lista de solicitações pendentes em formato de tabela
- Exibição do nome do passageiro
- Cálculo e exibição da distância até o passageiro
- Status visual das solicitações (pendente, aceita, em andamento)
- Atualização em tempo real da lista
- Possibilidade de selecionar solicitação para aceitar

**Prioridade:** Alta  
**Complexidade:** Média

### RF05 - Sistema de Localização e Mapas
**Descrição:** O sistema deve utilizar serviços de localização e mapas para navegação e visualização.

**Critérios de Aceitação:**
- Detecção precisa da localização atual do usuário
- Visualização de mapas com MapKit
- Anotações para mostrar posição de passageiros e motoristas
- Integração com Apple Maps para navegação
- Cálculo de distâncias em tempo real
- Atualização contínua de localização durante corridas

**Prioridade:** Alta  
**Complexidade:** Alta

### RF06 - Gestão de Estados de Corrida
**Descrição:** O sistema deve gerenciar diferentes estados das corridas desde solicitação até conclusão.

**Critérios de Aceitação:**
- Estado "Pendente": Aguardando aceitação do motorista
- Estado "Aceita": Motorista a caminho do passageiro
- Estado "Em Andamento": Corrida em progresso
- Estado "Concluída": Corrida finalizada e salva no histórico
- Transições automáticas entre estados
- Notificações visuais para mudanças de estado

**Prioridade:** Alta  
**Complexidade:** Média

### RF07 - Sistema de Navegação
**Descrição:** Motoristas devem ter acesso à navegação integrada para chegar ao passageiro e ao destino.

**Critérios de Aceitação:**
- Abertura automática do Apple Maps com rota para o passageiro
- Abertura automática do Apple Maps com rota para o destino
- Geocodificação reversa para obter endereços das coordenadas
- Opções de navegação configuradas para direção

**Prioridade:** Média  
**Complexidade:** Média

### RF08 - Histórico de Corridas
**Descrição:** Motoristas devem ter acesso ao histórico de corridas concluídas.

**Critérios de Aceitação:**
- Armazenamento de dados da corrida concluída
- Informações: nome do passageiro, origem, destino, data/hora
- Persistência dos dados no Firebase
- Organização cronológica das corridas

**Prioridade:** Baixa  
**Complexidade:** Baixa

---

## 🔒 Requisitos Não Funcionais

### RNF01 - Performance
**Descrição:** O aplicativo deve responder rapidamente às ações do usuário.

**Critérios de Aceitação:**
- Tempo de resposta da interface < 200ms
- Atualização de localização a cada 10 segundos
- Carregamento de dados do Firebase < 2 segundos
- Interface responsiva durante operações de rede

**Prioridade:** Alta  
**Complexidade:** Média

### RNF02 - Segurança
**Descrição:** Dados sensíveis devem ser protegidos e autenticação deve ser robusta.

**Critérios de Aceitação:**
- Autenticação através do Firebase Auth
- Validação de dados de entrada
- Tratamento seguro de senhas
- Proteção contra ataques de injeção
- Dados armazenados de forma criptografada

**Prioridade:** Alta  
**Complexidade:** Média

### RNF03 - Usabilidade
**Descrição:** Interface deve ser intuitiva e fácil de usar para ambos os tipos de usuário.

**Critérios de Aceitação:**
- Design seguindo guidelines do iOS
- Navegação intuitiva entre telas
- Feedback visual para todas as ações
- Tratamento de erros com mensagens claras
- Suporte a diferentes tamanhos de tela

**Prioridade:** Alta  
**Complexidade:** Média

### RNF04 - Disponibilidade
**Descrição:** O sistema deve estar disponível para uso durante horários de funcionamento.

**Critérios de Aceitação:**
- Uptime de 99% durante horário comercial
- Recuperação automática de falhas de rede
- Sincronização de dados quando conexão for restabelecida
- Tratamento graceful de erros de conectividade

**Prioridade:** Média  
**Complexidade:** Alta

### RNF05 - Escalabilidade
**Descrição:** O sistema deve suportar crescimento no número de usuários e corridas.

**Critérios de Aceitação:**
- Suporte a até 1000 usuários simultâneos
- Processamento de até 100 corridas simultâneas
- Arquitetura preparada para expansão
- Otimização de consultas ao banco de dados

**Prioridade:** Média  
**Complexidade:** Alta

---

## 🎨 Requisitos de Interface

### RI01 - Design System
**Descrição:** Aplicação deve seguir um design system consistente.

**Critérios de Aceitação:**
- Paleta de cores definida (amarelo, azul escuro, cinza)
- Tipografia consistente em toda aplicação
- Componentes reutilizáveis (botões, campos de texto, alertas)
- Espaçamentos padronizados
- Ícones e imagens otimizadas

**Prioridade:** Média  
**Complexidade:** Baixa

### RI02 - Responsividade
**Descrição:** Interface deve se adaptar a diferentes tamanhos de tela.

**Critérios de Aceitação:**
- Suporte a iPhone SE até iPhone Pro Max
- Layouts adaptativos com Auto Layout
- Componentes que se ajustam ao conteúdo
- Orientação portrait otimizada

**Prioridade:** Alta  
**Complexidade:** Média

### RI03 - Acessibilidade
**Descrição:** Aplicação deve ser acessível para usuários com necessidades especiais.

**Critérios de Aceitação:**
- Suporte a VoiceOver
- Contraste adequado de cores
- Tamanhos de fonte legíveis
- Navegação por teclado quando aplicável

**Prioridade:** Baixa  
**Complexidade:** Média

---

## 🔧 Requisitos Técnicos

### RT01 - Plataforma
**Descrição:** Desenvolvimento exclusivo para iOS usando tecnologias nativas.

**Critérios de Aceitação:**
- iOS 14.0 ou superior
- Swift 5.7+
- Xcode 14+
- Arquitetura MVVM
- ViewCode para layouts

**Prioridade:** Alta  
**Complexidade:** Baixa

### RT02 - Backend e Dados
**Descrição:** Utilização do Firebase como backend e banco de dados.

**Critérios de Aceitação:**
- Firebase Authentication para autenticação
- Firebase Realtime Database para dados
- Estrutura de dados hierárquica
- Sincronização em tempo real
- Backup automático de dados

**Prioridade:** Alta  
**Complexidade:** Média

### RT03 - Serviços de Localização
**Descrição:** Integração com serviços de localização do iOS.

**Critérios de Aceitação:**
- CoreLocation para detecção de GPS
- MapKit para visualização de mapas
- CLGeocoder para geocodificação
- Permissões adequadas de localização
- Tratamento de erros de localização

**Prioridade:** Alta  
**Complexidade:** Alta

### RT04 - Gerenciamento de Estado
**Descrição:** Gerenciamento eficiente do estado da aplicação.

**Critérios de Aceitação:**
- ViewModels para lógica de negócio
- Observadores para mudanças de estado
- Ciclo de vida adequado dos componentes
- Limpeza de recursos para evitar memory leaks
- Tratamento de estados de erro

**Prioridade:** Alta  
**Complexidade:** Média

---

## 📊 Matriz de Rastreabilidade

| Requisito | Funcionalidade | Prioridade | Status | Responsável |
|-----------|----------------|------------|--------|-------------|
| RF01 | Autenticação | Alta | ✅ Implementado | Jean Ramalho |
| RF02 | Perfil de Usuário | Alta | ✅ Implementado | Jean Ramalho |
| RF03 | Solicitação de Caronas | Alta | ✅ Implementado | Jean Ramalho |
| RF04 | Visualização de Solicitações | Alta | ✅ Implementado | Jean Ramalho |
| RF05 | Localização e Mapas | Alta | ✅ Implementado | Jean Ramalho |
| RF06 | Estados de Corrida | Alta | ✅ Implementado | Jean Ramalho |
| RF07 | Sistema de Navegação | Média | ✅ Implementado | Jean Ramalho |
| RF08 | Histórico de Corridas | Baixa | ✅ Implementado | Jean Ramalho |

---

## 🎯 Critérios de Sucesso

### Funcionalidade
- ✅ Usuários conseguem se cadastrar e fazer login
- ✅ Passageiros conseguem solicitar caronas
- ✅ Motoristas conseguem visualizar e aceitar corridas
- ✅ Sistema de localização funciona corretamente
- ✅ Estados de corrida são gerenciados adequadamente

### Qualidade
- ✅ Interface responsiva e intuitiva
- ✅ Performance adequada para uso diário
- ✅ Tratamento robusto de erros
- ✅ Código bem estruturado e documentado
- ✅ Arquitetura escalável e manutenível

### Usabilidade
- ✅ Fluxo de usuário intuitivo
- ✅ Feedback visual adequado
- ✅ Tempo de aprendizado mínimo
- ✅ Satisfação do usuário alta

---

## 📝 Observações e Considerações

### Limitações Identificadas
- Dependência de conexão com internet para funcionamento
- Necessidade de permissões de localização
- Limitações do Firebase para casos de uso complexos

### Melhorias Futuras
- Sistema de avaliações entre usuários
- Integração com pagamentos
- Notificações push para melhor engajamento
- Sistema de chat entre passageiro e motorista
- Relatórios e analytics de uso

### Riscos e Mitigações
- **Risco:** Falha de conectividade
  - **Mitigação:** Tratamento graceful de erros e sincronização offline
- **Risco:** Problemas de localização
  - **Mitigação:** Fallback para entrada manual de endereços
- **Risco:** Performance com muitos usuários
  - **Mitigação:** Otimização de consultas e paginação de dados

---

**Documento elaborado por:** Jean Ramalho  
**Data de criação:** Janeiro 2025  
**Próxima revisão:** Conforme necessidade do projeto
