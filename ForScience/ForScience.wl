(* ::Package:: *)

BeginPackage["ForScience`"]


EndPackage[]


Block[{Notation`AutoLoadNotationPalette=False},
  BeginPackage["ForScience`Util`",{"Notation`"}]
]


cFunction::usage="f";
tee::usage="tee[expr] prints expr and returns in afterwards";


Begin["Private`"]


Notation[ParsedBoxWrapper[SubscriptBox[RowBox[{"expr_", "&"}], "id_"]] \[DoubleLongLeftRightArrow] ParsedBoxWrapper[RowBox[{"cFunction", "[", RowBox[{"expr_", ",", "id_"}], "]"}]]]
AddInputAlias["cf"->ParsedBoxWrapper[SubscriptBox["&", "\[Placeholder]"]]]
cFunction::missingArg="Cannot fill `` in ``\!\(\*SubscriptBox[\(&\), \(``\)]\) from (`2`\!\(\*SubscriptBox[\(&\), \(`3`\)]\))[`4`].";
cFunction::noAssoc="`` is expected to have an Association as the first argument.";
cFunction::missingKey="Named slot `` in ``\!\(\*SubscriptBox[\(&\), \(``\)]\) cannot be filled from (`2`\!\(\*SubscriptBox[\(&\), \(`3`\)]\))[`4`]";
cFunction[expr_,id_][args___]:=With[
  {argList={args},hExpr=Hold@expr},
  With[
    {
      firstAssoc=MemberQ[hExpr,Subscript[Slot[_String],id],Infinity],
      minArgs=Max[Cases[hExpr,Subscript[(Slot|SlotSequence)[n_],id]:>n,Infinity]/._String->1]
    },
    If[Length@{args}<minArgs,
      With[
        {errSlot=Last@First@MaximalBy[First]@Select[GreaterThan[Length@argList]@*First]@Cases[hExpr,s:Subscript[(Slot|SlotSequence)[n_],id]:>{n,s},Infinity]},
        Message[cFunction::missingArg,errSlot,HoldForm@expr,id,StringTake[ToString@args,{2,-2}]]
      ]
    ];
    If[firstAssoc&&!AssociationQ@First@argList,
      Message[cFunction::noAssoc,HoldForm@expr]
      ];
    ReleaseHold[
      hExpr
        /.Subscript[Slot[i_/;i<=Length@argList],id]:>With[{arg=argList[[i]]},arg/;True]
        /.Subscript[SlotSequence[i_/;i<=Length@argList],id]:>With[{arg=cfArgSeq@@argList[[i;;]]},arg/;True]
        //.h_[pre___,cfArgSeq[seq__],post___]:>h[pre,seq,post]
        /.s:Subscript[Slot[n_String],id]:>With[{arg=Lookup[First@argList,n,Message[cFunction::missingKey,s,HoldForm@expr,id,First@argList];s]},arg/;firstAssoc]
    ]
  ]
];
Attributes[cFunction]={HoldAll};


tee[expr_]:=(Print@expr;expr)
SyntaxInformation[tee]={"ArgumentsPattern"->{_}};


End[]


EndPackage[]


BeginPackage["ForScience`PlotUtils`"]


foo2::usage="a";


EndPackage[]
