#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?usage: scripts/release.sh <version> [notes.md]}"
NOTES="${2:-}"
TAG="v$VERSION"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PBXPROJ="$ROOT/DashboardViewer.xcodeproj/project.pbxproj"
cd "$ROOT"

[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "バージョンは x.y.z 形式で指定してください: $VERSION" >&2; exit 1; }
[[ "$(git branch --show-current)" == main ]] || { echo "main ブランチで実行してください" >&2; exit 1; }
[[ -z "$(git status --porcelain)" ]] || { echo "未コミットの変更があります" >&2; exit 1; }
if git ls-remote --exit-code --tags origin "$TAG" > /dev/null; then
  echo "$TAG は既にあります" >&2; exit 1
fi
[[ -z "$NOTES" || -f "$NOTES" ]] || { echo "リリースノートが見つかりません: $NOTES" >&2; exit 1; }

BUILD_NUMBER=$(( $(sed -n 's/.*CURRENT_PROJECT_VERSION = \([0-9]*\);/\1/p' "$PBXPROJ" | head -1) + 1 ))
sed -i '' -E \
  -e "s/MARKETING_VERSION = [0-9.]+;/MARKETING_VERSION = $VERSION;/" \
  -e "s/CURRENT_PROJECT_VERSION = [0-9]+;/CURRENT_PROJECT_VERSION = $BUILD_NUMBER;/" \
  "$PBXPROJ"
git commit -q -m "バージョンを $VERSION に上げる" -- "$PBXPROJ"
git push -q origin main

ZIP="$("$ROOT/scripts/build-notarized.sh")"

if [[ -n "$NOTES" ]]; then
  gh release create "$TAG" "$ZIP" --target main --title "$TAG" --notes-file "$NOTES"
else
  gh release create "$TAG" "$ZIP" --target main --title "$TAG" --generate-notes
fi
