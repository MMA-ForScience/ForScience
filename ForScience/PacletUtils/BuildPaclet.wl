(* ::Package:: *)

BuildPaclet::usage=FormatUsage@"BuildPaclet[dir] copies the content of ```dir``` to the build directory specified by the '''\"BuildDirectory\"''', loads it option and packs the paclet.
BuildPaclet[dir,{postProc_1,\[Ellipsis]}] applies all ```postProc_i``` to any files loaded during paclet load using [*ProcessFile*]
BuildPaclet[dir,{*preProc_1,\[Ellipsis]},{postProc_1,\[Ellipsis]*}] applies any ```preProc_i``` before the file is actually loaded.
BuildPaclet[dir,{\[Ellipsis]},{globalPostProc_1,\[Ellipsis]}] evaluates all ```globalPostProc_i``` after the paclet has been loaded from the build directory.
BuildPaclet[dir,{\[Ellipsis]},{*globalPreProc_1,\[Ellipsis]},{globalPostProc_1,\[Ellipsis]*}] evaluates all ```globalPreProc_i``` before the paclet is loaded from the build directory.";
$BuildActive::usage=FormatUsage@"'''$BuildActive''' is '''True''' whenever a paclet is currently being built (see [*BuildPaclet*]).";
$BuiltPaclet::usage=FormatUsage@"$BuiltPaclet is set to the name of the actively built paclet. If no paclet is being built, this is '''\"\"'''";


Begin["`Private`"]


If[!TrueQ[$BuildActive],
  $BuildActive=False;
  $BuiltPaclet="";
]


Options[BuildPaclet]={"BuildDirectory"->"build/"};


SyntaxInformation[BuildPaclet]={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};

BuildPaclet::noDir="The specified path `` is not a directory";
BuildPaclet::cleanFailed="Could not delete build directory ``.";

procList={Except[_List]...};
procLists={procList,procList};
flatOpts=OptionsPattern[]?(Not@*ListQ);

BuildPaclet[dir_,o:flatOpts]:=foo[dir,{},o]
BuildPaclet[dir_,postProcs:procList,gProcs:(procList|procLists):{},o:flatOpts]:=
 BuildPaclet[dir,{{},postProcs},gProcs,o]
BuildPaclet[dir_,procs:procLists,gPostProcs:procList:{},o:flatOpts]:=
 BuildPaclet[dir,procs,{{},gPostProcs},o]
BuildPaclet[dir_,procs:{preProcs:procList,postProcs:procList},gProcs:{gPreProcs:procList,gPostProcs:procList},o:flatOpts]:=
Block[
  {$BuildActive=True},
  With[
    {
      buildDir=OptionValue["BuildDirectory"]
    },
    If[!DirectoryQ[dir],Message[BuildPaclet::noDir,dir];Return@$Failed];
    If[!DirectoryQ[buildDir],Message[BuildPaclet::noDir,buildDir];Return@$Failed];
    If[Quiet@DeleteDirectory[buildDir,DeleteContents->True]===$Failed,
      Message[BuildPaclet::cleanFailed,buildDir];
      Return@$Failed
    ];
    CopyDirectory[dir,buildDir];
    SetDirectory[buildDir];
    Block[
      {$BuiltPaclet=KeyMap[ToString,Association@@Get["PacletInfo.m"]]["Name"]},
      #[]&/@gPreProcs;
      Module[
        {trackGet=True,getTag,loadedFiles},
        (* make sure local version is found, see https://mathematica.stackexchange.com/a/66118/36508*)
        PacletDirectoryAdd["."];
        loadedFiles=First@Last@Reap[
          Internal`HandlerBlock[
            {
              "GetFileEvent",
              Replace[_[f_,_,First]/;trackGet:>Sow[FindFile@f,getTag]]
            },
            Get[dir<>"`"]
          ],
          getTag
        ];
        PacletDirectoryRemove["."];
        loadedFiles=Select[StringStartsQ[Directory[]]]@loadedFiles;
        ProcessFile[postProcs]/@loadedFiles;
        #[]&/@gPostProcs;
        ResetDirectory[];
        PackPaclet[buildDir]
      ]
    ]
  ]
]


End[]
