#!/usr/bin/env bash
# 個人サイト (susumutomita.github.io) の public/notes/ へノートを配る。
# このリポジトリを唯一の正としてコピーするので、編集はこちらだけで行う。
#
# 使い方:
#   bash scripts/sync-to-site.sh [site-repo-path]
#
# 既定の配布先: ~/product/susumutomita.github.io
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SITE="${1:-$HOME/product/susumutomita.github.io}"

[[ -d "$SITE/public" ]] || {
  echo "error: $SITE は Astro サイトのリポジトリではないようです (public/ が無い)" >&2
  exit 1
}

shopt -s nullglob
weeks=("$REPO_ROOT"/week*/index.html)
(( ${#weeks[@]} )) || { echo "error: 配布するノートがありません" >&2; exit 1; }

for src in "${weeks[@]}"; do
  week="$(basename "$(dirname "$src")")"          # week1, week2, ...
  dest_dir="$SITE/public/notes/ac2026-$week"
  mkdir -p "$dest_dir"
  cp "$src" "$dest_dir/index.html"
  echo "copied $week -> public/notes/ac2026-$week/index.html"
done

echo
echo "次にサイト側で:"
echo "  cd $SITE && bun run build   # 反映を確認"
