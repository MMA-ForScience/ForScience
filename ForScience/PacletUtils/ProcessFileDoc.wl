(* ::Package:: *)

Usage[ProcessFile]="ProcessFile[file,{proc_1,\[Ellipsis]}] loads ```file```, applies all functions ```proc_i``` in order to the list of held expressions, and exports the result to the same file again.
ProcessFile[{in,out},{proc_1,\[Ellipsis]}] loads file ```in``` and writes the result to ```out```.
ProcessFile[{proc_1,\[Ellipsis]}] is the operator form.";
Usage[$ProcessedFile]="$ProcessedFile is set to the absolute path of the file currently being processed by [*ProcessFile*]. Otherwise, it is '''\"\"'''.";


BuildAction[


DocumentationHeader[ProcessFile]=FSHeader["0.46.0","0.54.0"];


Details[ProcessFile]={
  "[*ProcessFile*] imports and exports files in the \"Package\" format.",
  "The supplied processors are expected to take and return a list of held expressions ({[*HoldComplete[expr_1]*],\[Ellipsis]}).",
  "During the evaluation of [*ProcessFile[in,\[Ellipsis]]*] and [*ProcessFile[{in,out},\[Ellipsis]]*], the variable [*$ProcessedFile*] is set to ```in```.",
  "No symbols are leaked from the processed file, as the file is loaded into a special context.",
  "If the processors do not change anything, the resulting file should functionally be fully equivalent to the original file.",
  "[*ProcessFile*] does not preserve formatting.",
  "Some predefined processors are [*CompatibilityChecker,UsageCompiler*] and [*VariableLeakTracer*]."
};


Examples[ProcessFile,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Create a file containing some expressions:",
    ExampleInput[
      SetDirectory@CreateDirectory[];,
      "Export[\"test.wl\",
        \"
          Print[1]
          a+b
        \",
        \"String\"
      ];",
      InitializationCell->True
     ],
    "Process the file:",
    ExampleInput[ProcessFile["test.wl",{Echo}]]
  },
  {
    "Specify a different output file:",
    ExampleInput[
      ProcessFile[{"test.wl","out.wl"},{Echo}],
      Import["out.wl","String"]
    ]
  },
  {
    "Specify multiple processors, the processors are applied from left to right:",
    ExampleInput[ProcessFile["test.wl",{EchoFunction["1",#&],EchoFunction["2",#&]}]]
  },
  {
    "Perform some modification:",
    ExampleInput[
      ProcessFile["test.wl",{ReplaceAll[Print->Echo]}],
      Import["test.wl","String"]
    ]
  }
};


Examples[ProcessFile,"Properties & Relations"]={
  {
    "Use [*CompatibilityChecker*] to check for symbols that were not introduced in a given version of Mathematica:",
    ExampleInput[
      Export["compatibility.wl","SequenceReplace[{a,b,c,d},{b,_}->x]","String"];,
      ProcessFile["compatibility.wl",{CompatibilityChecker[11]}]
    ]
  }
};


Examples[ProcessFile,"Possible issues"]={
  {
    "Symbols are loaded into a special context, where only System` symbols are defined:",
    ExampleInput[
      ProcessFile["test.wl",{ReplaceAll[{Print->Echo,a->foo}]}],
      Import["test.wl","String"]
    ],
    "Use [*Symbol*] to expand the needed symbols in that same context:",
    ExampleInput[
      "ProcessFile[\"test.wl\",{
        With[
          {a=Symbol[\"a\"]},
          ReplaceAll[#,{Print\[Rule]Echo,a\[Rule]Pi}]
        ]&
      }]",
      Import["test.wl","String"]
    ],
    CleanExampleDirectory
  }
};


SeeAlso[ProcessFile]=Hold[$ProcessedFile,BuildPaclet,CompatibilityChecker,UsageCompiler,VariableLeakTracer];


DocumentationHeader[$ProcessedFile]=FSHeader["0.54.0"];


Details[$ProcessedFile]={
  "[*$ProcessedFile*] is set to the file currently processed by [*ProcessFile*].",
  "If [*ProcessFile*] is not evaluating, [*$ProcessedFile*] is \"\".",
  "[*$ProcessedFile*] is always set to the absolute path of the processed file."
};


Examples[$ProcessedFile,"Basic examples"]={
  {
    "Load the ForScience package:",
    ExampleInput[Needs["ForScience`PacletUtils`"]],
    "Create a file containing some expressions:",
    ExampleInput[
      SetDirectory@CreateDirectory[];,
      "Export[\"test.wl\",
        \"
          Print[1]
          a+b
        \",
        \"String\"
      ];",
      InitializationCell->True
     ],
    "See how [*$ProcessedFile*] is set during the evaluation of [*ProcessFile[\[Ellipsis]]*]:",
    ExampleInput[ProcessFile["test.wl",{Echo[#,FileNameTake@$ProcessedFile]&}]],
    CleanExampleDirectory
  },
  {
    "Outside of [*ProcessFile*] evaluations, [*$ProcessedFile*] is empty:",
    ExampleInput["InputForm[$ProcessedFile]"]
  }
};


SeeAlso[$ProcessedFile]={ProcessFile};


]
