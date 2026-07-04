---
name: java-dev
description: Java開発に関するガイドライン。Javaのコードを書く際やテストを実行する際に使用する。
user-invocable: false
---

# Java開発ガイドライン

## Test

### テストフレームワーク

JUnit5を使用する。

### テスト作成方針

テスト設計の考え方（何をテストするか、振る舞いの検証、
テストの独立性、モック方針等）は `test-design` を参照。
ここでは JUnit5 / Mockito での書き方のポイントを示す。

- **ParameterizedTest**: 同じロジックを複数の入力で
  検証する場合に使用（`@ValueSource` / `@CsvSource` 等）
- **共通セットアップ**: `@BeforeEach` で各テスト前の初期化を
  集約し、テストの独立性を保つ
- **振る舞いの検証**: public メソッド経由で結果を検証し、
  private フィールドや内部状態は直接検証しない
- **@Nested**: 関連するテストを内部クラスでグループ化し、
  構造を階層化して可読性を上げる
- **@DisplayName**: メソッド名で意図が伝わりにくい場合に
  自然言語（日本語可）で説明を付す

### モック (Mockito)

- `@ExtendWith(MockitoExtension.class)` と `@Mock` を使用する
- モック対象はシステム境界のみ（Repository・外部APIクライアント、
  時刻 `Clock`・乱数など制御したい要素）。方針は `test-design` 参照
- スタブは `when(...).thenReturn(...)` で定義する

### テスト実行して検証する場合

以下のように最小限のテストケースを実行するようにする。

```bash
# sut-mvn-moduleモジュールのXXXTestクラスのyyyTestMethodメソッドを実行する
mvn test -pl sut-mvn-module -Dtest=XXXTest#yyyTestMethod
```

全単体テストを実行したい場合は以下で良い

```bash
mvn clean install
```
