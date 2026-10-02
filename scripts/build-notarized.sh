#!/usr/bin/env bash
# 標準出力は release.sh が受け取る zip のパスだけにするため、進捗は標準エラーに出す
set -euo pipefail

NOTARY_PROFILE="${NOTARY_PROFILE:-notary}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$ROOT/.build/release"
BUILT_APP="$ROOT/.build/DerivedData/Build/Products/Release/DashboardViewer.app"
APP="$WORK/DashboardViewer.app"

rm -rf "$WORK"
mkdir -p "$WORK"

echo "==> Release ビルド" >&2
xcodebuild -project "$ROOT/DashboardViewer.xcodeproj" -scheme DashboardViewer -configuration Release \
  -destination "generic/platform=macOS" -derivedDataPath "$ROOT/.build/DerivedData" build \
  > "$WORK/build.log" 2>&1 || { tail -30 "$WORK/build.log" >&2; exit 1; }
ditto "$BUILT_APP" "$APP"

echo "==> 公証" >&2
ditto -c -k --keepParent "$APP" "$WORK/notarize.zip"
xcrun notarytool submit "$WORK/notarize.zip" --keychain-profile "$NOTARY_PROFILE" --wait >&2

echo "==> staple と Gatekeeper の確認" >&2
xcrun stapler staple "$APP" >&2
spctl --assess --type exec -vv "$APP" >&2

ditto -c -k --keepParent "$APP" "$WORK/DashboardViewer.zip"
echo "$WORK/DashboardViewer.zip"
