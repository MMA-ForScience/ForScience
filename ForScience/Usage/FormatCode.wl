(* ::Package:: *)

(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
FormatCode;


Begin["`Private`FormatCode`"]


ti;
mr;
go;
gc;
tb;


ToRowBox[{el_}]:=el
ToRowBox[l_]:=RowBox@l
ParseToToken[str_,i_][t_]:=(
  ToRowBox@Flatten@Reap[
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
ParseToken[str_,i_][go]:=ToRowBox@Flatten@{ParseToToken[str,i][gc]}
ParseToken[str_,i_][t_]:=t
Attributes[ParseToken]={HoldRest};


FormatCode::badFormat="End reached while trying to parse formatting of \"``\".";
FormatCode[str_]:=Module[
  {i,pStr},
  pStr={##,EndOfLine}&@@Replace[
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
  ]&/@StringSplit[
    StringReplace[
      {"```"->" ``` ",
      "'''"->" ''' ",
      "{{"->" ````` ",
      "}}"->" `````` ",
      ", "->",",
      " "->" ```` ",
      "_"->" _ "
      }
    ]@str,
    "\n"
  ];
  StringRiffle[
    If[StringStartsQ[#,"\!"],#,"\!\(\)"<>#]&@(
      i=1;
      Catch[
        ParseToToken[#, i][EndOfLine]//.
         l_List?(MemberQ[sb]):>SequenceReplace[l,{a_,sb,b_}:>SubscriptBox[a,b]]/.
          (b:StyleBox|SubscriptBox)[s_String,arg2_]:>
           StringReplace[
             s,
             StartOfString~~q1:"\""~~qs___~~q2:"\""~~EndOfString:>b[q1<>"\\\""<>qs<>"\\\""<>q2,arg2]
           ]/.
           RowBox[{el_}]:>el/.
            RowBox[l_]:>StringJoin@Replace[l,{b:Except[_String]:>"\!\(\*"<>ToString[b,InputForm]<>"\)",","->", "},{1}],
        EndOfFile,
        (Message[FormatCode::badFormat,str];str)&
      ]
    )&/@pStr,
    "\n"
  ]
]
SyntaxInformation[FormatCode]={"ArgumentsPattern"->{_}};


End[]
