# OpenRouter — расширенный роутинг моделей (настройка 2026-06-21, версия 1.4.0)

## Что это
OpenRouter — единый API-шлюз к сотням LLM (Anthropic, OpenAI, Google, DeepSeek, Qwen и др.) с единым
форматом запроса, авто-роутингом и единым биллингом. Решает задачу «вызвать ДРУГУЮ модель под конкретную
подзадачу», когда у дефолтной DeepSeek v4 нет нужного преимущества (vision, гигантский контекст, формальная
логика, минимальная цена за нужное качество кода). Это не замена DeepSeek v4 — основная модель остаётся
`deepseek-chat`, OpenRouter дополняет её точечными вызовами.

## Где настроено
OpenRouter подключён ДВУМЯ независимыми способами одновременно:

**1. MCP-инструмент** (`config.yaml` → `mcp_servers.openrouter`):
```yaml
openrouter:
  command: npx
  args: [-y, "@mcpservers/openrouterai"]
  env:
    OPENROUTER_API_KEY: sk-or-v1-…   # ключ скрыт; реальный — в config.yaml
  enabled: true
```
Даёт инструмент `chat_completion` — разовый вызов любой модели прямо в разговоре.

**2. Нативный провайдер Hermes** (`config.yaml` → `openrouter:`, верхний уровень, НЕ внутри mcp_servers):
```yaml
openrouter:
  min_coding_score: 0.65        # порог для Pareto Code Router, см. ниже
  response_cache: true          # edge-кэш повторных запросов (default: true)
  response_cache_ttl: 300       # TTL кэша в секундах, 1-86400 (default: 300)
```
Этот блок НЕ про вызов модели через MCP — он управляет двумя сквозными механизмами Hermes, описанными
в §2-3 ниже. Был подключён ранее (MCP-инструмент с устаревшими ID моделей), но без полного описания
нативного провайдера и без проверки — этот пробел закрывает версия 1.4.0.

## 1. Когда вызывать другую модель через `chat_completion`

| Ситуация | Модель (ТОЧНЫЙ id OpenRouter — через точку, не дефис!) |
|---|---|
| Задача содержит изображение или скриншот | `anthropic/claude-sonnet-4.6` (vision) |
| Очень длинный документ (>80 000 символов) | `anthropic/claude-opus-4` (200k контекст) |
| Сложная математика или формальная логика | `openai/o3-mini` |
| Нужен быстрый дешёвый ответ | `anthropic/claude-haiku-4.5` |
| Нужен качественный код по минимальной цене | `openrouter/pareto-code` (см. §2) |
| Всё остальное | Отвечай сам (DeepSeek v4) |

**⚠️ Найден и исправлен реальный баг (21.06.2026):** старая таблица использовала id с дефисом
(`claude-sonnet-4-6`, `claude-haiku-4-5`). У OpenRouter эти id пишутся через точку
(`claude-sonnet-4.6`, `claude-haiku-4.5`) — с дефисом запрос вернул бы 404/400. Обнаружено сверкой
с живым каталогом `GET /api/v1/models` (496 КБ JSON, без авторизации), а не по памяти/документации.

## 2. Pareto Code Router

`openrouter/pareto-code` — специальная модель-роутер: сама выбирает САМУЮ ДЕШЁВУЮ реальную модель,
которая проходит порог качества кода (рейтинг Artificial Analysis). Порог — `min_coding_score` в
`config.yaml` (0.0–1.0, выше = сильнее/дороже кодер; сейчас 0.65).

**Важно (подтверждено в исходнике `plugins/model-providers/openrouter/__init__.py`, метод
`build_extra_body`):** `min_coding_score` отправляется (как `plugins: [{id: "pareto-router",
min_coding_score: score}]`) **только** когда поле `model` запроса равно ровно `"openrouter/pareto-code"`.
На любой другой модели (включая `chat_completion` с явным id) это поле — полный no-op. Использовать
для задач кодогенерации, где не важно «какая именно модель», важен баланс цена/качество.

## 3. Кэш ответов (response cache)

При `response_cache: true` Hermes добавляет к каждому запросу к OpenRouter заголовки:
- `X-OpenRouter-Cache: true`
- `X-OpenRouter-Cache-TTL: 300` (или другое значение из `response_cache_ttl`)

Подтверждено в исходнике `agent/auxiliary_client.py` (`build_or_headers`) — используется не только во
вспомогательных вызовах, но и в основном пути (`run_agent.py`, `agent/agent_init.py`). Если в течение
TTL повторяется ИДЕНТИЧНЫЙ запрос (та же модель + сообщения + параметры) — OpenRouter возвращает
закэшированный ответ бесплатно, без повторного биллинга. Это отдельный edge-кэш самого OpenRouter,
не путать с Anthropic prompt caching.

Приоритет значений: переменные среды (`HERMES_OPENROUTER_CACHE`, `HERMES_OPENROUTER_CACHE_TTL`) >
`config.yaml` > дефолты (`true` / `300`).

## 4. Fallback-провайдер — доступно, но НЕ активировано

Hermes поддерживает `fallback_providers:` — цепочку резервных провайдеров на случай отказа основного
(рейт-лимит, 5xx, протухший ключ). OpenRouter — один из ~30 поддерживаемых провайдеров. В текущем
`config.yaml` `fallback_providers: []` — пусто. Решение **осознанное**: активация fallback меняет
поведение прода при сбоях, а не просто добавляет документацию — такое изменение трогаем только по
явному запросу, как и другие поведенческие изменения. Готовый рецепт на будущее:
```yaml
fallback_providers:
  - provider: openrouter
    model: deepseek/deepseek-chat   # или любая другая модель-замена
```

## 5. Provider Routing — задокументировано, но не настроено

OpenRouter поддерживает `provider_routing:` (сортировка по `price`/`throughput`/`latency`, `only`/`ignore`
конкретных провайдеров, `:nitro`/`:floor` суффиксы у id модели) — описано в собственной документации
Hermes (`website/docs/integrations/providers.md`), но в текущем `config.yaml` ключ `provider_routing:`
вообще отсутствует. Не используется сейчас — просто фиксируем как доступную, но невостребованную опцию.

## Конкретные примеры использования в нашей сборке

**1. Скриншот/изображение в задаче:**
DeepSeek v4 без vision → `chat_completion(model="anthropic/claude-sonnet-4.6", ...)` с картинкой в
сообщении → описание/анализ изображения возвращается в основной поток разговора.

**2. Кодогенерация без привязки к конкретной модели:**
Нужен рабочий React-компонент, не важно от какой модели — `chat_completion(model="openrouter/pareto-code")`
→ роутер сам взял самую дешёвую модель, прошедшую `min_coding_score: 0.65`.

**3. Повторный одинаковый запрос в рамках одной сессии (например, ретрай после сетевого сбоя):**
Тот же `model`+`messages`+`params` в течение 300 сек → ответ из edge-кэша OpenRouter, $0, не учитывается
повторно в `cost-ledger.md`.

**4. Гигантский документ, не влезающий в контекст DeepSeek:**
`chat_completion(model="anthropic/claude-opus-4", ...)` — 200k контекст для разбора длинного PDF/лога.

## Проверка (эмпирически, 21.06.2026)
- `GET https://openrouter.ai/api/v1/auth/key` → ключ `sk-or-v1-066…ee5` валиден, лимит $10,
  остаток $9.99985 (до теста).
- `POST /api/v1/chat/completions` на `anthropic/claude-haiku-4.5` («Reply with exactly one word: OK») →
  HTTP 200, ответ `"OK"`, `usage.cost = $0.000034`, провайдер `Amazon Bedrock`.
- `GET /api/v1/models` (живой каталог, без авторизации) → подтверждены правильные id моделей
  (точка, не дефис) и существование `openrouter/pareto-code`.
- Остаток ключа после теста: $9.999816.

## Связанные правила/файлы
- `SOUL.md` §4 (роутинг моделей, Pareto Code Router, response cache, fallback) — полностью переписан.
- `SOUL.md` §9 (тактика 3, использование response cache в экономии).
- `cost-ledger.md` (записи №10-11), `cost-pricing.md` (3 новых строки OpenRouter).
- `Departments/Инструкция к оркестрации 1 (Foresight).md` — Этап 4.
