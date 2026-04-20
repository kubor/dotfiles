# 開発スタイル

- TDD で開発する（探索 → Red → Green → Refactoring）
- KPI やカバレッジ目標が与えられたら、達成するまで試行する
- 不明瞭な指示は質問して明確にする
- 無駄なコンテキストの増加を防ぐためタスクは適切な Sub Agent に委譲する

# コード設計

- 関心の分離を保つ
- 状態とロジックを分離する
- 可読性と保守性を重視する
- 静的検査可能なルールはプロンプトではなく、linter か ast-grep で記述する

# ツール

- タスク: justfile
- E2E: playwright
- バージョン管理: mise

# 環境

- GitHub: kubor
- リポジトリ: ghq 管理（`~/ghq/github.com/owner/repo`）

# スキル作成

新規 skill を作るとき、配置先を次の指針で決める:

- **project 固有** (`<repo>/.claude/skills/` に置く): 特定 repo のドメイン知識・規約に依存
- **グローバル** (`~/.claude/skills/` 直置き or APM global): 言語・ツール横断、複数 repo で再利用可能
- **判断不能なとき**: ユーザーに質問してから作成
