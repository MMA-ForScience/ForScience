(* ::Package:: *)

ApplyToWrapped::usage=FormatUsage@"ApplyToWrapped[func,expr,target] applies ```func``` to the first level in ```expr``` matching ```target```. Any wrappers of ```expr``` are also wrapped around the result.
ApplyToWrapped[func,expr,target,extract] removes any wrappers matching ```extract```, and passes them to ```func``` in the second argument instead.";


Begin["`Private`"]


Options[ApplyToWrapped]={Method->Blank};


SyntaxInformation[ApplyToWrapped]={"ArgumentsPattern"->{_,_,_,_.,OptionsPattern[]}};


ApplyToWrapped::noMatch="Expression `` is not a wrapped expression matching ``.";


ApplyToWrapped[func_,expr_,target_,extract_:None,Longest[OptionsPattern[]]]:=ReleaseHold[
  Hold@IApplyToWrapped[expr,target,extract,{}]//.
    DownValues@IApplyToWrapped/.
      {
        IApplyToWrapped[e_,c_]:>With[
          {
            r=Which[
              extract===None,
              func@e,
              OptionValue@Method===Blank,
              func[e,c],
              True,
              With[
                {
                  cf=Unevaluated@c/.w_[Verbatim@_,rest___]:>(w[#,rest]&)
                },
                func[e,cf] 
              ]
            ]
          },
          r/;True
        ],
        _Hold?(MemberQ[#,HoldPattern@IApplyToWrapped[_,_,_,_],{0,\[Infinity]}]&):>Hold[Message[ApplyToWrapped::noMatch,HoldForm@expr,target];expr]
      }
]


Attributes[IApplyToWrapped]={HoldFirst};


IApplyToWrapped[expr_,target_,extract_,coll_]/;MatchQ[Unevaluated@expr,target]:=IApplyToWrapped[expr,coll]
IApplyToWrapped[expr:w_[wrapped_,args___],target_,extract:Except[None],{coll___}]/;MatchQ[Unevaluated@expr,extract]:=IApplyToWrapped[
  wrapped,
  target,
  extract,
  {coll,w[_,args]}
]
IApplyToWrapped[w_[wrapped_,args___],target_,extract_,coll_]:=w[
  IApplyToWrapped[
    wrapped,
    target,
    extract,
    coll
  ],
  args
]


End[]
