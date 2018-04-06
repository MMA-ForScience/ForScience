(* ::Package:: *)

PullUp::usage=FormatUsage@"PullUp[data,keys,datakey] groups elements of ```data``` by the specified ```keys``` and puts them under ```datakey``` into an association containing those keys.
PullUp[data,gKeys\[Rule]keys,datakey] groups elements of ```data``` by the specified ```gKeys``` and puts them under ```datakey``` into an association containing ```keys``` (values taken from first element).
PullUp[keys,datakey] is the operator form, ```datakey``` is defaulted to '''\"data\"'''.
PullUp[gKeys\[Rule]keys,datakey] is the operator form, ```datakey``` is defaulted to '''\"data\"'''.";


Begin["`Private`"]


PullUp[gKeys_->keys_,datakey_:"data"]:=GroupBy[Query[gKeys]]/*Values/*Map[Append[Query[Flatten@{keys}]@First@#,datakey->#]&]
PullUp[keys_,datakey_:"data"]:=PullUp[keys->keys,datakey]
PullUp[data_,gKeys_->keys_,datakey_]:=PullUp[gKeys->keys,datakey]@data
PullUp[data_,keys_,datakey_]:=PullUp[data,keys->keys,datakey]
SyntaxInformation[PullUp]={"ArgumentsPattern"->{_,_.,_.}};


End[]
