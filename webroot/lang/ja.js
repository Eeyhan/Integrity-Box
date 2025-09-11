// Language: Japanese
// Translated by: Re*Index.(ot_inc) @reindex-ot

// [SECTION 1] Translate the text inside " "
export const translations = {
  "ja": [
    "ホワイトリストモードを無効化",
    "ホワイトリストモードを有効化",
    "カスタム PIF フィンガープリントを設定",
    "PIF インジェクションの値を偽装 / 偽装を解除",
    "PIF Fork の値を偽装 / 偽装を解除",
    "GMS のプロセスを強制停止",
    "「デバイスは認定されていません」の状態を修正",
    "Keybox を更新",
    "すべてのアプリをターゲットリストに追加",
    "ユーザーアプリのみをターゲットリストに追加",
    "デフォルトの Keybox に切り替え",
    "オープンソースの Keybox に切り替え",
    "Tricky Store パッチの偽装",
    "BAN 済みの Keybox リストを取得",
    "SusFS 構成を更新",
    "確認付きブートハッシュを設定",
    "内蔵の GMS 偽装を有効化",
    "Hide Spoofing Props の検出",
    "PixelOS の偽装",
    "Xiaomi EU の偽装",
    "HentaiOS の偽装",
    "Derpfest の偽装",
    "アブノーマルの検出",
    "フラグ済みのアプリ",
    "Props の検出",
    "開発者をサポート",
    "更新チャンネルに参加",
    "ヘルプグループに参加",
    "ソースコード",
    "Issue/Bug で報告",
    "SELinux ステータスを切り替え",
    "モジュールの情報",
    "WebUI をリサイズ",
    "モーダルを自動で閉じるを切り替え",
    "ゲームで遊ぶ",
    "WebUI イントロの有効化 / 無効化",
    "エクストラ WebUI 機能を表示 / 非表示"
  ]
};

// [SECTION 2] Translate the text inside { }
export const buttonGroups = {
  "Whitelist": { "ja": "ホワイトリスト" },
  "PIF": { "ja": "Play Integrity Fix" },
  "TS": { "ja": "Tricky Store" },
  "Sus": { "ja": "SusFS" },
  "CrSpoof": { "ja": "カスタム ROM の偽装" },
  "Check": { "ja": "診断" },
  "Help": { "ja": "コミュニティとサポート" },
  "Basic": { "ja": "基本" },
  "TimePass": { "ja": "ゲーム" },
  "Extra": { "ja": "エクストラ" }
};

// [SECTION 3] There's nothing to translate in this section
export const buttonOrder = [
  "stop.sh", "start.sh", 
  "pif.sh", "spoof.sh", "piffork.sh", "kill.sh", "vending.sh",  "key.sh",
  "systemuser.sh", "user.sh", "keybox.sh", "aosp.sh", "patch.sh", "banned.sh",
  "sus.sh", "boot_hash.sh",
  "setprop.sh", "resetprop.sh", "pixelos.sh", "xiaomi.sh", "helluva.sh", "derpfest.sh",
  "abnormal.sh", "app.sh", "prop.sh",
  "support", "meowdump.sh", "meowverse.sh", "info.sh", "report.sh",
  "selinux.sh", "module_info.sh", "resize.sh", "modal.sh",
  "game.sh",
  "intro.sh", "webui.sh"
];