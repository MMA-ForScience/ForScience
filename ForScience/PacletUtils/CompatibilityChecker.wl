(* ::Package:: *)

Usage[CompatibilityChecker]="CompatibilityChecker[ver] is a file processor that checks for each symbol when it was introduced/modified and produces a message if it is newer than ```ver```.";


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


BuildAction[


DocumentationHeader[CompatibilityChecker]=FSHeader["0.51.0","0.61.11"];


Details[CompatibilityChecker]={
  "[*CompatibilityChecker[\[Ellipsis]]*] is a file processor to be used by [*ProcessFile*] and [*BuildPaclet*].",
  "[*CompatibilityChecker*] uses [*WolframLanguageData*] to determine the version a symbol was introduced/last modified.",
  "[*CompatibilityChecker*] accepts the following options:",
  TableForm@{
    {"\"WarnForModification\"",False,"Whether to check for the version of last modification instead"}
  },
  "[*CompatibilityChecker*] issues a CompatibilityChecker::tooNew/CompatibilityChecker::tooNewMod message for each offending symbol use.",
  "[*CompatibilityChecker*] does not modify the contents of the processed file."
};


Examples[CompatibilityChecker,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Create a test file:",
    ExampleInput[
      SetDirectory@CreateDirectory[];,
      "Export[\"test.wl\",
        \"
          Print[1];
          Plot[x,{x,0,1}];
          Echo[2];
        \",
        \"String\"
      ];",
      InitializationCell->True
    ],
    "Check for version 9 compatibility:",
    ExampleInput[ProcessFile["test.wl",{CompatibilityChecker[9]}]]
  },
  {
    "Check for version 11 compatibility:",
    ExampleInput[ProcessFile["test.wl",{CompatibilityChecker[11]}]]
  },
  {
    "Check for symbols that were modified after version 11:",
    ExampleInput[ProcessFile["test.wl",{CompatibilityChecker[11,"WarnForModification"->True]}]]
  }
};


Examples[CompatibilityChecker,"Possible issues"]={
  {
    "Repeated messages of the same type are suppressed by default:",
    ExampleInput[
      "Export[\"tooMany.wl\",
        \"
          newSymbols={Echo,EchoFunction,SequenceReplace,Nothing,Unevaluated};
        \",
        \"String\"
      ];",
      ProcessFile["tooMany.wl",{CompatibilityChecker[9]}]
    ],
    "Turn off General::stop to display all messages:",
    ExampleInput[
      Off[General::stop],
      ProcessFile["tooMany.wl",{CompatibilityChecker[9]}],
      On[General::stop]
    ]
  },
  {
    "Unknown symbols are ignored:",
    ExampleInput[
      "Export[\"typos.wl\",
        \"
          unknownSymbols={EcoFunction,Noting,listPlot};
        \",
        \"String\"
      ];",
      ProcessFile["typos.wl",{CompatibilityChecker[1]}]
    ],
    ExampleInput[
      With[
        {dir=Directory[]},
        ResetDirectory[];
        DeleteDirectory[dir,DeleteContents->True];
      ];
      NotebookDelete[EvaluationCell[]];
    ]
  }
};


SeeAlso[CompatibilityChecker]={BuildPaclet,ProcessFile,UsageCompiler,VariableLeakTracer};


]
