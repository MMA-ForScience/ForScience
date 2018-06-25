(* ::Package:: *)

Begin["`Private`"]


DeclareMetadataHandler[handler_,msg_,symPat_,pat_,def_]:=(
  handler/:HoldPattern[handler[sym:symPat]=data:pat]:=(handler[sym]^=data);
  HoldPattern[handler[sym:symPat]=data_]^:=(Message[MessageName[handler,msg],HoldForm@sym,data];data);
  handler[symPat]:=def
)


End[]