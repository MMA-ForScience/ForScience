(* ::Package:: *)

DelayedExport::usage=FormatUsage@"DelayedExport[file,expr] creates a preview of what expr would look like if exported to the specified file. Exporting is actually done only once the button is pressed. Note: PDF importing has a bug that ignores clipping regions. If the preview has some overflowing lines, check the actual PDF. Note 2: Some formats can not be reimported. In those cases, the preview will be the original expression. Set '''PerformanceGoal''' to '''\"Speed\"''' to always show original expression.";


Begin["`Private`"]


DelayedExport[file_,expr_,OptionsPattern[]]:=DynamicModule[
 {curExpr=expr},
 Column@{
   Row@
   {
    Button[
     StringForm["Save to ``",file],
     Export[file,expr]
    ],
    Button[
     "Refresh",
     curExpr=expr
    ]
   },
   Dynamic[
     If[OptionValue[PerformanceGoal]=="Quality"&&
      MemberQ[$ImportFormats,ToUpperCase@FileExtension@file],
       Check[
         Quiet@Column@{"Preview:",ImportString[ExportString[curExpr,#],#]&@FileExtension@file},
         #
       ],
       #
     ]&@Unevaluated@Column@{"Expression to export:",curExpr},
     TrackedSymbols:>{curExpr}
   ]
 }
]
SyntaxInformation[DelayedExport]={"ArgumentsPattern"->{_,_,OptionsPattern[]}};
Attributes[DelayedExport]={HoldRest};
Options[DelayedExport]={PerformanceGoal->"Quality"};


End[]
