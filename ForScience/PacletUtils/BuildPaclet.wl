(* ::Package:: *)

BuildPaclet;
$BuildActive;
$BuiltPaclet;


Begin["`Private`"]


If[!TrueQ[$BuildActive],
  $BuildActive=False;
  $BuiltPaclet="";
]


Options[BuildPaclet]={"BuildDirectory"->"build/",ProgressIndicator->True};


SyntaxInformation[BuildPaclet]={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};

BuildPaclet::noDir="The specified path `` is not a directory";
BuildPaclet::cleanFailed="Could not delete build directory ``.";
BuildPaclet::initFailed="Build initialization failed.";

procList={Except[_List]...};
procLists={procList,procList};
flatOpts=OptionsPattern[]?(Not@*ListQ);

BuildPaclet[dir_,o:flatOpts]:=foo[dir,{},o]
BuildPaclet[dir_,postProcs:procList,gProcs:(procList|procLists):{},o:flatOpts]:=
 BuildPaclet[dir,{{},postProcs},gProcs,o]
BuildPaclet[dir_,procs:procLists,gPostProcs:procList:{},o:flatOpts]:=
 BuildPaclet[dir,procs,{{},gPostProcs},o]
BuildPaclet[dir_,procs:{preProcs:procList,postProcs:procList},gProcs:{gPreProcs:procList,gPostProcs:procList},o:flatOpts]:=
With[
  {
    buildDir=OptionValue["BuildDirectory"],
    oldBuildActive=$BuildActive,
    oldBuiltPaclet=$BuiltPaclet
  },
  If[!DirectoryQ[dir],Message[BuildPaclet::noDir,dir];Return@$Failed];
  If[
    FileExistsQ@FileNameDrop[buildDir,0]&&!DirectoryQ@buildDir,
    Message[BuildPaclet::noDir,buildDir];
    Return@$Failed
  ];
  If[DirectoryQ@buildDir&&Quiet@DeleteDirectory[buildDir,DeleteContents->True]===$Failed,
    Message[BuildPaclet::cleanFailed,buildDir];
    Return@$Failed
  ];
  Check[
    CopyDirectory[dir,buildDir];
    SetDirectory[buildDir];,
    Message[BuildPaclet::initFailed];
    Return@$Failed
  ];
  $BuildActive=True;
  $BuiltPaclet=KeyMap[ToString,Association@@Get["PacletInfo.m"]]["Name"];
  If[OptionValue@ProgressIndicator,PrintTemporary@"Running pre-processors..."];
  #[]&/@gPreProcs;
  Module[
    {trackGet=True,getTag,loadedFiles,curFile,prog=0},
    (* make sure local version is found, see https://mathematica.stackexchange.com/a/66118/36508*)
    PacletDirectoryAdd["."];
    loadedFiles=First@Last@Reap[
      Internal`HandlerBlock[
        {
          "GetFileEvent",
          Replace[_[f_,_,First]/;trackGet:>(
              If[
                StringStartsQ[#,Directory[]],
                ProcessFile[preProcs]@#,
                #
              ]&@Sow[FindFile@f,getTag]
            )
          ]
        },
        If[OptionValue@ProgressIndicator,PrintTemporary@"Loading paclet files..."];
        Get[dir<>"`"]
      ],
      getTag
    ];
    PacletDirectoryRemove["."];
    loadedFiles=Select[StringStartsQ[Directory[]]]@loadedFiles;
    If[OptionValue@ProgressIndicator,PrintTemporary@"Processing files..."];
    If[OptionValue@ProgressIndicator,Apply@Monitor,First]@Hold[
      (curFile=#;++prog;ProcessFile[postProcs]@#)&/@loadedFiles,
      Row@{ProgressIndicator[prog,{0,Length@loadedFiles}]," ",curFile}
    ];
    If[OptionValue@ProgressIndicator,PrintTemporary@"Running post-processors..."];
    #[]&/@gPostProcs;
    ResetDirectory[];
    $BuildActive=oldBuildActive;
    $BuiltPaclet=oldBuiltPaclet;
    PackPaclet[buildDir]
  ]
]


End[]
