# Auzap CRM

### Plataforma completa de CRM e atendimento ao cliente

___

**Auzap** é uma plataforma moderna de CRM (Customer Relationship Management) e atendimento ao cliente, construída para ajudar empresas a gerenciar relacionamentos com clientes de forma eficiente e escalável. Com foco especial no mercado brasileiro e integração nativa com WhatsApp através da Evolution API, o Auzap oferece todas as ferramentas necessárias para centralizar e otimizar sua comunicação com clientes.

---

Auzap é uma solução completa e auto-hospedada de CRM que permite às empresas manter controle total sobre seus dados de clientes, enquanto oferece ferramentas poderosas para gerenciar conversas através de múltiplos canais de comunicação.

## 🚀 Principais Recursos

### 💬 Atendimento Omnichannel

O Auzap centraliza todas as conversas com clientes em uma única caixa de entrada poderosa, não importa de onde seus clientes entrem em contato. Suporte para:

- **WhatsApp** (integração nativa via Evolution API)
- Chat ao vivo no seu site
- E-mail
- Facebook Messenger
- Instagram Direct
- Telegram
- SMS
- E mais...

### 📊 CRM Completo para Gestão de Clientes

Gerencie todo o relacionamento com seus clientes em um só lugar:

- Perfis completos de contatos com histórico de interações
- Segmentação de clientes para comunicação direcionada
- Atributos personalizados para armazenar dados específicos do seu negócio
- Campanhas proativas para engajar clientes
- Notas e anotações sobre cada contato

### 🤖 Automação Inteligente

Automatize tarefas repetitivas e melhore a eficiência da equipe:

- Distribuição automática de conversas
- Respostas prontas (Canned Responses)
- Regras de automação personalizáveis
- Fluxos de trabalho automatizados
- Horário de atendimento e respostas automáticas

### 📚 Portal de Ajuda

Publique artigos de ajuda, FAQs e guias através do Portal de Ajuda integrado. Permita que clientes encontrem respostas por conta própria, reduza consultas repetitivas e mantenha sua equipe focada em questões mais complexas.

### 🗂️ Recursos Adicionais

#### Colaboração e Produtividade

- **Notas Privadas** e **@menções** para discussões internas da equipe
- **Etiquetas** para organizar e categorizar conversas
- **Atalhos de Teclado** e **Barra de Comandos** para navegação rápida
- **Respostas Prontas** (Canned Responses) para responder mais rápido a perguntas frequentes
- **Atribuição Automática** para rotear conversas baseado na disponibilidade dos agentes
- **Suporte Multi-idiomas** para atender clientes em múltiplos idiomas
- **Visualizações e Filtros Personalizados** para melhor organização da caixa de entrada
- **Horário Comercial** e **Respostas Automáticas** para gerenciar expectativas de resposta
- **Equipes** e **Ferramentas de Automação** para escalar fluxos de atendimento
- **Gestão de Capacidade de Agentes** para balancear carga de trabalho

#### Gestão de Dados de Clientes

- **Gestão de Contatos** com perfis e histórico de interações
- **Segmentos de Contatos** e **Notas** para comunicação direcionada
- **Campanhas** para engajar clientes proativamente
- **Atributos Personalizados** para armazenar dados adicionais de clientes
- **Formulários Pré-Chat** para coletar informações antes de iniciar conversas

#### Integrações

- **Evolution API** para integração completa com WhatsApp
- **Slack** para gerenciar conversas diretamente do Slack
- **Dialogflow** para automação com chatbots
- **Dashboard Apps** para incorporar ferramentas internas
- **Google Translate** para traduzir mensagens de clientes em tempo real
- **Webhooks** para integrar com seus sistemas existentes

#### Relatórios e Análises

- **Visualização ao Vivo** de conversas em andamento para monitoramento em tempo real
- **Relatórios** de Conversas, Agentes, Caixas de Entrada, Etiquetas e Equipes
- **Relatórios CSAT** para medir satisfação do cliente
- **Relatórios Exportáveis** para análise offline e reporting


## 📖 Documentação

A documentação completa está disponível em português, incluindo:

- Guia de instalação e configuração
- Configuração da Evolution API para WhatsApp
- Guias de uso e melhores práticas
- Referência de APIs
- Troubleshooting

Consulte a pasta `/docs` para acessar toda a documentação.

## 🚀 Instalação

### Requisitos

- Ruby 3.2+
- Node.js 18+
- PostgreSQL 12+
- Redis 6+

### Instalação Rápida

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/auzap-crm.git
cd auzap-crm

# Instale as dependências
bundle install
pnpm install

# Configure o banco de dados
rails db:create
rails db:migrate

# Inicie o servidor de desenvolvimento
pnpm dev
```

### Docker

```bash
# Construa e inicie com Docker Compose
docker-compose up -d
```

## 🔧 Configuração

### Variáveis de Ambiente

Configure as variáveis de ambiente necessárias no arquivo `.env`:

```env
# Banco de dados
DATABASE_URL=postgresql://user:password@localhost/auzap_production

# Redis
REDIS_URL=redis://localhost:6379

# Evolution API (WhatsApp)
EVOLUTION_API_URL=https://sua-evolution-api.com
EVOLUTION_API_KEY=sua-chave-api

# Configurações gerais
SECRET_KEY_BASE=sua-chave-secreta
FRONTEND_URL=https://seu-dominio.com
```

## 🔐 Segurança

Para reportar uma vulnerabilidade de segurança, consulte nosso arquivo [SECURITY.md](./SECURITY.md).

## 🤝 Contribuindo

Contribuições são sempre bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

### Modelo de Branching

Utilizamos o modelo [git-flow](https://nvie.com/posts/a-successful-git-branching-model/). A branch base é `develop`.
Para versões estáveis, use a branch `master` ou tags rotuladas como `v1.x.x`.

## 📄 Licença

**Auzap CRM** © 2025 - Distribuído sob a Licença MIT.

---

Desenvolvido com ❤️ para o mercado brasileiro
