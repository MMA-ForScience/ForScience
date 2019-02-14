(* ::Package:: *)

CompatibilityChecker;


Begin["`Private`"]


SyntaxInformation[CompatibilityChecker]={"ArgumentsPattern"->{_,OptionsPattern[]}};


Options[CompatibilityChecker]={"WarnForModification"->False};


Attributes[SymbolVersion]={HoldFirst};


SymbolVersion[s_Symbol]:=SymbolVersion[s]=
 WolframLanguageData[
   SafeSymbolName@s,
   "VersionIntroduced"
 ]/._Missing->0
Attributes[SymbolVersion]={HoldFirst};


Attributes[SymbolModVersion]={HoldFirst};


SymbolModVersion[s_Symbol]:=SymbolModVersion[s]=
 WolframLanguageData[
   SafeSymbolName@s,
   "VersionLastModified"
 ]/._Missing->SymbolVersion[s]
Attributes[SymbolModVersion]={HoldFirst};


CompatibilityChecker::tooNew="Symbol `` was only introduced in version ``.";
CompatibilityChecker::tooNewMod="Symbol `` was modified in version ``.";
CompatibilityChecker[ver_,OptionsPattern[]][exprs_]:=(
  Cases[
    exprs,
    s:Except[HoldPattern@Symbol[___],_Symbol]:>
     With[
       {sVer=If[OptionValue["WarnForModification"],
         SymbolModVersion[s],
         SymbolVersion[s]
       ]},
       If[sVer>ver,
         If[OptionValue["WarnForModification"],
           Message[CompatibilityChecker::tooNewMod,HoldForm@s,sVer],
           Message[CompatibilityChecker::tooNew,HoldForm@s,sVer]
         ]
       ]
     ],
    {3,Infinity},
    Heads->True
  ];
  exprs
)


End[]
