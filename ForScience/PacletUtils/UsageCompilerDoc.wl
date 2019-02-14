(* ::Package:: *)

Usage[UsageCompiler]="UsageCompiler is a file processor that compiles any [*FormatUsage[usage]*] found.";


Begin[BuildAction]


DocumentationHeader[UsageCompiler]=FSHeader["0.52.0","0.59.19"];


Details[UsageCompiler]={
  "[*UsageCompiler*] is a file processor to be used with [*BuildPaclet*] (as post-processor) and [*ProcessFile*].",
  "[*UsageCompiler*] compiles all expressions of the form [*FormatUsage[usage]*] and [*Usage[sym]*]'''=```usage```'''.",
  "For expressions of the form [*FormatUsage[usage]*] the resulting expression is fully equivalent.",
  "Expressions of the form [*Usage[sym]*]'''=```usage```''' are replaced by '''```sym```::usage=```formatted```''', losing the metadata necessary for [*DocumentationBuilder*]. Since [*UsageCompiler*] is intended to be used as part of [*BuildPaclet*], this is not an issue, as the metadata are not necessary after building.",
  "Applying [*UsageCompiler*] to a file can significantly decrease loading time, depending on the complexity of the strings to be formatted."
};


Examples[UsageCompiler,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Create a test file with some usage messages inside:",
    ExampleInput[
      SetDirectory@CreateDirectory[];,
      "Export[\"test.wl\",
        \"
          foo::usage=FormatUsage@\\\"foo[a,b] is a function.\\\";
          Usage[bar]=\\\"bar[\[LeftAssociation]a\[Rule]b\[RightAssociation],c_i] is another function.\\\";
        \",
        \"String\"
      ];",
      InitializationCell->True
    ],
    "Process the file using [*UsageCompiler*]:",
    ExampleInput[ProcessFile["test.wl",{UsageCompiler}];],
    "The file now directly contains the formatted usage strings:",
    ExampleInput[Import["test.wl","String"]]
  }
};


Examples[UsageCompiler,"Possible issues"]={
  {
    "For expressions of the form [*Usage[sym]*]'''=```usage```''', [*Usage*] metadata are lost:",
    ExampleInput[ClearAll["bar"],Visible->False],
    ExampleInput[
      Import["test.wl"],
      "?bar",
      "InputForm[Usage[bar]]"
    ],
    CleanExampleDirectory
  }
};


SeeAlso[UsageCompiler]={BuildPaclet,ProcessFile,Usage,FormatUsage,CompatibilityChecker,VariableLeakTracer};


End[]
