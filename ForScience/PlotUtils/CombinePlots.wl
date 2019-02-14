(* ::Package:: *)

CombinePlots;


Begin["`Private`"]


SeparateAnnotations[(wrap:Legended|Graphics)[first_,rest___],o:OptionsPattern[]]:=
 wrap[SeparateAnnotations[first,o],rest]
SeparateAnnotations[annot_,OptionsPattern[CombinePlots]]:=
 (Sow[annot];{})/;
  MatchQ[annot,OptionValue["AnnotationPattern"]]
SeparateAnnotations[expr_,OptionsPattern[]]:=
 expr
SeparateAnnotations[expr_List,o:OptionsPattern[]]:=
 SeparateAnnotations[#,o]&/@expr


GraphicsOptions[Legended[expr_,_]]:=
 GraphicsOptions[expr]
GraphicsOptions[gr_Graphics]:=
 Options@gr


Options[CombinePlots]={"CombineProlog"->True,"CombineEpilog"->True,"AnnotationPattern"->(GraphicsGroup|Text)[___]};


CombinePlots[plots__,Longest[opts:OptionsPattern[]]]:=With[
  {
    cpOpts=FilterRules[{opts},Options@CombinePlots]
  },
  Show[
    Flatten@MapAt[Graphics,-1]@Reap@SeparateAnnotations[{plots},cpOpts],
    Complement[{opts},cpOpts],
    If[OptionValue[CombinePlots,cpOpts,"CombineProlog"],
      Prolog->(
        OptionValue[Graphics,GraphicsOptions@#,Prolog]&
      )/@Flatten@{plots},
      Unevaluated@Sequence[]
    ],
    If[OptionValue[CombinePlots,cpOpts,"CombineEpilog"],
      Epilog->(
        OptionValue[Graphics,GraphicsOptions@#,Epilog]&
      )/@Flatten@{plots},
      Unevaluated@Sequence[]
    ]
  ]
]


End[]
