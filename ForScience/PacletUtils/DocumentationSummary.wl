Begin["`Private`"]


DocumentationSummary[sym_]:=StringRiffle[
  StringReplace[
    c:("\\["~~WordCharacter..~~"]"):>ToExpression["\""<>c<>"\""]
  ]@
   First@FrontEndExecute@FrontEnd`ExportPacket[BoxData@#,"PlainText"]&/@
    ForScience`PacletUtils`Private`UsageBoxes[sym],
  " "
]


End[]