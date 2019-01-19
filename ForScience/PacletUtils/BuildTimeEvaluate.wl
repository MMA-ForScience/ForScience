(* ::Package:: *)

Usage[BuildTimeEvaluate]="BuildTimeEvaluate[id,expr] assigns ```expr``` to [*BuildTimeEvaluate[id]*] and returns ```expr```.
BuildTimeEvaluate[id] will be replaced by the expression assigned to ```id```.";
Usage[BuildTimeEvaluator]="BuildTimeEvaluator is a file processor that replaces any [*BuildTimeEvaluate*] expressions by the appropriate expressions.";


Begin["`Private`"]


BuildTimeResult[_]:=Missing["NotAvailable"]


Attributes[BuildTimeEvaluate]={HoldAll};


SyntaxInformation[BuildTimeEvaluate]={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};


Options[BuildTimeEvaluate]={"CacheResults"->True,"CacheID"->0};


BuildTimeEvaluate[id_String,expr_,OptionsPattern[]]:=
  BuildTimeResult[id]=
    If[$BuildActive&&OptionValue["CacheResults"],
      Module[
        {
          cacheDir=FileNameJoin@{$BuildCacheDirectory,"BuildTimeExpressions"},
          file,
          ev,
          cacheData
        },
        file=FileNameJoin@{cacheDir,id<>ToString@OptionValue["CacheID"]<>".mx"};
        If[FileExistsQ@file,
          Import@file,
          ev=expr;
          If[!FileExistsQ@cacheDir,
            CreateDirectory[cacheDir]
          ];
          Export[file,ev];
          ev
        ]
      ],
      expr
    ]


BuildTimeEvaluate[id_String,OptionsPattern[]]:=
  BuildTimeResult[id]


BuildTimeEvaluator[exprs_,OptionsPattern[]]:=
  With[
    {bte=Symbol["BuildTimeEvaluate"]},
    exprs/.bte[id_String,_:PatternSequence[],OptionsPattern[]]:>
      With[
        {
          res=BuildTimeResult[id]
        },
        res/;True
      ]
  ]
  

End[]


BuildAction[


DocumentationHeader[BuildTimeEvaluate]=FSHeader["0.84.0","0.85.1"];


Details[BuildTimeEvaluate]={
  "[*BuildTimeEvaluate[id,expr]*] assigns the result of evaluating ```expr``` to ```id```.",
  "[*BuildTimeEvaluate[id,expr]*] evaluates to ```expr```.",
  "[*BuildTimeEvaluate[id]*] evaluates to the expression assigned to ```id``` by previous [*BuildTimeEvaluate*] calls.",
  "[*BuildTimeEvaluate[id]*] can be used to insert the result of a computation into held expressions.",
  "If no expression has been assigned to ```id```, [*BuildTimeEvaluate[id]*] evaluates to [*Missing*][\"NotAvailable\"].",
  "Expressions wrapped in [*BuildTimeEvaluate*] can be pre-evaluated during paclet build by [*BuildTimeEvaluator*].",
  "[*BuildTimeEvaluate*] is typically wrapped around expensive code where only the result is important.",
  "[*BuildTimeEvaluate*] accepts the following options:",
  TableForm@{
    {"\"CacheResults\"",True,"Whether to cache the result of evaluating ```expr```"},
    {"\"CacheID\"",0,"An identifier to use for cache lookups"}
  },
  "Changing the value of \"CacheID\"  can force ```expr``` to be reevaluated (assuming that value has not been used before).",
  "[*BuildTimeEvaluate*] uses the cache directory specified by [*$BuildCacheDirectory*] to cache the results of the expressions to be evaluated.",
  "[*BuildTimeEvaluate*] only uses the cache during paclet build, i.e. when [*$BuildActive*] is [*True*]."
};


SeeAlso[BuildTimeEvaluate]=Hold[BuildTimeEvaluator,BuildPaclet,BuildAction,$BuildCacheDirectory];


DocumentationHeader[BuildTimeEvaluator]=FSHeader["0.84.0","0.85.1"];


Details[BuildTimeEvaluator]={
  "[*BuildTimeEvaluator*] is a file processor for [*ProcessFile*] and [*BuildPaclet*].",
  "[*BuildTimeEvaluator*] replaces any expressions of the form [*BuildTimeEvaluate[id]*] and [*BuildTimeEvaluate[id,expr]*] by the expression assigned to ```id```.",
  "[*BuildTimeEvaluate[id,expr]*] can be used to assign the result of evaluating ```expr``` to ```id```.",
  "[*BuildTimeEvaluator*] is typically used as file post-processor for [*BuildPaclet*] to pre-execute expensive setup code."
};


SeeAlso[BuildTimeEvaluator]=Hold[BuildTimeEvaluate,BuildPaclet,ProcessFile,$BuildCacheDirectory];


]
