# Hermes + DeepSeek v4 + Telegram — История версий

---

## version 0.1.1 | OpenRouter MCP подключён | 2026-06-15

**Изменения:**
- Подключён community OpenRouter MCP (`@mcpservers/openrouterai` via npx, 4 инструмента)
- Инструменты: chat_completion (вызов любой LLM), search_models, get_model_info, validate_model
- Hermes теперь может вызывать GPT-4o, Claude, Gemini и любую другую модель как инструмент внутри разговора
- Примечание: community-пакет (не официальный от OpenRouter), но стабилен для production-использования
- Gateway перезапущен с новой конфигурацией

---

## version 0.1.0 | Pinecone MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Pinecone MCP (`@pinecone-database/mcp` via npx, 9 инструментов)
- Доступные инструменты: list-indexes, search-records, upsert-records, create-index-for-model, rerank-documents, cascading-search, search-docs
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.9 | Qdrant MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Qdrant MCP (`mcp-server-qdrant` via uvx, 2 инструмента)
- Семантическое хранилище памяти: коллекция "foresight" в облачном Qdrant
- Эмбеддинги: локальная модель `all-MiniLM-L6-v2` (384 измерения, fastembed/ONNX)
- Инструменты: qdrant-store (сохранить память), qdrant-find (семантический поиск)
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.8 | Perplexity MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Perplexity MCP (`@perplexity-ai/mcp-server`, 4 инструмента)
- Доступные инструменты: perplexity_ask (Sonar Pro), perplexity_research (глубокое исследование), perplexity_reason (пошаговый анализ), perplexity_search (веб-поиск с источниками)
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.7 | Apify MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Apify MCP (`mcp.apify.com`, 10 инструментов)
- Удалённый HTTP сервер — без npx, без загрузки пакетов
- Аутентификация через Bearer токен (APIFY_TOKEN)
- Доступные инструменты: search-actors, call-actor, get-actor-run, get-dataset-items, search-apify-docs, rag-web-browser и др.
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.6 | Firecrawl MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Firecrawl MCP (`firecrawl-mcp` via npx, 20 инструментов)
- Доступные инструменты: scrape, search, crawl, extract, agent (автономный веб-исследователь), interact (браузер), monitors (мониторинг сайтов с diff)
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.5 | Notion MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Notion MCP (`@notionhq/notion-mcp-server`, 22 инструмента)
- Прямое подключение от Notion — без посредников (лучше чем MCP Market)
- Аутентификация через NOTION_TOKEN (Integration token)
- Доступные инструменты: поиск по workspace, страницы (create/update/move), блоки, базы данных, комментарии, data sources
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.4 | n8n MCP подключён | 2026-06-15

**Изменения:**
- Подключён n8n MCP (`vanquish.app.n8n.cloud/mcp-server/http`, 28 инструментов)
- Аутентификация через Bearer токен из n8n cloud
- Доступные инструменты: search_workflows, execute_workflow, create_workflow_from_code, get_execution, publish_workflow, search_data_tables, create_data_table, validate_workflow и др.
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.3 | Supabase MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Supabase MCP (`https://mcp.supabase.com`, 20 инструментов)
- Аутентификация через PAT токен (Personal Access Token)
- Доступные инструменты: execute_sql, list_tables, list_migrations, apply_migration, get_logs, deploy_edge_function, create_branch, generate_typescript_types и др.
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.2 | GitHub MCP подключён | 2026-06-15

**Изменения:**
- Подключён GitHub MCP сервер (`@modelcontextprotocol/server-github`, 26 инструментов)
- Обновлён `GITHUB_TOKEN` в Hermes `.env` на активный ключ
- В Hermes `.env` добавлено 28 новых API ключей (Anthropic, OpenRouter, Google/Gemini, ElevenLabs, Perplexity, Notion, LangSmith, LangGraph, Qdrant, Pinecone, Redis, Smithery, MCP Market, n8n MCP, Helicone, CrewAI, Mastra, Context7, Vercel, Runway, Supabase и др.)
- В `SOUL.md` Hermes записаны операционные правила проекта (MCP приоритет, версионирование, проверка ключей)
- Gateway перезапущен с новой конфигурацией

---

## version 0.0.1 | Первоначальная настройка | 2026-06-15

**Изменения:**
- Инициализирован репозиторий проекта
- Hermes gateway настроен и работает (модель: `deepseek-chat`, провайдер: DeepSeek v4)
- Telegram бот `@foresight_project_hermes_bot` подключён
- Автоперезапуск через Scheduled Task `Hermes Gateway Wrapper`
- Добавлены скрипты: `check-status.ps1`, `check-all-status.ps1`, `run-hermes-gateway-forever.ps1`, `start-hermes-gateway.ps1`, `import-project-settings.ps1`

---

## Формат версий

```
Название | краткое описание изменения | version X.X.X
```

- **X** (мажор) — полная перестройка архитектуры
- **X.X** (минор) — новый агент, MCP, интеграция
- **X.X.X** (патч) — правки конфига, ключи, скрипты
