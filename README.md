# 4d-tips-create-indexes-on-sum-fields.md
すべてのSumフィールドにインデックスを設定する例題

[メソッド](https://github.com/4D-JP/4d-tips-create-indexes-on-sum-fields/blob/main/v18/set_index_for_sum/Project/Sources/Methods/TEST.4dm)

数値フィールドにインデックスが設定されていないストラクチャが対象です。

<img width="320" alt="structure" src="https://user-images.githubusercontent.com/10509075/103191665-234a1600-4919-11eb-8dce-849a3b8447d0.png">

メソッドを実行するとコードが解析され，`Sum`の対象となっている非インデックスフィールドが抽出されます。

* 解析できるコードの例：

```4d
$sum:=Sum([Table_1]Field_2)
$sum:=Sum(Field(2;3)->)
```

* 解析できないコードの例：

```4d
$p:=->[Table_1]Field_2
// …
$sum:=Sum($p->)
```

解析できなかったコードの情報はログファイルに出力されます。

```json
[
	{
		"method": "[tableForm]/Table_2/TEST/Button",
		"line": "$sum:=Sum:C1($p->)",
		"value": "$p->"
	}
]
```

* `$dry_run`を`True`に設定した場合，インデックスを追加するためのコードがファイルに出力され，ペーストボードにセットされます。

対象ストラクチャがv17以前の場合はこちらのオプションを使用してください。

```4d
ARRAY POINTER:C280($fieldsArray;1)
$fieldsArray{1}:=Field:C253(1;3)
CREATE INDEX:C966(Table:C252(1)->;$fieldsArray;1;"";*)
$fieldsArray{1}:=Field:C253(1;2)
CREATE INDEX:C966(Table:C252(1)->;$fieldsArray;1;"";*)
```

すでにインデックスが設定されている場合はスキップします。

* `$dry_run`を`False`に設定した場合，実際にインデックスが作成されます。

対象ストラクチャがv18以降の場合はこちらのオプションを使用してください。
