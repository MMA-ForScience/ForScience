(* ::Package:: *)

Begin["`Private`"]


ExtractGraphics[gr_Graphics]:=gr
ExtractGraphics[Legended[expr_,__]]:=expr


ValidGraphicsQ[Legended[expr_,__]]:=ValidGraphicsQ[expr]
ValidGraphicsQ[_Graphics]:=True
ValidGraphicsQ[_]:=False


GraphicsOpt[g_Graphics,opt_]:=GraphicsOpt[Options@g,opt]
GraphicsOpt[l_Legended,opt_]:=GraphicsOpt[ExtractGraphics@l,opt]
GraphicsOpt[opts_,opt_]:=OptionValue[Graphics,opts,opt]


NormalizeFrameSetting[val_]:=Replace[
  Replace[
    val,
    {
      None->False,
      Automatic->True
    },
    {2}
  ],
  Except@Table[True|False,2,2]->Table[False,2,2]
]


NormalizeGraphicsOpt[FrameLabel][b_]:={{None,None},{b,None}}
NormalizeGraphicsOpt[FrameLabel][{b_,l_:None,t_:None,r_:None,___}]:={{l,r},{b,t}}
NormalizeGraphicsOpt[FrameLabel][s:{{_,_},{_,_}}]:=s
NormalizeGraphicsOpt[FrameTicks][a_]:={{a,a},{a,a}}
NormalizeGraphicsOpt[FrameTicks][{h_,v_}]:={{v,v},{h,h}}
NormalizeGraphicsOpt[FrameTicks][s:{{_,_},{_,_}}]:=s
NormalizeGraphicsOpt[FrameStyle][a:Except[_List]]:={{a,a},{a,a}}
NormalizeGraphicsOpt[FrameStyle][{v_,h_}]:={{v,v},{h,h}}
NormalizeGraphicsOpt[FrameStyle][{b_,l_,t_,r_}]:={{l,r},{b,t}}
NormalizeGraphicsOpt[FrameStyle][s:{{_,_},{_,_}}]:=s
NormalizeGraphicsOpt[FrameStyle][_]:=NormalizeGraphicsOpt[FrameStyle][None]
NormalizeGraphicsOpt[FrameTicksStyle]:=NormalizeGraphicsOpt[FrameStyle]
NormalizeGraphicsOpt[Frame][a_]:=NormalizeFrameSetting@{{a,a},{a,a}}
NormalizeGraphicsOpt[Frame][{a_}]:=NormalizeFrameSetting@NormalizeGraphicsOpt[FrameStyle][True]
NormalizeGraphicsOpt[Frame][{h_,v_}]:=NormalizeFrameSetting@{{v,v},{h,h}}
NormalizeGraphicsOpt[Frame][{b_,l_,t_,r_:True}]:=NormalizeFrameSetting@{{l,r},{b,t}}


NormalizedOptionValue[g_,opt_List]:=NormalizedOptionValue[g,#]&/@opt
NormalizedOptionValue[g_,opt_]:=NormalizeGraphicsOpt[opt][GraphicsOpt[g,opt]]


Options[ResolveCoordinatesTool]={"CopiedValueFunction"->Identity,"DisplayFunction"->Automatic};


ResolveCoordinatesTool[Automatic][_]:=Identity
ResolveCoordinatesTool[OptionsPattern[]][cvf:"CopiedValueFunction"]:=Replace[OptionValue@cvf,Automatic->Identity]
ResolveCoordinatesTool[OptionsPattern[]][df:"DisplayFunction"]:=Replace[OptionValue@df,Automatic->OptionValue@"CopiedValueFunction"]


(* get CoordinateToolOptions from a Graphics object. Since the setting can be directly inside
   the Graphics or inside Method, we need to combine both (and handle Automatic settings for both
   Method, CoordinateToolOptions and DisplayFunction along the way *)
GetCoordinatesToolOptions[gr_]:=
  ResolveCoordinatesTool@
    GraphicsOpt[
      {
        FilterRules[
          Replace[
            GraphicsOpt[gr,Method],
            Automatic->{}
          ],
          CoordinatesToolOptions
        ],
        Options@gr
      },
      CoordinatesToolOptions
    ]


$SidePositions=<|Left->{1,1},Right->{1,2},Bottom->{2,1},Top->{2,2}|>;


ExpandSeqSpec[{start___,cycle:{__},end___},n_]:=
  With[
    {rem=Max[n-Length@{start},0]},
    Join[
      Take[{start},UpTo@n],
      PadRight[{},Max[rem-Length@{end},0],cycle],
      Take[{end},-Min[Length@{end},rem]]
    ]
  ]
ExpandSeqSpec[{start___,{},end___},n_]:=
  ExpandSeqSpec[{start,{Automatic},end},n]
ExpandSeqSpec[{start___},n_]:=
  ExpandSeqSpec[{start,{}},n]
ExpandSeqSpec[spec_,n_]:=
  ExpandSeqSpec[{{spec}},n]
ExpandSeqSpec[{spec_,rules:{__Rule}},n_]:=
  ReplacePart[ExpandSeqSpec[spec,n],rules]
ExpandSeqSpec[rules:{__Rule},n_]:=
  ExpandSeqSpec[{{},rules},n]


Expand2DSpec[{wspec_:{},hspec_:{},___},{m_,n_}]:=
  {ExpandSeqSpec[wspec,m],ExpandSeqSpec[hspec,n]}
Expand2DSpec[spec_,{m_,n_}]:=
  Expand2DSpec[{spec,spec},{m,n}]


Expand2DSpecToGrid[spec_,{m_,n_}]:=
  Module[
    {wspec,hspec},
    {wspec,hspec}=Expand2DSpec[spec/.Automatic->iAutomatic,{m,n}];
    MapThread[
      First@*DeleteCases[iAutomatic],
      {
        Table[wspec,n],
        Transpose@Table[hspec,m],
        Table[Automatic,{m,n}]
      }
    ]
  ]


ExpandGridSpec[spec_,{m_,n_}]:=
  Module[
    {wspec,hspec},
    {wspec,hspec}=Expand2DSpec[spec/.Automatic->explicitAutomatic,{m,n}];
    MapThread[
      First@*DeleteCases[Automatic]@*List,
      {
        Table[wspec,n],
        Transpose@Table[hspec,m],
        Table[explicitAutomatic,n,m]
      },
      2
    ]/.
      explicitAutomatic->Automatic
  ]
ExpandGridSpec[{wspec_,hspec_,posRules:{__Rule}},{m_,n_}]:=
  Module[
    {grid=ExpandGridSpec[{wspec,hspec},{m,n}]},
    (grid[[Sequence@@Span@@@#]]=#2)&@@@posRules;
    grid
  ]


End[]
