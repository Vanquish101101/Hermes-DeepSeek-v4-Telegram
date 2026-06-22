# Sentry MCP — настройка и архитектура мониторинга ошибок (добавлено 2026-06-22, версия 1.13.0)

Sentry был найден через **Smithery** (`servers_list(q="sentry")`, версия 1.10.0) как кандидат на
подключение и сконфигурирован в `config.yaml` ранее, но не имел роли в оркестрации. На этом этапе
подключение проверено эмпирически и сервис получил роль.

## Где настроено (файл в `AppData\Local\hermes\`, в репо не коммитится)
**`config.yaml` → `mcp_servers.sentry`**:
```yaml
sentry:
  command: npx
  args: ["-y", "mcp-remote", "https://mcp.sentry.dev/mcp"]
  enabled: true
```
Официальный MCP от Sentry, авторизация — OAuth2 через `mcp-remote` bridge (как у Smithery), **API-
ключ не нужен** — то, что классический REST API-ключ Sentry так и не был сгенерирован пользователем
(заметка в `API Keys.txt`: «API foresight — пока просто зарегался, апи не нашёл»), для этого MCP не
проблема.

## Архитектура
Полное описание — `SOUL.md` §17. Кратко: слой мониторинга ошибок и AI-диагностики (`analyze_issue_with_seer`)
для реальных проектов — комплементарен Vercel (§13, статус деплоя инфраструктуры) и закрывает цикл,
открытый Smithery (§14): найден → задача в YouGile → теперь подключён и проверен.

## Проверка (эмпирически, 22.06.2026)
- OAuth был пройден ранее (не в рамках этого этапа). ⚠️ **Техническая находка:** `mcp-remote`
  кэширует токены в `~/.mcp-auth/mcp-remote-<версия>/<MD5(server_url)>_tokens.json` — имя файла
  кеша — это MD5-хеш URL MCP-сервера. Это позволяет напрямую переиспользовать `access_token` для
  прямых REST/JSON-RPC вызовов в обход браузерного логина — полезно для проверки ЛЮБОГО OAuth-MCP
  без интерактивного шага.
- ⚠️ Тот же баг, что у Replicate (`Replicate-setup.md`): первый JSON-RPC запрос к
  `https://mcp.sentry.dev/mcp` вернул HTTP 403 (Cloudflare `error code: 1010`, дефолтный User-Agent
  `urllib`) — исправлено браузерным заголовком, токен был валиден всё это время.
- `tools/list` подтвердил 8 инструментов: `find_organizations`, `find_projects`, `search_events`,
  `search_issues`, `analyze_issue_with_seer`, `get_sentry_resource`, `search_sentry_tools`,
  `execute_sentry_tool`.
- `find_organizations` → организация **`vanquish-project`** (регион `de.sentry.io`).
- `find_projects(organizationSlug="vanquish-project")` → **0 проектов** — чистый аккаунт, ни один
  Sentry-проект/DSN ещё не настроен в коде. Подключение MCP и интеграция SDK в конкретный проект —
  два разных шага; второй пока не сделан и не входит в этот этап.

## Конкретная связь сервисов (закрытие цикла, не только описание)
- **YouGile** — задача «Подключить Sentry MCP (найден через Smithery)» (id
  `2bfea080-0dac-4618-95a5-a68da07b6723`) перенесена из колонки «Входящие» в «Готово», `completed: true`.
- **Notion** — записана находка о состоянии аккаунта (организация есть, проектов 0) и про кеш OAuth-
  токенов `mcp-remote` (база «Исследования и находки», категория «Техническая находка», инструмент
  «Sentry»), заголовок проверен побайтово (UTF-8 hex).

## Связанные правила/файлы
- `SOUL.md` §17 (архитектура), §14 (Smithery — откуда найден), §12 (YouGile — закрытая задача),
  §10 (Notion — находки), §13 (Vercel — комплементарный слой статуса деплоя).
- `cost-ledger.md` — проверочные вызовы $0.00 (план Sentry привязан к аккаунту, не к MCP-вызову).
- Память: `project_smithery_orchestration` (откуда найден кандидат), `project_vercel_orchestration`
  (комплементарный сервис).
