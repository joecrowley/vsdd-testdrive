# vsdd_testdrive

A small, deliberately **bare** Flutter app for test-driving the
[VSDD kit](https://github.com/joecrowley/vsdd-kit): OpenSpec plus Visual
Spec-Driven Development. Neither is configured yet. There is no `openspec/`, no
`AGENTS.md` and no AI-tool folders, so the installation takes its fresh-install path.

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

```bash
fvm flutter test          # 4 tests
fvm flutter run -d macos
```

## Next steps: add OpenSpec and VSDD

The full guide, including a worked example change, is
**[docs/VSDD_WALKTHROUGH.md](docs/VSDD_WALKTHROUGH.md)**. In short:

1. **Install the OpenSpec CLI** (≥ 1.2.0):

   ```bash
   npm install -g @fission-ai/openspec@latest
   ```

2. **Get the kit:**

   ```bash
   git clone git@github.com:joecrowley/vsdd-kit.git /Volumes/LacieStore/flutter/vsdd-kit
   ```

3. **Let your AI agent install it.** Open this folder in Claude Code, OpenCode, Qwen
   Code or similar, and say:

   > Follow `/Volumes/LacieStore/flutter/vsdd-kit/SETUP.md` to install VSDD into this project.

   The agent runs the kit's
   [`SETUP.md`](https://github.com/joecrowley/vsdd-kit/blob/main/SETUP.md). It works
   on a new `vsdd-install` branch and saves a snapshot first, so it can be undone. It
   initialises OpenSpec, installs the `visual-driven` schema, writes the config and
   `AGENTS.md`, patches the skills, seeds architecture diagrams from `lib/`, and
   smoke-tests the result. It asks you only a few questions.

4. **Check the install:** see [§4 of the walkthrough](docs/VSDD_WALKTHROUGH.md#4-check-what-was-installed).

5. **Make your first visual change:** the walkthrough adds book notes end to end,
   covering propose → diagrams review → apply (including a deliberate deviation) →
   verify → archive. See [§5](docs/VSDD_WALKTHROUGH.md#5-walkthrough-a-change-that-needs-diagrams).

## Resetting

Ask your agent to follow "Roll back an install" in the kit's `SETUP.md`, or see
[§8 of the walkthrough](docs/VSDD_WALKTHROUGH.md#8-reset-and-repeat). In short:
switch back to `main`, restore the install snapshot, and delete the `vsdd-install`
branch.

For a quick reset of the project folder only (commit and push anything you want to
keep first, since this discards uncommitted changes and unpushed commits on `main`):

```bash
git switch main && git reset --hard origin/main && git clean -fd
```

This returns the project to the bare app with the latest docs. It doesn't touch
gitignored files or your global OpenSpec config.
