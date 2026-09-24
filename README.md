# vsdd_testdrive

A small Flutter app for test-driving the [VSDD kit](https://github.com/joecrowley/vsdd-kit)
installation. **VSDD is deliberately not configured here:** there is no `openspec/`,
no `AGENTS.md` and no AI-tool folders. That way the setup runbook takes its
fresh-install path.

## The app

A reading list. Books load from a fake remote API with simulated latency. Tapping a
book opens a detail screen where you can change its reading status.

```
lib/
├── main.dart, app.dart          # wiring + go_router (/ and /books/:id)
├── domain/                      # Book, BookId (extension type), Result, BookRepository, use cases
├── data/                        # BookApi (fake remote), ApiBookRepository
└── presentation/
    ├── reading_list/            # ReadingListCubit + sealed ReadingListState, list screen
    └── book_detail/             # detail screen, status picker
test/                            # bloc_test for the Cubit, widget test for navigation
```

There's enough structure for the agent to seed real diagrams: the module hierarchy
(presentation → domain ← data), the end-to-end data flow (screen → Cubit → use case
→ repository → API), the `ReadingListState` state machine, and the go_router routes.
There is no backend or infrastructure code, so the "System Topology" diagram should be
skipped.

```bash
fvm flutter test
fvm flutter run -d macos
```

## Test-driving the installation

1. Start from a clean tree. The baseline commit is `baseline: app without VSDD`.
2. Open this folder in your AI coding tool and say:
   > Follow `/Volumes/LacieStore/flutter/vsdd-kit/SETUP.md` to install VSDD into this project.
3. Check the result:

| Check | Expected |
|---|---|
| Step 0 | Detects a fresh install, and asks you to confirm the tools |
| Step 1 | `openspec init` runs (there is no `openspec/` yet) |
| Step 3 | `config.yaml` `context:` describes *this* app (reading list, Cubit, go_router), not placeholders |
| Step 4 | `AGENTS.md` is **created**. `CLAUDE.md` is created only if you chose Claude Code |
| Step 5 | `install_overlay.py --check` → `VSDD overlay OK.` |
| Step 6 | `openspec/specs/architecture/diagrams.md` uses real names (`ReadingListCubit`, `GetReadingList`, `ApiBookRepository`, `BookApi`), and there is no topology diagram |
| Step 8 | The smoke-test change is gone, and `python3 scripts/vsdd/validate_mermaid.py --render` passes |
| Step 9 | The summary lists the decisions made and anything needing attention |

Then try a real change, for example:

> /opsx:propose add a "notes" field to books, editable on the detail screen

The `diagrams.md` should record a YES gate. Its Before state should be copied
verbatim from the seeded diagrams, and its After state should add the new flow.

## Resetting for another run

```bash
git reset --hard baseline && git clean -fd
```

This removes everything the installation added (`openspec/`, `AGENTS.md`, tool
folders and scripts). Build caches are kept. The `baseline` tag marks the starting
point.
