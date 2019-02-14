(* ::Package:: *)

BuildTimeEvaluate;
BuildTimeEvaluator;


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
