(* ::Package:: *)

BuildPaclet::usage=FormatUsage@"BuildPaclet[dir] copies the content of ```dir``` to the build directory specified by the '''\"BuildDirectory\"''', loads it option and packs the paclet.
BuildPaclet[dir,{postProc_1,\[Ellipsis]}] applies all ```postProc_i``` to any files loaded during paclet load using [*ProcessFile*]
BuildPaclet[dir,{*preProc_1,\[Ellipsis]},{postProc_1,\[Ellipsis]*}] applies any ```preProc_i``` before the file is actually loaded.
BuildPaclet[dir,{\[Ellipsis]},{globalPostProc_1,\[Ellipsis]}] evaluates all ```globalPostProc_i``` after the paclet has been loaded from the build directory.
BuildPaclet[dir,{\[Ellipsis]},{*globalPreProc_1,\[Ellipsis]},{globalPostProc_1,\[Ellipsis]*}] evaluates all ```globalPreProc_i``` before the paclet is loaded from the build directory.";
$BuildActive::usage=FormatUsage@"'''$BuildActive''' is '''True''' whenever a paclet is currently being built (see [*BuildPaclet*]).";


Begin["`Private`"]


$BuildActive=False;


Options[BuildPaclet]={"BuildDirectory"->"build/"};


SyntaxInformation[BuildPaclet]={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};

BuildPaclet::noDir="The specified path `` is not a directory";

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
    If[!DirectoryQ[dir],Message[BuildPaclet::noDir,dir];Return[]];
    Quiet@DeleteDirectory[buildDir,DeleteContents->True];
    CopyDirectory[dir,buildDir];
    SetDirectory[buildDir];
    CompoundExpression@@gPreProcs;
    Module[
      {trackGet=True,getTag,loadedFiles},
      (* make sure local version is found, see https://mathematica.stackexchange.com/a/66118/36508*)
      PacletDirectoryAdd["."];
      loadedFiles=First@Last@Reap[
        Internal`HandlerBlock[
          {
            "GetFileEvent",
            Replace[_[f_,_,First]:>Sow[FindFile@f,getTag]]
          },
          Get[dir<>"`"]
        ],
        getTag
      ];
      PacletDirectoryRemove["."];
      loadedFiles=Select[StringStartsQ[Directory[]]]@loadedFiles;
      ProcessFile[postProcs]/@loadedFiles;
      CompoundExpression@@gPostProcs;
      ResetDirectory[];
      PackPaclet[buildDir]
    ]
  ]
]


End[]
