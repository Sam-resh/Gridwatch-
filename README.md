# GridWatch QA

[![CI](https://github.com/Sam-resh/gridwatch-qa/actions/workflows/ci.yml/badge.svg)](https://github.com/Sam-resh/gridwatch-qa/actions/workflows/ci.yml)

A small **utilities asset-map web app** (poles, fibre cabinets, substations on a Leaflet map) built as the
*system under test* for a complete, production-style **test automation framework**.

The app is deliberately small. The quality engineering around it is the point:

- **Spec-driven:** requirements are written as Gherkin acceptance criteria in [`/specs`](specs) *before* tests.
- **Traceable:** every scenario links to automated tests; CI fails if one is left uncovered ([matrix](docs/TRACEABILITY.md)).
- **Layered:** browser E2E (Playwright), API contract tests (httpx), and seed-data validation (JSON Schema).
- **Reproducible:** one command runs the whole suite in Docker; the same suite gates every PR in GitHub Actions.
- **AI-assisted, human-owned:** see [How I used AI](#how-i-used-ai).

**Live demo:** _add your Render URL here after deploying_ &nbsp;|&nbsp; **Latest test report:** _add your GitHub Pages URL here_

## Test pyramid

| Layer | Tooling | Location | Cases |
|---|---|---|---|
| Browser E2E | Playwright (Python) + pytest, Page Object pattern | `tests/e2e` | TC-101 to TC-306 |
| API contract | pytest + httpx | `tests/api` | TC-401 to TC-410 |
| Data quality | pytest + jsonschema | `tests/data` | TC-501 to TC-505 |

42 automated test cases (34 test functions, expanded by parametrisation). Traceability: 31/31 scenarios automated.


## What the app does

| Feature | Requirement |
|---|---|
| Toggle asset layers (poles / fibre cabinets / substations) | REQ-001 |
| Filter by status (active / faulty / maintenance) | REQ-002 |
| Search by ID or name (case-insensitive) | REQ-003 |
| Report and resolve faults, with validation | REQ-004 |
| Validated REST API (GeoJSON) | REQ-005 |
| Trustworthy seed dataset | REQ-006 |

The data is **fictional**, generated deterministically by `scripts/generate_assets.py`.

## Design decisions worth reading

- **Independent oracle.** Expected counts come from the seed file, never from the API being tested.
- **Isolation over speed.** A test-only `/api/admin/reset` (off unless `GRIDWATCH_ENABLE_RESET=1`) restores seed data before every test.
- **Deterministic browser tests.** Map tiles are disabled via `?tiles=off`, so no third-party network dependency.
- **Accessible locators first.** Tests use roles and labels (`get_by_role`, `get_by_label`), so they double as accessibility checks.
- **Security regression.** TC-305 proves fault text containing HTML is rendered inert (no XSS).
- **Test the tests.** I mutation-checked the suite: deliberately breaking layer logic, output escaping and duplicate-fault handling each made tests fail.

## Quality documents

| Document | Purpose |
|---|---|
| [`docs/TEST_STRATEGY.md`](docs/TEST_STRATEGY.md) | Scope, risks, layers, environments, exit criteria |
| [`docs/TRACEABILITY.md`](docs/TRACEABILITY.md) | Requirement to scenario to test matrix (generated) |
| [`docs/EXPLORATORY_CHARTER.md`](docs/EXPLORATORY_CHARTER.md) | Session-based exploratory testing |
| [`docs/bugs/`](docs/bugs) | Defect reports found by exploratory testing |
| [`docs/AI_REVIEW_LOG.md`](docs/AI_REVIEW_LOG.md) | Where AI-generated tests were wrong and how I fixed them |

## How I used AI

AI assistants drafted the first version of tests from the Given/When/Then specs. I treated every output as untrusted:
each test was reviewed, run, and mutation-checked before it was committed. [`docs/AI_REVIEW_LOG.md`](docs/AI_REVIEW_LOG.md)
records what the AI got wrong. I kept full ownership of what is committed.


## CI

`.github/workflows/ci.yml` runs lint, the traceability check, the full suite, and a Docker Compose run on every PR.
On `main` it publishes the HTML report to GitHub Pages.

## Licence

MIT
