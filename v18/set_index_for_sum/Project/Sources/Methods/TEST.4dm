//%attributes = {}
$log_path:=Temporary folder:C486+Replace string:C233(Timestamp:C1445;":";"-";*)+Folder separator:K24:12
CREATE FOLDER:C475($log_path;*)

$enum_sum:=1  //command number for Sum
$enum_field:=253  //command number for Field

ARRAY TEXT:C222($methods;0)
METHOD GET PATHS:C1163(Path all objects:K72:16;$methods)

$token:="([[:letter:][_]][[:letter:][:number:][. _]]+(?<![. ]))"
$id:=":C("+String:C10($enum_sum)+")"
$argument:="\\s*\\(([^)]+)\\)"
$motif:="("+$token+$id+$argument+")"
$isField:="\\[[^]]+:(\\d+)\\].+:(\\d+)"
$id:=":C("+String:C10($enum_field)+")"
$arguments:="\\s*\\((\\d+);(\\d+)"
$isFieldPointer:="("+$token+$id+$arguments+")"

$fields:=New object:C1471  //hash table of tableId_fieldId
$errors:=New collection:C1472

For ($m;1;Size of array:C274($methods))
	$method:=$methods{$m}
	If (Current method path:C1201#$method)
		METHOD GET CODE:C1190($method;$code;Code with tokens:K72:18)
		$lines:=Split string:C1554($code;"\r";sk trim spaces:K86:2)
		$lines.shift()
		For each ($line;$lines)
			Case of 
				: (Match regex:C1019("\\s*";$line))
				: (Match regex:C1019("^//.*";$line))
				Else 
					$i:=1
					ARRAY LONGINT:C221($pos;0)
					ARRAY LONGINT:C221($len;0)
					While (Match regex:C1019($motif;$line;$i;$pos;$len))
						$command_id:=Num:C11(Substring:C12($line;$pos{3};$len{3}))
						$command_name:=Substring:C12($line;$pos{2};$len{2})
						ASSERT:C1129($command_name=Command name:C538($command_id))
						$series:=Substring:C12($line;$pos{4};$len{4})
						$i:=$pos{1}+$len{1}
						Case of 
							: (Match regex:C1019($isField;$series;1;$pos;$len))
								$tableId:=Num:C11(Substring:C12($series;$pos{1};$len{1}))
								$fieldId:=Num:C11(Substring:C12($series;$pos{2};$len{2}))
								$key:=New collection:C1472($tableId;$fieldId).join("_")
								If ($fields[$key]=Null:C1517)
									$fields[$key]:=New object:C1471("table";Table:C252($tableId);"field";Field:C253($tableId;$fieldId);"tableId";$tableId;"fieldId";$fieldId)
								End if 
							: (Match regex:C1019($isFieldPointer;$series;1;$pos;$len))
								$tableId:=Num:C11(Substring:C12($series;$pos{4};$len{4}))
								$fieldId:=Num:C11(Substring:C12($series;$pos{5};$len{5}))
								$key:=New collection:C1472($tableId;$fieldId).join("_")
								If ($fields[$key]=Null:C1517)
									$fields[$key]:=New object:C1471("table";Table:C252($tableId);"field";Field:C253($tableId;$fieldId);"tableId";$tableId;"fieldId";$fieldId)
								End if 
							Else 
								$error:=New object:C1471
								$error.method:=$method
								$error.line:=$line
								$error.value:=$series
								$errors.push($error)
						End case 
					End while 
			End case 
		End for each 
	End if 
End for 

If ($errors.length#0)
	TEXT TO DOCUMENT:C1237($log_path+"error.txt";JSON Stringify:C1217($errors;*))
End if 

C_TEXT:C284($key;$name)
C_BOOLEAN:C305($indexed)
C_LONGINT:C283($number;$type;$length)

$indexes:=New collection:C1472

For each ($key;$fields)
	
	$field:=$fields[$key].field
	
	GET FIELD PROPERTIES:C258($field;$type;$length;$indexed)
	
	If (Not:C34($indexed))
		$table:=$fields[$key].table
		ARRAY POINTER:C280($fieldsArray;1)
		$fieldsArray{1}:=$field
		CREATE INDEX:C966($table->;$fieldsArray;Standard BTree index:K58:3;$name;*)
		$indexes.push(New object:C1471("table";$fields[$key].tableId;"field";$fields[$key].fieldId))
	End if 
	
End for each 

If ($indexes.length#0)
	TEXT TO DOCUMENT:C1237($log_path+"info.txt";JSON Stringify:C1217($indexes;*))
End if 

SHOW ON DISK:C922($log_path;*)