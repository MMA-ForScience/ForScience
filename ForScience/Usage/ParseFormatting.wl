(* ::Package:: *)

(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
ParseFormatting;


Begin["`Private`ParseFormatting`"]


ti;
mr;
go;
gc;
tb;


ToRowBox[{el_}]:=el
ToRowBox[l_]:=RowBox@l
ParseToToken[str_,i_,simplify_:True][t_]:=(
  If[simplify,ToRowBox,RowBox]@Flatten@Reap[
    Module[{curToken},
      While[True,
        If[i>Length@str,Throw[t,EndOfFile]];
        curToken=str[[i]];
        ++i;
        If[curToken===t,Break[]];
        Sow@ParseToken[str,i][curToken]
      ];
    ]
  ][[2]]
)
Attributes[ParseToToken]={HoldRest};

ParseToken[str_,i_][ti]:=StyleBox[ParseToToken[str,i][ti],"TI"]
ParseToken[str_,i_][mr]:=StyleBox[ParseToToken[str,i][mr],"MR"]
ParseToken[str_,i_][go]:=ParseToToken[str,i,False][gc]
ParseToken[str_,i_][t_]:=t
Attributes[ParseToken]={HoldRest};


ParseFormatting::badFormat="End reached while trying to parse formatting of \"``\".";
ParseFormatting[str_]:=Module[
  {i=1,pStr},
  pStr=Append[EndOfLine]@Replace[
    Flatten@First@Replace[First@#,RowBox@x_:>x,\[Infinity]],
    {
      "```"->ti,
      "'''"->mr,
      "`````"->go,
      "``````"->gc,
      "````"->" ",
      "_"->sb
    }
    ,1
  ]&@MathLink`CallFrontEnd[
    FrontEnd`UndocumentedTestFEParserPacket[#,True]
  ]&@
   StringReplace[
     {"```"->" ``` ",
     "'''"->" ''' ",
     "{{"->" ````` ",
     "}}"->" `````` ",
     " "->" ```` ",
     "_"->" _ "
     }
   ]@str;
  Catch[
    ParseToToken[pStr, i][EndOfLine]//.
     l_List?(MemberQ[sb]):>SequenceReplace[l,{a_,sb,b_}:>SubscriptBox[a,b]]/.
       RowBox[l_List]:>RowBox@SequenceReplace[l,{s__String}:>StringJoin@s],
    EndOfFile,
    (Message[ParseFormatting::badFormat,str];str)&
  ]
]
SyntaxInformation[ParseFormatting]={"ArgumentsPattern"->{_}};


End[]
