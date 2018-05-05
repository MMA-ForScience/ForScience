(* ::Package:: *)

(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
ParseFormatting;


Begin["`Private`ParseFormatting`"]


ti;
mr;
go;
gc;
co;
cc;
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
ParseToken[str_,i_][co]:=TagBox[ParseToToken[str,i,False][cc],"[**]"]
ParseToken[str_,i_][t_]:=t
Attributes[ParseToken]={HoldRest};


ParseFormatting::badFormat="End reached while trying to parse formatting of \"``\".";
ParseFormatting[str_]:=Module[
  {i=1,pStr},
  pStr=StringReplace[
    {"```"->" ``` ",
    "'''"->" ´´´ ",
    "{*"->" ```´ ",
    "*}"->" ```´` ",
    "[*"->" `´``` ",
    "*]"->" ´``` ",
    ", "->" ```´´ ",
    " "->" ```` ",
    "_"->" _ ",
    "\""->"`´`´"
    }
  ]@str;
  pStr=First@MathLink`CallFrontEnd[
    FrontEnd`UndocumentedTestFEParserPacket[pStr,True]
  ];
  pStr=pStr/.s_String:>StringReplace[s,"`´`´"->"\""];
  If[MatchQ[pStr,BoxData[_String]],Return@First@pStr];
  pStr=Append[EndOfLine]@Replace[
    Flatten@First@Replace[pStr,RowBox@x_:>x,\[Infinity]],
    {
      "```"->ti,
      "´´´"->mr,
      "```´"->go,
      "```´`"->gc,
      "`´```"->co,
      "´```"->cc,
      "````"->" ",
      "_"->sb
    },
    1
  ];
  Catch[
    FixedPoint[
      Replace[#,{pre___,s:Longest@Repeated[_String,{2,\[Infinity]}],post___}:>
       {pre,StringReplace["```´´"->", "]@StringJoin@s,post},1]&,
      ParseToToken[pStr, i][EndOfLine]//.
       {pre___,a_,sb,b_,post___}:>{pre,SubscriptBox[a,b],post}
    ]/."```´´"->",",
    EndOfFile,
    (Message[ParseFormatting::badFormat,str];str)&
  ]
]
SyntaxInformation[ParseFormatting]={"ArgumentsPattern"->{_}};


End[]
