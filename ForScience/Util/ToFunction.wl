(* ::Package:: *)

ToFunction::usage=FormatUsage@"ToFunction[expr] attempts to convert any function constructs inside '''expr''' to pure Functions. Can't convert functions containing SlotSequence. For functions using only indexed Slots, the returned pure function is fully equivalent. If named slots are used, the handling of missing keys/associations is altered.";


Begin["`Private`"]


ToFunction::slotSeq="Cannot convert function ``, as it contains a SlotSequence (``).";
ToFunction[expr_]:=
expr//.func:fType_[funcExpr_,fData___]:>
  Let[
    {
      hFunc=Hold@funcExpr,
      res=FirstCase[funcData[fType,fData],{{sltPat_:>sltIdx_,sltSeqPat_:>_},  levelspec_:\[Infinity],_}:>With[
        {
          newFunc=If[
            FreeQ[hFunc,sltSeqPat,levelspec],
            Let[
              {
                maxSlt=Max[Max@Cases[hFunc,sltPat:>If[IntegerQ@sltIdx,sltIdx,1],levelspec],0],
                vars=Table[Unique@"fArg",maxSlt],
                pFunc=hFunc/.sltPat:>With[{slot=If[IntegerQ@sltIdx,vars[[sltIdx]],vars[[1]][sltIdx]]},slot/;True]
              },
              Function@@Prepend[pFunc,vars]
            ],
            Message[Unevaluated@ToFunction::slotSeq,HoldForm@func,FirstCase[hFunc,sltSeqPat,"##",levelspec]];$Failed
          ]
        },
        newFunc/;True
      ],
      $Failed,
      {0}
    ]
  },
  res/;res=!=$Failed
]
Attributes[ToFunction]={HoldFirst};
Attributes[funcData]={HoldAll};
SyntaxInformation[ToFunction]={"ArgumentsPattern"->{_}};


End[]
