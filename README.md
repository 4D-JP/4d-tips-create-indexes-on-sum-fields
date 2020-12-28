# 4d-tips-create-indexes-on-sum-fields.md
すべてのSumフィールドにインデックスを設定する例題

数値フィールドにインデックスが設定されていないストラクチャ

<img width="320" alt="structure" src="https://user-images.githubusercontent.com/10509075/103191665-234a1600-4919-11eb-8dce-849a3b8447d0.png">

メソッドを実行するとコード内で`Sum`の対象となっているフィールドにインデックスが設定されます。

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

インデックスを追加したフィールドの情報はログファイルに出力されます。

```4d
[
	{
		"table": 2,
		"field": 3
	},
	{
		"table": 2,
		"field": 4
	}
]
```

すでにインデックスが設定されている場合はスキップします。
