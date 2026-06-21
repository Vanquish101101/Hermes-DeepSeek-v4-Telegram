# Helicone — учёт расходов LLM (настройка 2026-06-21)

Основная модель Hermes (DeepSeek) маршрутизируется через **Helicone-прокси**, чтобы траты на LLM
считались в дашборде Helicone (по дням/моделям). Сделано штатно, **без правки кода Hermes**.

## Что изменено (файлы в `AppData\Local\hermes\`, в репо не коммитятся — содержат ключи)
1. **`.env`** — добавлено:
   ```
   DEEPSEEK_BASE_URL=https://deepseek.helicone.ai
   ```
   Провайдер остаётся `deepseek` (его профиль и thinking-mode сохранены) — меняется только адрес.
   Приоритет: env-переменная > `config.yaml model.base_url` > дефолт провайдера.

2. **`config.yaml`** — в секцию `model:` добавлен заголовок:
   ```yaml
   model:
     default_headers:
       Helicone-Auth: 'Bearer sk-helicone-…'   # ключ скрыт; реальный — в config.yaml
   ```
   Опция `model.default_headers` применяется и к основным, и к вспомогательным вызовам.

3. **`config.yaml`** — включён встроенный счётчик: `display.show_cost: true`.

## Проверка (эмпирически)
- `curl https://deepseek.helicone.ai/chat/completions` (с `Authorization` + `Helicone-Auth`) → **HTTP 200**.
- После рестарта gateway: `hermes -z "..."` → корректный ответ **«PONG»** ⇒ маршрут работает сквозь Helicone.
- Эндпоинт без `/v1` (OpenAI SDK сам добавляет `/chat/completions`).

## Дашборд
- Расходы: https://us.helicone.ai
- Helicone MCP — для чтения данных из агента.

## ⚠️ Нюанс
Scheduled Task `Hermes_Gateway` на момент настройки была **отключена** — рестарт прошёл через
прямой запуск (direct spawn). После перезагрузки ПК автозапуск может не сработать; при необходимости
включить задачу (`schtasks /Change /TN Hermes_Gateway /ENABLE`) или переустановить (`hermes gateway install`).

## Связанные правила
Снимок правил — `SOUL.md` (§8 Прозрачность расходов, §9 Экономия без потери качества).
Журнал — `cost-ledger.md`. Ставки — `cost-pricing.md`.
