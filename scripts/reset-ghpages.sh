#!/usr/bin/env bash
# Usage: reset-ghpages.sh <repo>
# Replaces gh-pages on GitHub with one commit holding the current report files (no videos).
# Reads the current file list through the GitHub API, so the old history is never downloaded.
set -e
r=$1
case "$r" in dicta-*) ;; *) echo "only dicta-* repos" >&2; exit 1 ;; esac
w=$(mktemp -d)/ghp-$r; git init -q -b gh-pages "$w"
curl -sf "https://api.github.com/repos/ShlomoBluth/$r/git/trees/gh-pages?recursive=1" > "$w.tree.json"
python -c "
import json,sys
d=json.load(open(sys.argv[1])); assert not d.get('truncated'), 'tree truncated'
for e in d['tree']:
  if e['type']=='blob' and not e['path'].endswith('.mp4') and '/videos/' not in '/'+e['path']: print(e['path'])" "$w.tree.json" > "$w.files"
while IFS= read -r p; do mkdir -p "$w/$(dirname "$p")"; curl -sfL "https://raw.githubusercontent.com/ShlomoBluth/$r/gh-pages/$p" -o "$w/$p"; done < <(tr -d '\r' < "$w.files")   # Windows python writes CRLF
git -C "$w" add -A
git -C "$w" commit -q -m "Reset gh-pages history: keep current reports, drop old test videos

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
echo "$r: $(wc -l < "$w.files") files, $(du -sh --exclude=.git "$w" | cut -f1)"
git -C "$w" push --force "https://github.com/ShlomoBluth/$r.git" gh-pages:gh-pages 2>&1 | grep -v '^remote: *$' | tail -4
rm -rf "$(dirname "$w")"
