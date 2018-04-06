(* ::Package:: *)

`Private`ProcessingAutoSlot=True;(*disable AutoSlot related parsing while setting usage messages. Needed when loading this multiple times*)
\[Bullet]::usage=FormatUsage@"\[Bullet] works analogously to '''#''', but doesn't require an eclosing '''&'''. Slots are only filled on the topmost level. E.g. '''f[\[Bullet], g[\[Bullet]]][3]'''\[RightArrow]'''f[3,g[\[Bullet]]]'''. Can also use '''\[Bullet]'''```n``` and '''\[Bullet]'''```name```, analogous to '''#'''. See also '''\[Bullet]\[Bullet]''' Enter \[Bullet] s '''\\[Bullet]''' or '''ALT+7'''.";
\[Bullet]\[Bullet]::usage=FormatUsage@"\[Bullet]\[Bullet] works the same as \[Bullet], but is analogue to ##. Can also use '''\[Bullet]'''```n```, analogous to ```##```. Enter \[Bullet] as '''\\[Bullet]''' or '''ALT+7'''.";
AutoSlot::usage=\[Bullet]::usage;
AutoSlotSequence::usage=\[Bullet]\[Bullet]::usage;
`Private`ProcessingAutoSlot=False;


Begin["`Private`"]


ProcessingAutoSlot=True;
slotMatcher=StringMatchQ["\[Bullet]"~~___];
(
  #/:expr:_[___,#[___],___]/;!ProcessingAutoSlot:=Block[
    {ProcessingAutoSlot=True},
    Replace[AutoFunction[expr],{AutoSlot[i___]:>IAutoSlot[i],AutoSlotSequence[i___]:>IAutoSlotSequence[i]},{2}]
  ];
)&/@{AutoSlot,AutoSlotSequence};
MakeBoxes[(IAutoSlot|AutoSlot)[i_String|i:_Integer?NonNegative:1],fmt_]/;!ProcessingAutoSlot:=With[{sym=Symbol["\[Bullet]"<>ToString@i]},MakeBoxes[sym,fmt]]
MakeBoxes[(IAutoSlotSequence|AutoSlotSequence)[i:_Integer?Positive:1],fmt_]/;!ProcessingAutoSlot:=With[{sym=Symbol["\[Bullet]\[Bullet]"<>ToString@i]},MakeBoxes[sym,fmt]]
MakeBoxes[IAutoSlot[i___],fmt_]/;!ProcessingAutoSlot:=MakeBoxes[AutoSlot[i],fmt]
MakeBoxes[IAutoSlotSequence[i___],fmt_]/;!ProcessingAutoSlot:=MakeBoxes[AutoSlotSequence[i],fmt]
MakeBoxes[AutoFunction[func_],fmt_]:=MakeBoxes[func,fmt]
MakeExpression[RowBox[{"?", t_String?slotMatcher}], fmt_?(!ProcessingAutoSlot&)(*make check here instead of ordinary condition as that one causes an error*)]:= 
  MakeExpression[RowBox[{"?", If[StringMatchQ[t,"\[Bullet]\[Bullet]"~~___],"AutoSlotSequence","AutoSlot"]}], fmt]
MakeExpression[arg_RowBox?(MemberQ[#,_String?slotMatcher,Infinity]&),fmt_?(!ProcessingAutoSlot&)(*make check here instead of ordinary condition as that one causes an error*)]:=Block[
  {ProcessingAutoSlot=True},
  MakeExpression[
    arg/.a_String:>First[
      StringCases[a,t:("\[Bullet]\[Bullet]"|"\[Bullet]")~~i___:>ToBoxes@If[t=="\[Bullet]",AutoSlot,AutoSlotSequence]@If[StringMatchQ[i,__?DigitQ],ToExpression@i,i/.""->1]],
      a
    ],
    fmt
  ]
]
ProcessingAutoSlot=False;
Attributes[AutoFunction]={HoldFirst};
funcData[AutoFunction]={{IAutoSlot[i__:1]:>i,IAutoSlotSequence[i__:1]:>i},{2},{AutoSlot,AutoSlotSequence}};
func:AutoFunction[_][___]:=ProcFunction[func]
SyntaxInformation[AutoSlot]={"ArgumentsPattern"->{_.}};
SyntaxInformation[AutoSlotSequence]={"ArgumentsPattern"->{_.}};


End[]
