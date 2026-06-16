# Hermes + DeepSeek v4 + Telegram — История версий

---

## version 0.2.7 | Make.com MCP подключён | 2026-06-16

**Изменения:**
- Подключён официальный Make MCP Server (Remote HTTP, Stateless Streamable HTTP) для зоны `eu1.make.com`
- Аутентификация через специальный MCP-токен (не обычный API-ключ организации) — найден на странице MCP-подключения Make ("Default key")
- 129 инструментов: полное управление сценариями (CRUD + run), executions, webhooks, data stores, custom apps, RPC и др.
- Попутно добавлен `google_calendar` через MCP Market — пока не работает (OAuth credentials не активны на стороне MCP Market), ждёт переавторизации пользователем
- Gateway перезапущен, всего подключено 21 MCP сервер

---

## version 0.2.6 | Context7 MCP подключён | 2026-06-16

**Изменения:**
- Подключён официальный Context7 MCP от Upstash через Remote HTTP (`https://mcp.context7.com/mcp`)
- Аутентификация через заголовок `CONTEXT7_API_KEY` (не Authorization: Bearer — особенность этого сервера)
- 2 инструмента: `resolve-library-id` (поиск библиотеки по имени), `query-docs` (актуальная документация и примеры кода)
- Назначение: устраняет устаревшие/несуществующие API в сгенерированном коде — подтягивает свежую документацию прямо в контекст
- Gateway перезапущен с новой конфигурацией
- Всего подключено 20 MCP серверов (16 официальных, 3 community, 1 через прокси)

---

## version 0.2.5 | Gemini ключ исправлен — все 19 MCP рабочие | 2026-06-16

**Изменения:**
- Найден рабочий ключ Gemini/Google AI Studio: `AQ.Ab8RN6Jxv...` (новый формат ключей Google, отличается от старого `AIzaSy...`)
- Проверен напрямую через curl на `generativelanguage.googleapis.com` — `200 OK`, до этого ошибочно отклонён как невалидный по формату (поспешный вывод без эмпирической проверки)
- Обновлён `GEMINI_API_KEY` и `GOOGLE_API_KEY` в config.yaml и .env
- `hermes mcp test gemini` подтвердил: 13 инструментов (chat, deep research, generate_image/video/svg, image analysis)
- **Все 19 подключённых MCP серверов теперь рабочие** — полная проверка завершена
- MCP key connection.txt обновлён с пометкой про новый формат ключей Google

---

## version 0.2.4 | Проверка всех MCP + исправлен Smithery | 2026-06-16

**Изменения:**
- Полная проверка всех 19 подключённых MCP серверов через `hermes mcp test`
- Обнаружено: Smithery упал после обновления CLI до v4 (полностью новая архитектура — старый статичный ключ через `--key` больше не поддерживается)
- Smithery исправлен: переключён на OAuth2 + PKCE через `npx mcp-remote https://server.smithery.ai/smithery` — одноразовая браузерная авторизация, токен кэшируется и обновляется автоматически
- Тот же `mcp-remote` подход уже зарезервирован как fallback для Vercel — теперь это общий паттерн для любых MCP, требующих OAuth2 PKCE
- Gemini остаётся НЕ рабочим — ключ `AQ.Ab8RN6LZ...` не проходит валидацию у самого Google (Status 400). Нужен новый ключ формата `AIzaSy...` с aistudio.google.com/apikey
- 17 из 19 серверов подтверждены рабочими: pinecone, qdrant, perplexity, apify, firecrawl, notion, n8n, supabase, github, openrouter, replicate, elevenlabs, vercel, langsmith, runway, helicone, miro
- MCP key connection.txt обновлён с деталями диагностики

---

## version 0.2.3 | Gemini MCP подключён | 2026-06-16

**Изменения:**
- Подключён community MCP `@houtini/gemini-mcp` (npx) для Google AI Studio / Gemini
- 13 инструментов: gemini_chat (с Google Search grounding), gemini_deep_research, generate_image, генерация SVG/диаграмм, генерация видео, мультимодальный анализ
- Ключ GEMINI_API_KEY уже был в Hermes .env — использован существующий
- Дополняет OpenRouter MCP: прямой доступ к Gemini 3 с grounding и deep research, которого нет в OpenRouter
- MCP key connection.txt обновлён: 19 подключённых MCP серверов (15 официальных, 3 community, 1 через прокси)
- Gateway перезапущен с новой конфигурацией

---

## version 0.2.2 | Digital Brain папка + Git commit body | 2026-06-16

**Изменения:**
- Создана папка `digital-brain/` — хранилище контекстных материалов проекта (документы, схемы, референсы, знания)
- Правило GitHub коммитов расширено: теперь каждый коммит содержит развёрнутое тело (body) с буллетами — что изменилось, какие файлы, почему. Видно в GitHub на странице каждого коммита.

---

## version 0.2.1 | Creative Skills установлены | 2026-06-16

**Изменения:**
- Установлен скилл `blender-mcp` — прямое управление Blender 4.3+ через MCP (3D объекты, материалы, анимация, bpy код)
- Установлен скилл `kanban-video-orchestrator` — мультиагентный пайплайн производства видео (бриф → команда агентов → kanban → мониторинг)
- Установлен скилл `hyperframes` — HTML-в-видео MP4/WebM (анимации, субтитры, аудио-реактивная графика)
- Установлен скилл `baoyu-article-illustrator` — иллюстрации в 20+ стилях (pixel, sketch, editorial, neon, flat, retro...)
- `comfyui` уже был встроен — подтверждён активным (text-to-image, video, audio через ComfyUI)
- Все скиллы официальные от Nous Research, конфликтов с MCP серверами нет

---

## version 0.2.0 | Keep-Alive автоматика | 2026-06-16

**Изменения:**
- Добавлен cron job `keep-alive-ping` (ID: cfdbe2d12f20) — каждые 5 дней в 10:00 пингует Supabase, Qdrant, Pinecone, n8n
- При обнаружении INACTIVE Supabase — автоматическое восстановление через MCP
- Результат доставляется в Telegram (chat 1064521326)
- `run-hermes-gateway-forever.ps1` дополнен: при старте системы запускает `hermes cron tick` — все пропущенные задачи выполняются немедленно при включении компьютера
- В SOUL.md добавлено Правило 5 — Keep-Alive протокол

---

## version 0.1.9 | Smithery MCP подключён | 2026-06-15

**Изменения:**
- Подключён Smithery MCP (`smithery-cli-mcp` via @smithery/cli run)
- Запуск через Smithery CLI — платформа сама управляет версиями сервера
- Инструменты: поиск MCP серверов, управление подключениями, просмотр каталога инструментов
- Аутентификация через SMITHERY_API_KEY (передаётся напрямую в args)
- Gateway перезапущен с новой конфигурацией

---

## version 0.1.8 | Miro MCP подключён | 2026-06-15

**Изменения:**
- Подключён Miro MCP через MCP Market (`https://link.mcpmarket.com/vfvf6462/miro/mcp`)
- Удалённый HTTP сервер — без npx, без загрузки пакетов (аналогично n8n и Apify)
- Аутентификация через MCP_MARKET_API_KEY
- Инструменты: работа с досками Miro, карточки, фреймы, sticky notes, диаграммы
- Gateway перезапущен с новой конфигурацией

---

## version 0.1.7 | Helicone MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Helicone MCP (`@helicone/mcp` via npx)
- Инструменты: запросы к логам LLM с фильтрами, пагинацией, сортировкой; анализ ошибок, производительности, request/response bodies
- Аутентификация через HELICONE_API_KEY
- Gateway перезапущен с новой конфигурацией

---

## version 0.1.6 | Runway MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Runway MCP (`runway-mcp-server` via uvx, от RunwayML)
- Инструменты: генерация видео (Gen-4.5), генерация изображений, управление задачами медиагенерации
- Аутентификация через RUNWAY_API_KEY
- Gateway перезапущен с новой конфигурацией

---

## version 0.1.5 | LangSmith MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный LangSmith MCP (`langsmith-mcp-server` via uvx, от LangChain AI)
- Инструменты: просмотр трейсов, runs, промптов, проектов наблюдаемости (observability)
- Аутентификация через LANGSMITH_API_KEY
- Gateway перезапущен с новой конфигурацией

---

## version 0.1.4 | Vercel MCP подключён | 2026-06-15

**Изменения:**
- Подключён Vercel MCP (`@open-mcp/vercel` via npx, community-пакет)
- Аутентификация через API_KEY (без OAuth, headless-совместимо)
- Инструменты: управление деплойментами, проекты, домены, переменные окружения, логи
- Примечание: официальный Vercel MCP использует OAuth — выбран community-вариант для совместимости с gateway
- Gateway перезапущен с новой конфигурацией

---

## version 0.1.3 | ElevenLabs MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный ElevenLabs MCP (`elevenlabs-mcp` via uvx)
- Инструменты: генерация речи (TTS), клонирование голоса, транскрипция аудио, управление голосами, Conversational AI агенты, исходящие звонки
- Аутентификация через ELEVENLABS_API_KEY
- Gateway перезапущен с новой конфигурацией

---

## version 0.1.2 | Replicate MCP подключён | 2026-06-15

**Изменения:**
- Подключён официальный Replicate MCP (`replicate-mcp` via npx)
- Инструменты: поиск моделей, запуск предсказаний (изображения, видео, аудио, код), получение метаданных
- Аутентификация через REPLICATE_API_TOKEN
- Gateway перезапущен с новой конфигурацией

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
