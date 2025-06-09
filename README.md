# 🚗 MeLevaAí

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org) [![iOS](https://img.shields.io/badge/iOS-17-blue.svg)](https://developer.apple.com/ios) [![MVVM](https://img.shields.io/badge/Architecture-MVVM-purple.svg)](#architecture) [![Firebase](https://img.shields.io/badge/Firebase-Realtime%20DB-yellow.svg)](https://firebase.google.com)

> **MeLevaAí** é um aplicativo iOS de caronas remuneradas, desenvolvido com Swift e ViewCode, utilizando arquitetura MVVM e Firebase Realtime Database.  

---
<div align="center">
  <img src="https://github.com/user-attachments/assets/92280d18-4dc1-47d5-9fed-cac1dae29da7" width="200"/>
  <img src="https://github.com/user-attachments/assets/c06e7b5f-00fb-4ecb-bef0-d6c0306b791f" width="200"/>
  <img src="https://github.com/user-attachments/assets/d48a865e-4efa-4fbb-8179-bc9d2fc57b38" width="200"/>
  <br/>
  <img src="https://github.com/user-attachments/assets/ba3cb762-95c2-4469-bc79-2610ad3b5a1d" width="200"/>
  <img src="https://github.com/user-attachments/assets/472e88d8-8e29-4839-8bfa-58975f4427bf" width="200"/>
  <img src="https://github.com/user-attachments/assets/4972991e-196d-4172-9dfb-e16cc9e48c9a" width="200"/>
</div>
---



## 📚 Sumário

- [Sobre](#sobre)  
- [Arquitetura](#arquitetura)  
- [Principais Funcionalidades](#principais-funcionalidades)  
- [Tecnologias e Ferramentas](#tecnologias-e-ferramentas)  
- [Estrutura de Pastas](#estrutura-de-pastas)  
- [Instalação & Uso](#instalação--uso)  
- [Próximos Passos](#próximos-passos)  
- [Contato](#contato)  

---

## 🔍 Sobre

O **MeLevaAí** conecta passageiros que buscam caronas remuneradas a motoristas dispostos a oferecerem trajetos.  
- **Passageiros**: solicitam carona informando sua localização e acompanham o status.  
- **Motoristas**: visualizam requisições em tempo real, aceitam, iniciam a rota e compartilham sua posição até o destino.

---

## 🏛️ Arquitetura

Este projeto segue o padrão **MVVM** (Model-View-ViewModel) para garantir **separação de responsabilidades**, **testabilidade** e **manutenibilidade**:
- **Model**: estruturas de dados (`Driver`, `UserRequestModel`, `User`).  
- **View**: componentes de interface em ViewCode (`DriverView`, `RouteView`, células customizadas).  
- **ViewModel**: lógica de negócio e comunicação com Firebase (`RequestsViewModel`, `LocationViewModel`).  
- **Service**: abstrações de backend (`Requests`, `Authentication`).

---

## 🚀 Principais Funcionalidades

1. **Solicitação de Carona**  
   - Passageiro envia requisição com e-mail, nome e geolocalização.  
   - DriverViewModel publica em `/requisicoes` no Firebase.  

2. **Listagem em Tempo Real**  
   - Motorista recebe notificações de novas solicitações com `.observe(.childAdded)`.  
   - Distância até o passageiro calculada pelo `CLLocationManager`.

3. **Aceitar Carona & Rota**  
   - Ao aceitar, a requisição é removida de `/requisicoes` e criada em `/viagens`.  
   - `RouteViewController` desenha rota inicial via `MKDirections`.  

4. **Compartilhamento de Localização**  
   - Motorista envia updates da sua posição em `/viagens/<id>/motorista`.  
   - Passageiro pode observar em tempo real em outra tela de tracking.

---

## 🧰 Tecnologias e Ferramentas

| Categoria             | Ferramenta / Biblioteca                  |
|-----------------------|------------------------------------------|
| Linguagem             | Swift 5.9                                |
| Plataforma            | iOS 17                                   |
| Gerenciamento de UI   | ViewCode (AutoLayout programático)      |
| Arquitetura           | MVVM                                     |
| Backend / Persistência| Firebase Realtime Database               |
| Mapa & Rota           | MapKit (MKMapView, MKDirections)         |
| Autenticação          | Firebase Authentication                  |

---

## 📁 Estrutura de Pastas

```
MeLevaAi/
├─ Controllers/
│   ├─ DriverViewController.swift
│   ├─ PessengerViewController.swift
│   ├─ RouteViewController.swift
│   └─ …
├─ ViewModel/
│   ├─ RequestsViewModel.swift
│   └─ LocationViewModel.swift  
├─ Service/
│   ├─ Authentication.swift
│   └─ Requests.swift  
├─ Model/
│   ├─ Driver.swift
│   ├─ User.swift
│   └─ UserRequestModel.swift  
├─ View/
│   ├─ DriverView.swift
│   ├─ RouteView.swift
│   └─ RequestTableViewCell/
│       └─ RequestTableViewCell.swift  
├─ Resources/
│   ├─ Colors.swift
│   └─ …  
├─ AppDelegate.swift
└─ SceneDelegate.swift
```

---

## ⚙️ Instalação & Uso

1. **Clone o repositório**  
   ```bash
   git clone https://github.com/jeanramalho/MeLevaAi.git
   cd MeLevaAi
   ```

2. **Instale as dependências**  
   - Abra `MeLevaAi.xcodeproj` no Xcode (sem CocoaPods ou SPM adicional).  
   - Verifique seu `GoogleService-Info.plist` na pasta raiz.  

3. **Configurar Firebase**  
   - Crie um projeto no Firebase Console.  
   - Ative **Authentication** (e-mail/senha) e **Realtime Database** (modo protegido).  
   - Substitua o `GoogleService-Info.plist` pelo do seu projeto.  

4. **Execute no Simulador ou Dispositivo**  
   - Se necessário, ajuste permissões de localização em `Info.plist`:  
     ```xml
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>Precisamos de acesso à sua localização para oferecer caronas.</string>
     ```
   - Build & Run (⌘R)

---

## 🛠️ Próximos Passos

- 🔒 **Regras de Segurança** no Realtime Database  
- 📈 **Analítica** de uso (Firebase Analytics)  
- 💳 **Integração de Pagamentos** para transações de carona  
- 🎨 **Personalização de Tema** e Dark Mode  
- ⚙️ **Testes Unitários** e UI Tests

---

## ✉️ Contato

Se tiver dúvidas ou quiser colaborar, fique à vontade para entrar em contato:

- ✉️ jeanramalho.dev@gmail.com  
- 🔗 [LinkedIn](https://www.linkedin.com/in/jean-ramalho/)  

---

> Desenvolvido com ❤ por Jean Ramalho  
