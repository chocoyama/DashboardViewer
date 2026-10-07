# DashboardViewer

登録した URL だけを表示し、それ以外のページへの遷移はデフォルトブラウザで開く macOS 用ダッシュボードアプリ（macOS 26 以降）。
アプリ内で開く範囲（同じホスト・ドメインとサブドメイン）はダッシュボードごとに広げられる。

## 開発

```bash
# ビルド
xcodebuild -project DashboardViewer.xcodeproj -scheme DashboardViewer -configuration Debug -destination platform=macOS -derivedDataPath .build/DerivedData build

# テスト（DashboardKit/ で実行）
swift test
```

## リリース

```bash
scripts/release.sh 0.4.0 notes.md
```

バージョンを上げて main にプッシュし、Developer ID 署名・公証済みの zip を添付した GitHub Release を作る。
notes.md を省略するとリリースノートは GitHub が自動生成する。zip を作るだけなら `scripts/build-notarized.sh`。

事前に必要なもの（端末ごとに 1 回）:

- キーチェーンに Developer ID Application 証明書（チーム 29C6ELZ3SW）
- notarytool の認証情報: `xcrun notarytool store-credentials notary --team-id 29C6ELZ3SW`
