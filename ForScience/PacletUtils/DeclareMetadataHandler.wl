Begin["`Private`"]


DeclareMetadataHandler[handler_,msg_,pat_,def_]:=(
  handler/:HoldPattern[handler[sym_]=data:pat]:=(handler[sym]^=data);
  HoldPattern[handler[sym_]=data_]^:=(Message[MessageName[handler,msg],HoldForm@sym,data];data);
  handler[_]:=def
)


End[]