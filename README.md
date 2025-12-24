# Beatriz (Bia) - Secretária Virtual Inteligente

A **Beatriz (Bia)** é uma assistente virtual amigável e objetiva desenvolvida para gerenciar agendamentos no Google Calendar via WhatsApp. O projeto utiliza uma arquitetura baseada em eventos para interpretar mensagens de texto, áudios e imagens, garantindo que a organização da agenda seja feita de forma natural e automatizada.

## 🚀 Funcionalidades

* **Gestão de Agenda:** Capacidade de criar, atualizar, cancelar e consultar o status de eventos no Google Calendar.
* **Processamento Multimodal:** Suporte completo para mensagens de texto e áudio (com transcrição via IA).
* **Análise de Imagens:** Extração de compromissos a partir de capturas de tela de conversas.
* **Inteligência Artificial:** Utiliza o modelo **Gemini 2.5 Flash** para extração estruturada de dados (JSON) e interação cordial.
* **Resiliência e Erros:** Implementação de retries automáticos em caso de falha na IA e um workflow de erro dedicado para respostas amigáveis ao usuário.
* **Histórico e Logs:** Persistência completa de mensagens (inbound/outbound), logs de execução da IA e registros de erros no banco de dados.
* **Idempotência:** Garantia de que a mesma mensagem não processe ações duplicadas através da validação do `message_id`.

## 🛠️ Stack Tecnológica

* **n8n:** Orquestrador do fluxo de automação.
* **Z-API:** Integração com a API do WhatsApp para recebimento e envio de mensagens.
* **Google Gemini 2.5 Flash:** Transcrição de áudio, análise de imagem e processamento de linguagem natural.
* **Google Calendar API:** Gerenciamento dos eventos de calendário.
* **Supabase (PostgreSQL):** Persistência de dados e logs.

## ⚙️ Configuração e Instalação

### 1. Banco de Dados

Execute o conteúdo do arquivo `schema.sql` em seu editor SQL no Supabase (ou qualquer instância Postgres) para criar as tabelas e tipos necessários:

* `contacts`: Identificação de usuários.
* `calendar_events`: Registro de eventos sincronizados.
* `messages_logs`: Histórico de conversas.
* `llm_runs`: Rastreamento de chamadas ao Gemini.
* `errors`: Log de falhas técnicas.

### 2. Importação no n8n

Importe os seguintes arquivos JSON na sua instância do n8n:

* `Bia - Main.json` (Workflow principal).
* `Bia - Error Workflow.json` (Workflow de tratamento de exceções).

### 3. Credenciais Necessárias

Você deve configurar as seguintes credenciais no n8n para o funcionamento correto:

* **Google Gemini(PaLM) API:** Chave para acesso ao modelo Flash 2.5.
* **Google Calendar OAuth2:** Acesso à agenda do usuário.
* **Supabase API:** Conexão com o banco de dados Postgres.
* **Header Auth:** Para autenticação com a Z-API.

### 4. Variáveis de Ambiente (.env.example)

As variáveis abaixo devem ser configuradas para que o workflow localize sua instância da Z-API e tokens de segurança:

```env
ZAPI_INSTANCE_ID=seu_id_da_instancia
ZAPI_TOKEN=seu_token_da_zapi
```
