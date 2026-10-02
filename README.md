# workflows

Shared GitHub Actions for the dicta-* Cypress test repos.

- `.github/workflows/cypress-tests.yml` – reusable workflow (install, run `toolTests.js` / `requestsTests.js` – or their `.cy.js` names, build mochawesome report, deploy to gh-pages under `/<browser>/`).
- `chrome-tests.yml`, `edge-tests.yml`, `firefox-tests.yml` – caller templates. Copy them into a test repo's `.github/workflows/`, then set:
  - the `schedule` crons,
  - which specs run: the `'true'`/`'false'` fallbacks in `with:` (scheduled runs) and the matching `default:` of the `workflow_dispatch` inputs (manual runs).

  Callers that don't pass `tool-tests` / `requests-tests` fall back to `TOOL_TESTS` / `REQUESTS_TESTS` in the repo's `cypress.config.js`.

Callers pin `@v2`. After changing the reusable workflow, create a new tag (`v3`, ...) and update the callers; moving an existing tag needs a force push.
