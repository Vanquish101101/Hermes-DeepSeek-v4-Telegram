# Hermes + DeepSeek v4 + Telegram

Автономный ИИ-ассистент Hermes с моделью DeepSeek v4, подключенный к Telegram.

## Компоненты

| Компонент | Расположение |
|-----------|-------------|
| Hermes конфиг | `C:\Users\Unknown\AppData\Local\hermes\config.yaml` |
| Hermes секреты | `C:\Users\Unknown\AppData\Local\hermes\.env` |
| Hermes приложение | `C:\Users\Unknown\AppData\Local\hermes\hermes-agent\` |
| Telegram бот | `@foresight_project_hermes_bot` (токен в Hermes .env) |
| Модель | `deepseek-chat` (DeepSeek v4) |

## Telegram бот

- Имя: foresight project hermes bot
- Токен: в `C:\Users\Unknown\AppData\Local\hermes\.env` (строка TELEGRAM_BOT_TOKEN)
- Разрешенные пользователи: настраивается через `hermes gateway setup` или переменная `TELEGRAM_ALLOWED_USERS`

## Запуск

### Проверка статуса
```powershell
.\scripts\check-status.ps1
```

### Запустить gateway (однократно)
```powershell
.\scripts\start-hermes-gateway.ps1
```

### Запустить gateway с автоперезапуском
```powershell
.\scripts\run-hermes-gateway-forever.ps1
```

### Прямые команды Hermes
```powershell
hermes status
hermes gateway status
hermes doctor
```

## Настройка модели и провайдера

Текущая конфигурация в `config.yaml`:
- `model.default: deepseek-chat`
- `model.provider: deepseek`
- API ключ: `DEEPSEEK_API_KEY` в `.env`

Изменить модель: `hermes model` или `hermes setup`

## Диагностика

```powershell
hermes doctor
```

Типичные причины неполадок:
- Gateway не запущен: запустите `hermes gateway run`
- Telegram токен не задан: проверьте `.env` → `TELEGRAM_BOT_TOKEN`
- DeepSeek API недоступен: проверьте `.env` → `DEEPSEEK_API_KEY`

## Безопасность

Секреты хранятся только в:
- `C:\Users\Unknown\AppData\Local\hermes\.env` — Hermes
- `C:\Users\Unknown\Documents\Project settings\API Keys.txt` — мастер-файл ключей

В этот репозиторий секреты не попадают (см. `.gitignore`).
