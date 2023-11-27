![EconoLista Logo](https://github.com/miguelhp373/econolista-mobile-app/blob/main/.github/brading_logo.png)
# EconoLista - Organize suas Compras

## Sobre 📖

O projeto EconoLista tem como objetivo proporcionar uma experiência eficiente e organizada para o controle de suas compras. Desenvolvido para facilitar a gestão de gastos, o aplicativo permite escanear produtos, inserir preços e quantidades, além de oferecer funcionalidades como listas prévias e histórico de compras.

---

## Tecnologias Utilizadas 🚀

- ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
- ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
- ![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)

---

## Como Rodar na Máquina 🤔

### Passos Iniciais:

```bash
# Clone este repositório:
git clone https://github.com/miguelhp373/econolista-mobile-app

# Entre no diretório:
cd econolista-app
```

### Instale as Dependências:

```bash
# Instale as dependências:
flutter pub get
```

### Configuração do Arquivo `.env`:

**Crie um arquivo `.env` na raiz do projeto com os seguintes dados:**
```plaintext
FIREBASE_ANDROID_API_KEY=SUA_CHAVE_DE_API_ANDROID
FIREBASE_IOS_API_KEY=SUA_CHAVE_DE_API_IOS
API_END_POINT='api.cosmos.bluesoft.com.br'
API_KEY_COSMOS_BLUESOFT=SUA_CHAVE_COSMOS_BLUESOFT
```

### Inicie o Aplicativo:

```bash
# Inicie o aplicativo com as variáveis de ambiente:
flutter run --dart-define-from-file=.env
```

---

## Configuração do Visual Studio Code 🚧

Para rodar o aplicativo no Visual Studio Code, adicione o seguinte arquivo `launch.json` à sua aplicação:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "econolista_app",
            "request": "launch",
            "type": "dart",
            "toolArgs": [
                "--dart-define-from-file=.env"
            ]
        },
        {
            "name": "econolista_app (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile",
            "toolArgs": [                
                "--dart-define-from-file=.env"
            ]  
        },
        {
            "name": "econolista_app (release mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release",
            "toolArgs": [               
                "--dart-define-from-file=.env"
            ]
        }
    ]
}
```

---

## Build da Aplicação 🏗️

Para construir a aplicação, utilize o seguinte comando:

```bash
flutter build apk --split-per-abi --dart-define-from-file=.env
```

---

## Estrutura das Collections Firestore:

### [user_collection]:

```json
[
    {
        "__id__": "ID_DO_USUARIO_1",
        "userDateTimeCreated": "DATA_HORA_CRIACAO",
        "userEmail": "EMAIL_DO_USUARIO_1",
        "userName": "NOME_DO_USUARIO_1",
        "userStoreCollection": {
            "0": {
                "storeName": "NOME_DA_LOJA_1"
            }
        }
    },
    {
        "__id__": "ID_DO_USUARIO_2",
        "userDateTimeCreated": "DATA_HORA_CRIACAO",
        "userEmail": "EMAIL_DO_USUARIO_2",
        "userName": "NOME_DO_USUARIO_2",
        "userStoreCollection": {
            "0": {
                "storeName": "NOME_DA_LOJA_2"
            }
        }
    },
    {
        "__id__": "ID_DO_USUARIO_3",
        "userDateTimeCreated": "DATA_HORA_CRIACAO",
        "userEmail": "EMAIL_DO_USUARIO_3",
        "userName": "NOME_DO_USUARIO_3",
        "userStoreCollection": {}
    }
]
```

### [shopping_list_collection]:

```json
[
    {
        "DateTimeCreated": "TIMESTAMP_DA_COMPRA_1",
        "Description": "DESCRICAO_DA_COMPRA_1",
        "MarketName": "NOME_DA_LOJA_1",
        "ProductsList": {
            "0": {
                "id": "0",
                "productBarcode": "CODIGO_DE_BARRAS_1",
                "productDescription": "DESCRICAO_DO_PRODUTO_1",
                "productId": "",
                "productName": "NOME_DO_PRODUTO_1",
                "productPhotoUrl": "URL_DA_IMAGEM_DO_PRODUTO_1",
                "productPrice": "PRECO_DO_PRODUTO_1",
                "productQuantity": "QUANTIDADE_DO_PRODUTO_1"
            },
            "1": {
                "id": "1",
                "productBarcode": "CODIGO_DE_BARRAS_2",
                "productDescription": "DESCRICAO_DO_PRODUTO_2",
                "productId": "",
                "productName": "NOME_DO_PRODUTO_2",
                "productPhotoUrl": "URL_DA_IMAGEM_DO_PRODUTO_2",
                "productPrice": "PRECO_DO_PRODUTO_2",
                "productQuantity": "QUANTIDADE_DO_PRODUTO_2"
            }
        },
        "ScheduledPurchase": false,
        "Status": "Aberta",
        "__id__": "ID_DA_COMPRA_1",
        "userEmail": "EMAIL_DO_USUARIO_1"
    },
    {
        "DateTimeCreated": "TIMESTAMP_DA_COMPRA_2",
        "Description": "DESCRICAO_DA_COMPRA_2",
        "MarketName": "NOME_DA_LOJA_2",
        "ProductsList": {
            "0": {
                "id": "0",
                "productBarcode": "CODIGO_DE_BARRAS_3",
                "productDescription": "DESCRICAO_DO_PRODUTO_3",
                "productId": "",
                "productName": "NOME_DO_PRODUTO_3",
                "productPhotoUrl": "URL_DA_IMAGEM_DO_PRODUTO_3",
                "productPrice": "PRECO_DO_PRODUTO_3",
                "productQuantity": "QUANTIDADE_DO_PRODUTO_3"
            }
        },
        "ScheduledPurchase": false,
        "Status": "Aberta",
        "__id__": "ID_DA_COMPRA_2",
        "userEmail": "EMAIL_DO_USUARIO_2"
    }
]
```

---

## Licença 📝

Este projeto está licenciado sob a Licença MIT - consulte o arquivo [LICENÇA](LICENSE) para obter detalhes.
