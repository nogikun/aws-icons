# AWS draw.io アイコンライブラリ

AWSのアイコンパッケージから、draw.io（diagrams.net）で使えるSVGライブラリを生成するリポジトリです。ZIP内のSVGをそのまま埋め込み、PNGとmacOSのメタデータは除外しています。

## Getting Started

### 1. AWS公式パッケージを取得する

[AWS Architecture Icons](https://aws.amazon.com/architecture/icons/) を開き、ページ内の **Icon package** から最新のZIPをダウンロードします。AWSはアイコンパッケージを定期更新しているため、再生成するときもこの公式ページから取得してください。第三者サイトのミラーは使わないでください。

### 2. draw.ioライブラリを生成する

Nix（flakes有効）とdirenvを使える環境で、リポジトリのルートを開きます。初回は次を実行して開発環境を許可します。

```sh
direnv allow .
mkdir -p icons
```

ダウンロードしたZIPを `icons/Icon-package.zip` として保存し、次を実行します。ZIPは展開不要です。

```sh
task drawio:build ICON_PACKAGE=icons/Icon-package.zip
```

4種類のライブラリが `build/drawio_libs/` に生成されます。日付付きファイルはそのパッケージ版の出力で、`build/drawio_libs/current/` にはVS Codeから参照する固定名の最新版が出力されます。生成物と入力ZIPは `.gitignore` の対象です。

### 3. draw.ioで使う

VS Codeでは、Draw.io Integration拡張の図形パネルで **その他の図形 → Custom Libraries** を開き、使うAWSライブラリを選んで **Apply** します。draw.io単体では **ファイル → ライブラリを開く → デバイスから** を選び、`build/drawio_libs/` 内のXMLを開きます。

### AWSアイコンの利用条件

AWSの公式ページは、アイコンをアーキテクチャ図の作成に使えると案内し、サードパーティツールの既存ライブラリにも言及しています。一方、ダウンロードしたSVGや、それを埋め込んだXMLを公開リポジトリで再配布できるかは、公式ページだけでは明確に確認できませんでした。AWS Site Termsでは、別途許諾がない場合のダウンロード素材の利用条件を定めています。このリポジトリのコードやスクリプトのライセンスは、AWSアイコンには適用されません。

ZIPはAWS公式ページから各自取得してください。AWS公式サンプルプロジェクトも、利用条件を理由にアイコンを同梱せず、利用者が別途取得する方式を採っています。生成XMLにはAWSのSVGが埋め込まれるため、公開リポジトリへのコミットも再配布にあたる可能性があります。明示的な許諾を確認するまでは、生成XMLの公開リポジトリへのコミットや、その他の公開・再配布は保留してください。

参照: [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/)、[AWS Site Terms](https://aws.amazon.com/terms/)、[AWS公式サンプルのアイコン取得手順](https://github.com/aws-samples/sample-architecture-diagram-mcp-server#setup)

## ライブラリ

| ライブラリ | SVG数 | ファイル |
| --- | ---: | --- |
| AWS Architecture Services | 1,208 | `build/drawio_libs/current/AWS-Architecture-Services.xml` |
| AWS Resource Icons | 515 | `build/drawio_libs/current/AWS-Resource-Icons.xml` |
| AWS Category Icons | 104 | `build/drawio_libs/current/AWS-Category-Icons.xml` |
| AWS Architecture Groups | 15 | `build/drawio_libs/current/AWS-Architecture-Groups.xml` |

これらはGetting Startedの手順でローカルに生成するファイルです。更新前の版も参照できるよう、日付付きのXMLも`build/drawio_libs/`直下に残ります。

### VS Codeで使う

VS CodeのDraw.io Integration（`hediet.vscode-drawio`）では、ワークスペース設定からAWSライブラリを登録します。draw.ioエディターの図形パネルで **「その他の図形」** を開き、Custom LibrariesにあるAWSライブラリにチェックを入れて **Apply** してください。図形パネルからアイコンを検索・配置できます。

`.vscode/settings.json`は`build/drawio_libs/current/`を参照します。ZIPを変えて再生成しても、このフォルダの固定名ファイルは最新の出力に更新されます。設定を追加した直後は、開いているdraw.ioエディターを一度閉じて開き直してください。

### draw.io単体で使う

draw.ioで **ファイル → ライブラリを開く → デバイスから** を選び、`build/drawio_libs/`のXMLを開いてください。バージョンによっては **ファイル → ライブラリをインポート → デバイスから** と表示されます。通常の **ファイル → インポート** でXMLを図面に入れると、ライブラリではなくJSONテキストが図面上に配置されます。XMLをキャンバスへドラッグする操作も使わないでください。

アイコンは拡大縮小できるSVG画像として配置されます。元のパスと色を保ち、SVGのパスごとに編集できるdraw.io図形には変換していません。

## フォルダ構成

```text
.
├── README.md
├── Taskfile.yml
├── .vscode/
│   └── settings.json             # VS Code拡張にAWSライブラリを登録
├── build/
│   └── drawio_libs/              # 生成物（Git管理対象外）
│       ├── current/              # VS Code用の最新版（固定ファイル名）
│       └── AWS-*-<日付>.xml     # 日付付きの生成ファイル
├── icons/
│   └── Icon-package.zip          # 入力（Git管理対象外）
└── skills/
    └── aws-drawio-import/            # Agent Skill（npx skills addで導入可）
        ├── SKILL.md
        └── scripts/
            └── build_aws_drawio_libraries.py  # ZIPからライブラリを生成
```

## Taskを使わない場合の再生成

Taskを使わずに再生成する場合は、入力ZIPと出力先を指定してスクリプトを直接実行します。

```sh
mise exec -- python3 skills/aws-drawio-import/scripts/build_aws_drawio_libraries.py \
  icons/Icon-package.zip \
  --output-dir build/drawio_libs
```

uvを使う場合は`uv run`でも実行できます。標準ライブラリのみを使うため、追加パッケージのインストールは不要です。

```sh
uv run --no-project --python 3.11 skills/aws-drawio-import/scripts/build_aws_drawio_libraries.py \
  icons/Icon-package.zip \
  --output-dir build/drawio_libs
```
