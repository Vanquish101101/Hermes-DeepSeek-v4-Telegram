# Smithery MCP — настройка и архитектура поиска новых MCP-серверов (добавлено 2026-06-22, версия 1.10.0)

Smithery подключён к Hermes через OAuth2+PKCE bridge ещё с 07.06.2026 (архитектура обновлена до v4
16.06.2026), но до этой версии не имел роли в оркестрации.

## Где настроено (файл в `AppData\Local\hermes\`, в репо не коммитится)
**`config.yaml` → `mcp_servers.smithery`**:
```yaml
smithery:
  command: npx
  args: ["-y", "mcp-remote", "https://server.smithery.ai/smithery"]
  enabled: true
```
Авторизация — одноразовый браузерный OAuth-вход, `mcp-remote` кэширует токен и обновляет по
`refresh_token` автоматически. Старый статичный ключ (`7037340f-b9c9-4edd-a9a5-0e3c1fe63d91`) валиден
только для самого Smithery CLI (`smithery auth login/whoami`), но не принимается напрямую
MCP-эндпоинтом — см. [[reminder_mcp_remote_oauth_pattern]] (паттерн, открытый именно на Smithery).

## Архитектура
Полное описание — `SOUL.md` §14. Кратко: Smithery — не сервис под конкретную задачу (как
Notion/PostMyPost/YouGile/Vercel), а **точка обнаружения**: реестр готовых MCP-серверов
(`servers.*`/`servers_get`) и prompt-скиллов (`skills.*`). Перед тем как вручную искать/собирать
интеграцию под новую потребность — сначала проверить, нет ли уже готового верифицированного сервера
в Smithery.

⚠️ Не путать с **«Skill SH»** (`npx skills find`) — отдельный, не связанный со Smithery реестр
скиллов для Claude Code (см. [[skills_skillsh_table]]).

## Проверка (эмпирически, 22.06.2026)
- `namespaces_list()` (без параметров — возвращает namespace-ы текущего пользователя) → один
  namespace `vfvf6462` (создан 07.06.2026).
- `servers_list(namespace="vfvf6462")` → 0 серверов — у пользователя/Hermes нет собственных
  опубликованных MCP-серверов (потребитель реестра, не публикатор).
- `connect_by_namespace_get(namespace="vfvf6462")` → 2 подключения:
  - `smithery-registry` (`state: connected`) — рабочее подключение, даёт доступ к Smithery
    Platform API (46 инструментов: `servers.*`, `skills.*`, `namespaces.*`, `connect.*`,
    `organizations.api_keys.*`, `tokens.create`).
  - `smithery` (`state: input_required`, не хватает bearer) — незавершённый черновик, по всей
    видимости остался от самого первого OAuth-онбординга 07.06.2026 — **не трогаем**, не мешает.
- **Демонстрация роли (конкретная связь сервисов):** `servers_list(q="sentry")` → найден
  официальный сервер `qualifiedName: "sentry"` (`verified: true`, `bySmithery: true`, remote HTTP,
  `deploymentUrl: https://sentry.run.tools`, `useCount: 36`). Sentry был в TODO-списке
  неподключённых сервисов.
  - Находка записана в Notion, база «Исследования и находки» (категория «Техническая находка»,
    инструмент «Smithery»), заголовок проверен побайтово (UTF-8 hex).
  - Задача **«Подключить Sentry MCP (найден через Smithery)»** создана в YouGile, проект
    `Foresight — Задачи (Hermes)`, колонка «Входящие», заголовок проверен побайтово.

## Связанные правила/файлы
- `SOUL.md` §14 (архитектура), §10 (Notion — куда заносить найденных кандидатов), §12 (YouGile —
  куда заносить задачу на подключение).
- `cost-ledger.md` — запись о проверочных вызовах (фиксированный план Smithery, $0.00).
- Память: [[reminder_mcp_remote_oauth_pattern]] (паттерн OAuth-bridge, открыт на Smithery),
  [[skills_skillsh_table]] (соседний, но отдельный реестр скиллов — не путать).
