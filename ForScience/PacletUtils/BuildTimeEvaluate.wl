(* ::Package:: *)

Usage[BuildTimeEvaluate]="BuildTimeEvaluate[expr] will be replaced with the evaluated form of ```expr``` by [*BuildTimeEvaluator*].";
Usage[BuildTimeEvaluator]="BuildTimeEvaluator is a file processor that replaces any [*BuildTimeEvaluate*] expressions by their result.";


Begin["`Private`"]


Attributes[BuildTimeEvaluate]={HoldAll};


SyntaxInformation[BuildTimeEvaluate]={"ArgumentsPattern"->{_,OptionsPattern[]}};


Options[BuildTimeEvaluate]={"CacheResults"->True,"CacheID"->0};


BuildTimeEvaluate[expr_,OptionsPattern[]]:=expr


BuildTimeEvaluator[exprs_,OptionsPattern[]]:=
  With[
    {bte=Symbol["BuildTimeEvaluate"]},
    exprs/.bte[expr_,o:OptionsPattern[]]:>
      With[
        {
          res=If[OptionValue[BuildTimeEvaluate,{o},"CacheResults"]&&$BuildActive,
            Module[
              {
                cacheDir=FileNameJoin@{$BuildCacheDirectory,"BuildTimeExpressions"},
                file,
                ev,
                cacheKey={Hold[expr],OptionValue[BuildTimeEvaluate,{o},"CacheID"]},
                cacheData
              },
              file=FileNameJoin@{cacheDir,Hash[cacheKey,"Expression","HexString"]<>".mx"};
              If[!FileExistsQ@file,
                ev=expr;
                If[!FileExistsQ@cacheDir,
                  CreateDirectory[cacheDir]
                ];
                Export[file,<|cacheKey->ev|>];
                ev,
                cacheData=Import@file;
                If[KeyExistsQ[cacheData,cacheKey],
                  cacheData[cacheKey],
                  ev=expr;
                  Export[file,Append[cacheData,cacheKey->ev]];
                  ev
                ]
              ]
            ],
            expr
          ]
        },
        res/;True
      ]
  ]
  

End[]


BuildAction[


DocumentationHeader[BuildTimeEvaluate]=FSHeader["0.84.0"];


Details[BuildTimeEvaluate]={
  "[*BuildTimeEvaluate[expr]*] evaluates to ```expr```.",
  "Expressions wrapped in [*BuildTimeEvaluate*] can be pre-evaluated during paclet build by [*BuildTimeEvaluator*].",
  "[*BuildTimeEvaluate*] is typically wrapped around expensive code where only the result is important.",
  "[*BuildTimeEvaluate*] accepts the following options:",
  TableForm@{
    {"\"CacheResults\"",True,"Whether to cache the result of evaluating ```expr```"},
    {"\"CacheID\"",0,"An identifier to use for cache lookups"}
  },
  "Changing the value of \"CacheID\"  can force ```expr``` to be reevaluated (assuming that value has not been used before)."
};


SeeAlso[BuildTimeEvaluate]=Hold[BuildTimeEvaluator,BuildPaclet,BuildAction,$BuildCacheDirectory];


DocumentationHeader[BuildTimeEvaluator]=FSHeader["0.84.0"];


Details[BuildTimeEvaluator]={
  "[*BuildTimeEvaluator*] is a file processor for [*ProcessFile*] and [*BuildPaclet*].",
  "[*BuildTimeEvaluator*] replaces any expressions of the form [*BuildTimeEvaluate[expr]*] by the result of evaluating ```expr```.",
  "[*BuildTimeEvaluator*] uses the cache directory specified by [*$BuildCacheDirectory*] to cache the results of the [*BuildTimeEvaluate*] expressions.",
  "[*BuildTimeEvaluator*] is typically used as file pre-processor for [*BuildPaclet*] to pre-execute expensive setup code."
};


SeeAlso[BuildTimeEvaluator]=Hold[BuildTimeEvaluate,BuildPaclet,ProcessFile,$BuildCacheDirectory];


]
