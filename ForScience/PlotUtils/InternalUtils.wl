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


NormalizeGraphicsOpt[FrameLabel][b_]:={{None,None},{b,None}}
NormalizeGraphicsOpt[FrameLabel][{b_,l_,t_:None,r_:None,___}]:={{l,r},{b,t}}
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


End[]
