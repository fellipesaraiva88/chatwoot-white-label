# Evolution API Integration - Setup Guide

Esta documentação explica como configurar e usar a integração do Auzap com Evolution API para WhatsApp.

## 📋 Índice

- [O que é Evolution API?](#o-que-é-evolution-api)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Como Usar](#como-usar)
- [Sincronização Automática](#sincronização-automática)
- [Troubleshooting](#troubleshooting)
- [API Reference](#api-reference)

---

## O que é Evolution API?

Evolution API é uma API não oficial para WhatsApp que permite integrar o WhatsApp em aplicações empresariais sem depender da API oficial do Meta (WhatsApp Business API).

**Principais características**:
- ✅ Multi-device support
- ✅ Múltiplas instâncias por servidor
- ✅ Webhooks para eventos
- ✅ Suporte a mídias
- ✅ Gerenciamento de grupos
- ✅ Auto-reconnect

---

## Pré-requisitos

### 1. Servidor Evolution API

Você precisa ter um servidor Evolution API rodando. Opções:

**Opção A: Docker (Recomendado)**
```bash
docker run -d \
  --name evolution-api \
  -p 8080:8080 \
  -e AUTHENTICATION_API_KEY=sua-chave-secreta-aqui \
  atendai/evolution-api:latest
```

**Opção B: Instalação Manual**
```bash
git clone https://github.com/EvolutionAPI/evolution-api.git
cd evolution-api
npm install
npm run build
npm start
```

**Documentação oficial**: https://doc.evolution-api.com/

### 2. Auzap com Migration Executada

Execute a migration para criar a tabela `evolution_api_configs`:

```bash
rails db:migrate
```

### 3. Seeds PET (Opcional mas Recomendado)

Para popular seu ambiente com labels, atributos e respostas prontas para o setor PET:

```bash
rails runner db/seeds/pet_sector_setup.rb
```

Ou adicione ao seu `db/seeds.rb`:
```ruby
load Rails.root.join('db', 'seeds', 'pet_sector_setup.rb')
```

E execute:
```bash
rails db:seed
```

---

## Configuração

### Passo 1: Acessar Configurações

1. Faça login como **Administrador**
2. Navegue até: **Configurações** → **Integrações** → **Evolution API**

> **Nota**: Apenas administradores da conta podem configurar o Evolution API.

### Passo 2: Adicionar Configuração

Clique em "Nova Configuração" e preencha:

| Campo | Descrição | Exemplo |
|-------|-----------|---------|
| **API URL** | URL base do seu servidor Evolution API | `https://evolution.suaempresa.com` |
| **API Key** | Chave de autenticação do Evolution | `sua-chave-api-secreta` |
| **Instance Name** | Nome da instância (opcional) | `clinica-principal` |
| **Enabled** | Ativar/desativar esta configuração | ✅ Ativo |
| **Auto Sync** | Sincronização automática de instâncias | ✅ Ativo |

### Passo 3: Testar Conexão

Antes de salvar, clique em **"Testar Conexão"** para verificar:
- ✅ URL está acessível
- ✅ API Key é válida
- ✅ Servidor responde corretamente

Se o teste falhar, verifique:
- URL está correta (com `http://` ou `https://`)
- API Key corresponde à configurada no Evolution
- Firewall/rede permite conexão
- Servidor Evolution está rodando

### Passo 4: Salvar e Sincronizar

1. Clique em **"Salvar"**
2. Após salvar, clique em **"Sincronizar Agora"**
3. O Auzap irá:
   - Buscar todas as instâncias do Evolution
   - Criar inboxes (caixas de entrada) automaticamente
   - Configurar webhooks

---

## Como Usar

### Criar Nova Instância no Evolution

**Via Evolution API Dashboard:**
```
POST https://evolution.suaempresa.com/instance/create
Headers:
  apikey: sua-chave-api

Body:
{
  "instanceName": "clinica-veterinaria",
  "qrcode": true
}
```

**Via curl:**
```bash
curl -X POST https://evolution.suaempresa.com/instance/create \
  -H "apikey: sua-chave-api" \
  -H "Content-Type: application/json" \
  -d '{
    "instanceName": "clinica-veterinaria",
    "qrcode": true
  }'
```

### Sincronizar com Auzap

Após criar instâncias no Evolution:

**Opção 1: Sincronização Manual**
1. Vá em **Configurações** → **Evolution API**
2. Clique em **"Sincronizar Agora"** na configuração desejada

**Opção 2: API (para automação)**
```bash
curl -X POST http://localhost:3000/api/v1/accounts/1/evolution_api_configs/1/sync_now \
  -H "api_access_token: SEU_TOKEN"
```

**Opção 3: Auto-sync (Recomendado)**
- Se "Auto Sync" estiver ativo, a sincronização acontece automaticamente
- Periodicidade configurável (padrão: a cada nova criação de instância)

### Conectar WhatsApp

Após sincronização, uma nova **inbox** será criada no Auzap:
- Nome: `Evolution: [nome-da-instancia]`
- Canal: API Channel
- Configuração Evolution incluída

Para conectar o WhatsApp:
1. Vá em **Configurações** → **Inboxes**
2. Encontre a inbox `Evolution: [nome]`
3. Acesse o Evolution Dashboard
4. Escaneie o QR Code com WhatsApp
5. WhatsApp conectado! ✅

---

## Sincronização Automática

### Como Funciona

Quando "Auto Sync" está ativo:
1. Auzap monitora o Evolution API periodicamente
2. Detecta novas instâncias automaticamente
3. Cria inboxes correspondentes
4. Atualiza status das instâncias existentes
5. Remove inboxes de instâncias deletadas (opcional)

### Configurações de Sync

No modelo `EvolutionApiConfig`, o campo `sync_settings` (JSONB) permite configurações avançadas:

```ruby
evolution_config.update(
  sync_settings: {
    sync_interval: 300, # segundos entre syncs (5 minutos)
    create_inboxes: true, # criar inboxes automaticamente
    update_inboxes: true, # atualizar inboxes existentes
    delete_disconnected: false # deletar inboxes de instâncias desconectadas
  }
)
```

### Logs de Sincronização

Verificar última sincronização:
```ruby
config = EvolutionApiConfig.find(1)
config.last_synced_at # => 2025-11-07 14:30:00
config.last_sync_error # => nil (ou mensagem de erro)
```

---

## Troubleshooting

### Erro: "Evolution API: Unauthorized"
**Causa**: API Key incorreta
**Solução**:
1. Verifique a API Key no Evolution
2. Atualize a configuração no Auzap
3. Teste novamente

### Erro: "Connection refused" ou "Timeout"
**Causa**: Servidor Evolution não acessível
**Solução**:
1. Verifique se Evolution está rodando: `docker ps` ou `systemctl status evolution`
2. Teste URL no navegador: `https://evolution.suaempresa.com/instance/fetchInstances`
3. Verifique firewall/portas
4. Se Evolution está em `localhost`, use IP/domínio acessível

### Inbox Não Criada Após Sync
**Causa**: Instância no Evolution pode estar sem nome válido
**Solução**:
1. Verifique se instância tem `instanceName` definido
2. Execute sync manual
3. Verifique logs: `Rails.logger` ou `tail -f log/development.log`

### Mensagens Não Chegam no Auzap
**Causa**: Webhook não configurado
**Solução**:
1. Configure webhook no Evolution apontando para Auzap:
```bash
curl -X POST https://evolution.suaempresa.com/webhook/set/clinica-veterinaria \
  -H "apikey: sua-chave" \
  -d '{
    "url": "https://auzap.suaempresa.com/webhooks/whatsapp",
    "webhook_by_events": true,
    "events": ["messages.upsert", "messages.update"]
  }'
```

### Múltiplas Inboxes Duplicadas
**Causa**: Sync executado várias vezes
**Solução**:
1. Delete inboxes duplicadas manualmente
2. Use `instance_name` único para evitar duplicatas
3. Verifique índice único no banco: `index_evolution_configs_on_account_and_instance`

---

## API Reference

### Endpoints Disponíveis

Todos os endpoints requerem autenticação de administrador.

#### 1. Listar Configurações
```
GET /api/v1/accounts/:account_id/evolution_api_configs
```

**Resposta:**
```json
[
  {
    "id": 1,
    "api_url": "https://evolution.example.com",
    "instance_name": "main",
    "enabled": true,
    "auto_sync": true,
    "last_synced_at": "2025-11-07T14:30:00Z",
    "last_sync_error": null,
    "created_at": "2025-11-07T10:00:00Z"
  }
]
```

#### 2. Criar Configuração
```
POST /api/v1/accounts/:account_id/evolution_api_configs
Content-Type: application/json

{
  "evolution_api_config": {
    "api_url": "https://evolution.example.com",
    "api_key": "sua-chave-secreta",
    "instance_name": "clinica-principal",
    "enabled": true,
    "auto_sync": true
  }
}
```

#### 3. Testar Conexão
```
POST /api/v1/accounts/:account_id/evolution_api_configs/:id/test_connection
```

**Resposta de sucesso:**
```json
{
  "success": true,
  "message": "Connection successful",
  "instances": [...]
}
```

**Resposta de erro:**
```json
{
  "success": false,
  "message": "Evolution API: Unauthorized - check your API key"
}
```

#### 4. Sincronizar Agora
```
POST /api/v1/accounts/:account_id/evolution_api_configs/:id/sync_now
```

**Resposta:**
```json
{
  "success": true,
  "message": "Sync completed successfully",
  "data": {
    "synced_instances": 3
  }
}
```

#### 5. Atualizar Configuração
```
PATCH /api/v1/accounts/:account_id/evolution_api_configs/:id
Content-Type: application/json

{
  "evolution_api_config": {
    "enabled": false
  }
}
```

#### 6. Deletar Configuração
```
DELETE /api/v1/accounts/:account_id/evolution_api_configs/:id
```

---

## Modelo de Dados

### Tabela: `evolution_api_configs`

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id` | bigint | ID único |
| `account_id` | bigint | Referência à conta (Account) |
| `api_url` | string | URL base do Evolution API |
| `api_key` | string | Chave API (encrypted) |
| `instance_name` | string | Nome da instância (opcional) |
| `enabled` | boolean | Config ativa? |
| `auto_sync` | boolean | Auto-sync ativo? |
| `sync_settings` | jsonb | Configurações avançadas de sync |
| `last_synced_at` | datetime | Última sincronização |
| `last_sync_error` | text | Erro da última sync (se houver) |
| `created_at` | datetime | Criado em |
| `updated_at` | datetime | Atualizado em |

**Índices:**
- `index_evolution_configs_on_account_and_instance` (UNIQUE)
- `index_evolution_api_configs_on_account_id`

---

## Segurança

### API Key Encryption

A `api_key` é criptografada automaticamente usando Rails 7 Active Record Encryption.

**Configuração necessária** (`.env`):
```bash
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=sua-chave-primaria
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=sua-chave-deterministica
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=seu-salt
```

**Gerar chaves**:
```bash
rails db:encryption:init
```

### Permissões

Apenas **administradores** da conta podem:
- Visualizar configurações Evolution API
- Criar/editar/deletar configurações
- Testar conexões
- Executar sincronização

Policy: `EvolutionApiConfigPolicy`

---

## Suporte

Para dúvidas ou problemas:

1. **Evolution API**: https://doc.evolution-api.com/
2. **Auzap Issues**: [GitHub Issues](https://github.com/fellipesaraiva88/chatwoot-white-label/issues)
3. **Logs da aplicação**: `tail -f log/production.log`

---

## Roadmap

Funcionalidades planejadas:

- [ ] Interface web para gerenciar configurações Evolution
- [ ] Dashboard de status de instâncias
- [ ] Notificações de desconexão
- [ ] Suporte a múltiplos webhooks
- [ ] Bulk actions (conectar/desconectar todas)
- [ ] Metrics e analytics
- [ ] Template sync com Evolution
- [ ] Suporte a grupos WhatsApp

---

**Última atualização**: 2025-11-07
**Versão**: 1.0.0
