(* ::Package:: *)

CompatibilityChecker::usage=FormatUsage@"CompatibilityChecker[ver] is a file processor that checks for each symbol when it was introduced/modified and produces a message if it is newer than ```ver```.";


Begin["`Private`"]


SyntaxInformation[CompatibilityChecker]={"ArgumentsPattern"->{_,OptionsPattern[]}};


Options[CompatibilityChecker]={"WarnForModification"->False};


Attributes[SymbolVersion]={HoldFirst};


SymbolVersion[s_Symbol]:=SymbolVersion[s]=
 WolframLanguageData[
   SymbolName@Unevaluated@s,
   "VersionIntroduced"
 ]/._Missing->0
Attributes[SymbolVersion]={HoldFirst};


Attributes[SymbolModVersion]={HoldFirst};


SymbolModVersion[s_Symbol]:=SymbolModVersion[s]=
 WolframLanguageData[
   SymbolName@Unevaluated@s,
   "VersionLastModified"
 ]/._Missing->SymbolVersion[s]
Attributes[SymbolModVersion]={HoldFirst};


versionCheck::tooNew="Symbol `` was only introduced in version ``.";
versionCheck::tooNewMod="Symbol `` was modified in version ``.";
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
           Message[versionCheck::tooNewMod,HoldForm@s,sVer],
           Message[versionCheck::tooNew,HoldForm@s,sVer]
         ]
       ]
     ],
    {2,Infinity},
    Heads->True
  ];
  exprs
)


End[]
