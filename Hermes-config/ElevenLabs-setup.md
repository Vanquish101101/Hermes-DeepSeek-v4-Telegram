# ElevenLabs MCP — настройка и архитектура озвучки/голоса (добавлено 2026-06-22, версия 1.12.0)

ElevenLabs был подключён к Hermes (`config.yaml`, `enabled: true`) ещё в прошлой версии, но до этого
этапа не имел роли в оркестрации.

## Где настроено (файл в `AppData\Local\hermes\`, в репо не коммитится)
**`config.yaml` → `mcp_servers.elevenlabs`**:
```yaml
elevenlabs:
  command: uvx
  args: ["elevenlabs-mcp"]
  env:
    ELEVENLABS_API_KEY: sk_***************************acf
  enabled: true
```
Официальный пакет, переменная названа стандартно (`ELEVENLABS_API_KEY`) — без квирков в духе
Vercel/Replicate (`API_KEY`/`REPLICATE_API_TOKEN`).

**Отдельно от MCP** — тот же ключ уже используется как built-in провайдер голоса самого Hermes:
- `tts.elevenlabs` (`voice_id: pNInz6obpgDQGcFmaJgB`, `model_id: eleven_multilingual_v2`) — премиум-
  альтернатива активному бесплатному `tts.provider: edge`.
- `stt.elevenlabs` (`model_id: scribe_v2`, поддержка диаризации/audio-event-тегов) — премиум-
  альтернатива активному бесплатному `stt.provider: local`.

Эти два провайдера переключаются конфигом без участия MCP — пользователь сознательно держит
бесплатные опции активными, ElevenLabs доступен, но не включён по умолчанию.

## Архитектура
Полное описание — `SOUL.md` §16. Кратко: три слоя одного сервиса —
1. built-in TTS/STT провайдер (выбор пользователя, не трогать самостоятельно);
2. MCP-инструмент для прямых запросов (конкретный голос/клонирование/диаризация/Conversational AI);
3. департамент CORE (`52-audio-producer.md`) — ElevenLabs (голос) уже в одном стеке с Replicate MCP
   (музыка/звук, см. `Replicate-setup.md`) — этот этап формализует и эту связку.

## Проверка (эмпирически, 22.06.2026)
- Ключ **валиден, но ограничен по правам**: `GET /v1/user` и `/v1/user/subscription` → HTTP 401
  `missing_permissions` (нет права `user_read`), при этом `GET /v2/voices` и `/v1/models` → HTTP 200
  штатно. Не сломанный ключ — урезанный набор прав; баланс/план через API не прочитать.
- **Реальный тест полного цикла:** `POST /v1/text-to-speech/{voice_id}` (голос `Adam -
  Dominant, Firm`, модель `eleven_multilingual_v2`, текст «Hermes orchestration test.») →
  HTTP 200, 28 465 байт настоящего mp3, заголовок ответа `character-cost: 26`. Подтверждено через
  `GET /v1/history` — запись о генерации сохранена.
- `GET /v1/convai/agents` → `{"agents": [], "has_more": false}` — 0 предсуществующих агентов, чистый
  лист, ничего не трогали/не перезаписывали.

## Связанные правила/файлы
- `SOUL.md` §16 (архитектура, три слоя), §15 (Replicate — пара по тому же специалисту CORE),
  §8/§9 (учёт расходов — тарификация по символам, не фиксированный план), §10 (Notion — куда заносить
  находки про конкретные голоса/модели).
- `cost-ledger.md` — записи о проверочных вызовах ($0.00) и о реальном тесте синтеза речи
  (26 символов, оценочная стоимость).
- Память: `feedback_verify_keys_empirically` (новый оттенок — ключ валиден частично, не «сломан»),
  `project_replicate_orchestration` (тот же специалист CORE, парный сервис).
