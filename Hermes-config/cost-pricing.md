# 💲 Таблица цен инструментов Hermes (Cost Pricing)

Ставки для оценки стоимости запросов в журнале `cost-ledger.md` (правило `SOUL.md` §8).

> ⚠️ Цены **ориентировочные**, для прикидки. Где инструмент возвращает фактическую стоимость в ответе
> (Perplexity) — всегда берём её, а не эту таблицу. Точные суммы сверять в биллинге сервиса/Helicone.
> Проверять эмпирически (правило проекта «проверять ключи и факты эмпирически»).

## Платные per-request (считаем всегда)

| Инструмент | Модель/единица | Ориентир. ставка | Откуда брать точную |
|---|---|---|---|
| **Perplexity** | `sonar` | ~$0.005/запрос + токены | `usage.cost.total_cost` в ответе ✅ |
| **Perplexity** | `sonar-pro` | дороже sonar (поиск+токены) | ответ API ✅ |
| **Perplexity** | `sonar-reasoning-pro` | + reasoning-токены | ответ API ✅ |
| **Perplexity** | `sonar-deep-research` | самый дорогой (многошаговый) | ответ API ✅ |
| **DeepSeek v4** (дефолт) | `deepseek-chat` | ≈$0.27/1M вход · ≈$1.10/1M выход | Helicone / биллинг DeepSeek |
| **OpenRouter** | любая модель (`chat_completion` MCP) | зависит от модели | `usage.cost` в ответе ✅ (факт. проверено 21.06: claude-haiku-4.5 = $0.000034) |
| **OpenRouter** | `openrouter/pareto-code` (Pareto Code Router) | цена авто-выбранной модели, проходящей `min_coding_score` | `usage.cost` в ответе ✅ |
| **OpenRouter** | повтор идентичного запроса в течение 300с (`response_cache`) | **$0 — бесплатно** (edge-кэш) | заголовок `X-OpenRouter-Cache`, см. SOUL.md §4.3 |
| **OpenRouter** | `minimax/minimax-m3` | $0.30/1M вход · $1.20/1M выход (cache read $0.06/1M) — дешевле всех в таблице | `usage.cost` в ответе ✅, факт. проверено 22.06 |
| **Gemini** | через `@houtini/gemini-mcp` | по прайсу Google AI | Google AI Studio биллинг |
| **Replicate** | per run / per second GPU | зависит от модели (~$0.0005–0.05/сек) | replicate.com биллинг |
| **ElevenLabs** | TTS/STT | по символам/плану | elevenlabs.io usage |
| **Runway** | видео-кредиты | по кредитам Gen-модели | runwayml.com биллинг |
| **Firecrawl** | `scrape` (1 страница, markdown) | 1 кредит | факт. проверено 21.06: `creditsUsed:1` |
| **Firecrawl** | `map` (карта URL сайта) | 0 кредитов (бесплатно) | факт. проверено 21.06 |
| **Firecrawl** | `search` (веб-поиск без скрапа) | ≈1.3 кредита/результат | факт. проверено 21.06: 3 результата = 4 кредита |
| **Firecrawl** | `v2/scrape` с `json`-форматом (структур. данные по схеме) | 5 кредитов | факт. проверено 21.06 — **используй этот**, не extract |
| **Firecrawl** | `/v1/extract` (⚠️ deprecated) | 22 кредита | НЕ использовать, см. SOUL.md §5/§9 |
| **Firecrawl** | план | 1000 кредитов / billing-период (фикс-пул, не $/запрос) | firecrawl.dev/billing — $ за кредит API не отдаёт |
| **Apify** | акторы | compute units + per-result | apify.com биллинг |

## Обычно фикс-подписка / free-tier (per-request не считаем)
Notion, Supabase, GitHub, Vercel, LangSmith, **Helicone** (учёт), Miro, n8n, Make,
PostMyPost, YouGile, Chroma, Sentry, Pinecone, Qdrant, Context7, Smithery, Google Calendar —
тарифицируются планом/лимитами, а не за вызов. Если конкретный сервис перешёл на оплату за запрос — добавить сюда строку и учитывать.

---
Обновлено: 2026-06-22 (добавлен `minimax/minimax-m3` через OpenRouter). При подключении нового платного инструмента — дополнять таблицу.
