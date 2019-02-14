(* ::Package:: *)

BuildAction;
CleanBuildActions;
$EnableBuildActions;


Begin["`Private`"]


$EnableBuildActions=False;


$BuildActionContext="ForScience`BuildAction`";


Attributes[BuildAction]={HoldAll};


SyntaxInformation[BuildAction]={"ArgumentsPattern"->{__}};


BuildAction[acts__]/;$BuildActive||$EnableBuildActions:=CompoundExpression[acts]
BuildAction[acts__]:=Null
Begin[BuildAction]^:=Begin[$BuildActionContext]


CleanBuildActions[expr_]:=With[
  {ba=Symbol["BuildAction"]},
  Module[
    {BALvl=-1,lvl=0},
    Switch[#,
      HoldComplete@_ba,
        Nothing,
      HoldComplete@Begin[_],
        ++lvl;
        If[MatchQ[#,HoldComplete@Begin[ba]],
          BALvl=Max[lvl,BALvl]
        ];
        If[BALvl>0,Nothing,#],
      HoldComplete@End[],
        --lvl;
        If[BALvl==lvl+1,
          BALvl=-1;
          Nothing,
          If[BALvl>0,Nothing,#]
        ],
      _,
        If[BALvl>0,Nothing,#]
    ]&/@expr
  ]
]

End[]
