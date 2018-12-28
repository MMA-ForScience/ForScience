(* ::Package:: *)


Begin["`Private`"]


ExtractGraphics[gr_Graphics]:=gr
ExtractGraphics[Legended[expr_,__]]:=expr


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
NormalizedOptionValue[g_,opt_]:=NormalizeGraphicsOpt[opt][OptionValue[Graphics,Options@g,opt]]


End[]
