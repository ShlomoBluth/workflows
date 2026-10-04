# workflows

Shared GitHub Actions for the dicta-* Cypress test repos.

- `.github/workflows/cypress-tests.yml` – reusable workflow (install, run `toolTests.js` / `requestsTests.js` – or their `.cy.js` names, build mochawesome report, deploy to gh-pages under `/<browser>/`).
- `chrome-tests.yml`, `edge-tests.yml`, `firefox-tests.yml` – caller templates. Copy them into a test repo's `.github/workflows/`, then set:
  - the `schedule` crons,
  - which specs run: the `'true'`/`'false'` fallbacks in `with:` (scheduled runs) and the matching `default:` of the `workflow_dispatch` inputs (manual runs).

  Callers that don't pass `tool-tests` / `requests-tests` fall back to `TOOL_TESTS` / `REQUESTS_TESTS` in the repo's `cypress.config.js`.

Callers pin `@v2`. After changing the reusable workflow, create a new tag (`v3`, ...) and update the callers; moving an existing tag needs a force push.

## Shrinking a repo's gh-pages history

`scripts/reset-ghpages.sh dicta-<tool>` replaces a repo's `gh-pages` branch with one commit holding its
current report files (old test videos dropped). It reads the file list through the GitHub API, so the old
history is never downloaded. It force-pushes, and GitHub rejects it while the repo is over its size quota.
GitHub frees the old objects only after its own garbage collection.
