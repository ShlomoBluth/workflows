# workflows

Shared GitHub Actions for the dicta-* Cypress test repos.

- `.github/workflows/cypress-tests.yml` – reusable workflow (install, run `toolTests.js` / `requestsTests.js`, build mochawesome report, deploy to gh-pages under `/<browser>/`).
- `chrome-tests.yml`, `edge-tests.yml`, `firefox-tests.yml` – caller templates. Copy them into a test repo's `.github/workflows/`.

Callers pin `@v1`. After changing the reusable workflow, move the tag (`git tag -f v1 && git push -f origin v1`) or create `v2` and update callers.
