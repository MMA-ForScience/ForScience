(* ::Package:: *)

BuildPaclet;
$BuildActive;
$BuiltPaclet;
$BuildCacheDirectory;


Begin["`Private`"]


If[!TrueQ[$BuildActive],
  $BuildActive=False;
  $BuiltPaclet="";
  $BuildCacheDirectory="";
]


Options[BuildPaclet]={"BuildDirectory"->"build/","CacheDirectory"->"cache/",ProgressIndicator->True};


SyntaxInformation[BuildPaclet]={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};


BuildPaclet::noDir="The specified path `` is not a directory";
BuildPaclet::cleanFailed="Could not delete build directory ``.";
BuildPaclet::initFailed="Build initialization failed.";


procList={Except[_List]...};
procLists={procList,procList};
flatOpts=OptionsPattern[]?(Not@*ListQ);


GetMarker;


BuildPaclet[dir_,o:flatOpts]:=foo[dir,{},o]
BuildPaclet[dir_,postProcs:procList,gProcs:(procList|procLists):{},o:flatOpts]:=
 BuildPaclet[dir,{{},postProcs},gProcs,o]
BuildPaclet[dir_,procs:procLists,gPostProcs:procList:{},o:flatOpts]:=
 BuildPaclet[dir,procs,{{},gPostProcs},o]
BuildPaclet[dir_,procs:{preProcs:procList,postProcs:procList},gProcs:{gPreProcs:procList,gPostProcs:procList},o:flatOpts]:=
With[
  {
    buildDir=OptionValue["BuildDirectory"],
    cacheDir=OptionValue["CacheDirectory"],
    absoluteCacheDir=AbsoluteFileName@OptionValue["CacheDirectory"],
    oldBuildActive=$BuildActive,
    oldBuiltPaclet=$BuiltPaclet,
    oldCacheDirectory=$BuildCacheDirectory
  },
  If[!DirectoryQ[dir],Message[BuildPaclet::noDir,dir];Return@$Failed];
  If[
    FileExistsQ@FileNameDrop[#,0]&&!DirectoryQ@#,
    Message[BuildPaclet::noDir,#];
    Return@$Failed
  ]&/@{buildDir,cacheDir};
  If[DirectoryQ@buildDir&&Quiet@DeleteDirectory[buildDir,DeleteContents->True]===$Failed,
    Message[BuildPaclet::cleanFailed,buildDir];
    Return@$Failed
  ];
  Check[
    CopyDirectory[dir,buildDir];
    If[!FileExistsQ@cacheDir,
      CreateDirectory[cacheDir]
    ];
    SetDirectory[buildDir],
    Message[BuildPaclet::initFailed];
    Return@$Failed
  ];
  $BuildActive=True;
  $BuiltPaclet=KeyMap[ToString,Association@@Get["PacletInfo.m"]]["Name"];
  $BuildCacheDirectory=absoluteCacheDir;
  If[OptionValue@ProgressIndicator,PrintTemporary@"Running pre-processors..."];
  #[]&/@gPreProcs;
  Module[
    {trackGet=True,getTag,loadedFiles,curFile,prog=0},
    (* make sure local version is found, see https://mathematica.stackexchange.com/a/66118/36508*)
    PacletDirectoryAdd["."];
    loadedFiles=First@Last@Reap[
      Internal`InheritedBlock[
        {Get},
        Unprotect@Get;
        Get[file_]:=With[
          {s=Stack[]},
          (
            If[StringStartsQ[#,Directory[]],
              Block[
                {trackGet=False},
                ProcessFile[preProcs]@Sow[#,getTag]
              ]
            ]&@(curFile=FindFile@file);
            ++prog;
            First@GetMarker[Get@file]
          )/;trackGet&&Length@s<3||s[[-3]]=!=GetMarker
        ];
        If[OptionValue@ProgressIndicator,
          PrintTemporary@"Loading paclet files...";
          Monitor[
            Get[dir<>"`"],
            Row@{ProgressIndicator[prog,Indeterminate]," ",curFile}
          ],
          Get[dir<>"`"]
        ];
      ],
      getTag
    ];
    PacletDirectoryRemove["."];
    loadedFiles=Select[StringStartsQ[Directory[]]]@loadedFiles;
    If[OptionValue@ProgressIndicator,PrintTemporary@"Processing files..."];
    If[OptionValue@ProgressIndicator,Apply@Monitor,First]@Hold[
      prog=0;
      (curFile=#;++prog;ProcessFile[postProcs]@#)&/@loadedFiles,
      Row@{ProgressIndicator[prog,{0,Length@loadedFiles}]," ",curFile}
    ];
    If[OptionValue@ProgressIndicator,PrintTemporary@"Running post-processors..."];
    #[]&/@gPostProcs;
    ResetDirectory[];
    $BuildActive=oldBuildActive;
    $BuiltPaclet=oldBuiltPaclet;
    $BuildCacheDirectory=oldCacheDirectory;
    PackPaclet[buildDir]
  ]
]


End[]
