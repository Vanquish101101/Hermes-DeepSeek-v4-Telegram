# ORCHESTRATION — Департамент веб-разработки Project CORE

> ⛔ **ДЕАКТИВИРОВАНО (21.06.2026).** Этот алгоритм сохранён как именованная инструкция
> **«Инструкция к оркестрации 2 (Мой вариант)»** (`Departments/Инструкция к оркестрации 2 (Мой вариант).md`) и сейчас **НЕ применяется**.
> Не запускать департамент/оркестратор до команды «активируй Инструкцию к оркестрации 2».
> Лёгкая альтернатива — «Инструкция к оркестрации 3 (Неиспользуемая версия)» (бывшая «1 (Foresight)»,
> переименована и тоже деактивирована 23.06.2026 — пользователь собирает новую оркестрацию).

Оркестратор + 30 специалистов (31 субагент в `.claude/agents/`). Точка входа — `core-director`.

---

## Спецификация (по запросу заказчика, 7 пунктов)
1. **Главный оркестратор** — `core-director` («генеральный директор»): принимает любую задачу, определяет нужный департамент, распределяет и контролирует выполнение и качество.
2. **Департамент full-stack** — 7 отделов специалистов по веб-разработке полного цикла.
3. **Навыки агентам** — каждый агент наделён ресурсами из MCP + скилами Skill SH + внутренними скилами Hermes (матрица ниже).
4. **Докачка недостающего** — если для задачи нужен агент/скил, которого нет — доустановить и активировать (через Skill SH / Smithery MCP).
5. **Поток задач** — задача → ген.директор → нужный департамент → лид отдела дробит на подзадачи → агент с нужными навыками выполняет.
6. **Тестирование** — после разработки отдел QA/тест (qa-test-engineer + observability-engineer) проверяет выполненную работу (verify / playwright / code-review).
7. **Демо-ссылка** — если всё сделано правильно и работает, выдать ссылку на демо-версию, развёрнутую на локальном сервере, для просмотра (`npm run dev` → `http://localhost:<port>`).

---

## Граф (директор → отделы → агенты)
```
                         ┌──────────────────────┐
                         │   00 core-director    │  ← вход задачи, контроль качества
                         └───────────┬───────────┘
       ┌───────────┬───────────┬─────┴─────┬───────────┬───────────┬───────────┐
   ┌───▼───┐   ┌───▼───┐   ┌───▼───┐   ┌───▼───┐   ┌───▼───┐   ┌───▼───┐   ┌───▼───┐
   │1x Стра│   │2x Диз │   │3x Фрнт│   │4x Бэк │   │5x Конт│   │6x Мркт│   │7x Ops │
   │тегия  │   │айн/Арт│   │енд    │   │энд    │   │ент/Мед│   │инг    │   │QA/PM  │
   └───┬───┘   └───┬───┘   └───┬───┘   └───┬───┘   └───┬───┘   └───┬───┘   └───┬───┘
   research    art-dir    frontend    backend     content     mktg-lead   devops
   market      ux-resrch  react-next  api-eng     copywriter  smm         qa-test
   seo         ui-design  webgl-3d    database                            observ.
               motion     animation   auth-sec                            project-mgr
               threed     game-dev    integrations
                                      ai-ml
```
Лиды отделов: research-lead, art-director, frontend-lead, backend-lead, content-lead, marketing-lead, project-manager. Каждый лид дробит задачу и раздаёт своим агентам; результаты сходятся обратно к `core-director`.

---

## Матрица «навыки → агент» (MCP + Skill SH + Hermes/CC скилы)
| Отдел / агент | MCP-ресурсы | Скилы |
|---|---|---|
| **core-director** | YouGile (kanban) | управление, делегирование |
| research-lead · market-competitor-analyst · seo-strategist | WebSearch/WebFetch, ChromaDB (память) | `seo-audit`, анализ конкурентов |
| art-director · ui-designer · ux-researcher · motion-designer | — | `frontend-design` |
| threed-artist | — | `3d-web-experience` (3D-web) |
| frontend-lead · react-nextjs-engineer | context7, playwright | `frontend-design`, `JS-patterns` |
| webgl-3d-engineer · interactive-game-dev | — | `3d-web-experience`, `game-dev` |
| animation-engineer | playwright (проверка) | `JS-patterns` |
| backend-lead · api-engineer | Supabase | `backend-dev` |
| database-engineer | Supabase, ChromaDB (вектор/RAG) | `backend-dev` |
| auth-security-engineer | Supabase (RLS) | `security-review` |
| integrations-engineer | Smithery, n8n, Vercel | — |
| ai-ml-engineer | OpenRouter (роутинг моделей), ChromaDB (RAG), Gemini | — |
| content-lead · copywriter | — | `copywriting`, `content-strategy` |
| audio-producer | — | `ai-music` |
| video-producer · visual-image-artist | — | генерация медиа |
| marketing-lead · social-media-manager | — | `content-strategy` |
| **devops-engineer** | Vercel (CLI/MCP), GitHub | деплой/CI |
| **qa-test-engineer** | playwright, context7 | `verify`, `code-review` |
| **observability-engineer** | Sentry | мониторинг/логи |
| project-manager | YouGile | спринты/канбан |

> Недостающие навыки доустанавливаются по требованию: Skill SH (`/skills`), Smithery MCP (поиск/подключение), внутренние скилы Hermes.

---

## Алгоритм работы (по уровням делегирования) — ДОПОЛНЕНО 20.06
> Пока департамент ОДИН (веб-разработка full-stack), но структура расширяема — позже добавим другие департаменты.

- **Уровень 1 — Оркестратор** (`core-director`, ген.директор): понимает задачу → определяет, какому департаменту и каким агентам её отдать → делегирует и контролирует качество.
- **Уровень 2 — Лиды департамента** (research-lead / art-director / frontend-lead / backend-lead / content-lead / marketing-lead / project-manager): понимают, как лучше решить задачу, какие сервисы (MCP) и скилы уже есть, каким субагентам отдать, и какие наработки/решения уже существуют в мире.
- **Уровень 3 — Агенты**: понимают, какие инструменты и методы применить, и выполняют работу.

## Конвейер выполнения задачи (разведка → исполнение → тест → демо)
1. **Вход:** задача поступает к `core-director`.
2. **Маршрутизация:** директор определяет отдел(ы), ставит карточку (YouGile).
3. **🔎 OSINT / разведка (в НАЧАЛЕ):** отдел стратегии (`market-competitor-analyst` + `research-lead` + `seo-strategist`) проводит разведку, анализ конкурентов и поиск похожих решений/шаблонов — **только как вспомогательная информация и образцы, НЕ копирование**. **Основной инструмент шага — Perplexity MCP** (`sonar`/`sonar-pro` для фактов с источниками, `sonar-deep-research` для развёрнутого отчёта); дополняют Firecrawl (конкретные URL), Apify (скрап), x_search (соцсети).
4. **Декомпозиция:** лид отдела дробит задачу на подзадачи, назначает агентов с нужными навыками (см. матрицу).
5. **Исполнение:** агенты работают параллельно/последовательно; отделы выстраивают правильную взаимосвязь через лидов и оркестратора.
6. **(п.6) Тестирование:** спец-отдел QA — `qa-test-engineer` (verify/playwright/code-review) + `observability-engineer` (логи/ошибки) — проверяет точность, ошибки, конфликты.
7. **Контроль:** `core-director` принимает работу; при ошибках → возврат исполнителю на исправление (повтор п.5–6).
8. **(п.7) Демо:** если всё работает правильно — поднять локальный сервер и выдать ссылку `http://localhost:<port>` для просмотра демо-версии.

---

## Статус
- Департамент (31 агент) — **собран** (`.claude/agents/`).
- Граф + матрица навыков + конвейер (с тестом и демо) — **этот файл**.
- Запуск на живой задаче — по команде заказчика (дать конкретную задачу → прогнать по конвейеру).
