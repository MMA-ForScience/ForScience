(* ::Package:: *)

Usage[BuildPaclet]="BuildPaclet[dir] copies the content of ```dir``` to the build directory specified by the '''\"BuildDirectory\"''', loads it and packs the paclet.
BuildPaclet[dir,{postProc_1,\[Ellipsis]}] applies all ```postProc_i``` to any files loaded during paclet load using [*ProcessFile*]
BuildPaclet[dir,{{preProc_1,\[Ellipsis]},{postProc_1,\[Ellipsis]}}] applies any ```preProc_i``` before the file is actually loaded.
BuildPaclet[dir,{\[Ellipsis]},{globalPostProc_1,\[Ellipsis]}] evaluates all ```globalPostProc_i``` after the paclet has been loaded from the build directory.
BuildPaclet[dir,{\[Ellipsis]},{{globalPreProc_1,\[Ellipsis]},{globalPostProc_1,\[Ellipsis]}}] evaluates all ```globalPreProc_i``` before the paclet is loaded from the build directory.";
Usage[$BuildActive]="$BuildActive is '''True''' whenever a paclet is currently being built (see [*BuildPaclet*]).";
Usage[$BuiltPaclet]="$BuiltPaclet is set to the name of the actively built paclet. If no paclet is being built, this is '''\"\"'''.";
Usage[$BuildCacheDirectory]="$BuildCacheDirectory is set to the absolute path to the cache directory specified for [*BuildPaclet*] during build. If no paclet is being built, this is '''\"\"'''."


Begin[BuildAction]


DocumentationHeader[BuildPaclet]=FSHeader["0.48.0","0.83.10"];


Details[BuildPaclet]={
  "[*BuildPaclet*] is the main function of the paclet build framework.",
  "[*BuildPaclet*] returns the path to the packed .paclet file.",
  "[*BuildPaclet*] copies the files from the paclet directory ```dir``` to a temporary build directory before packing them.",
  "During [*BuildPaclet[dir,\[Ellipsis]]*], the paclet is loaded directly from the directory, even if it is already installed.",
  "To guarantee proper loading, the paclet should load all subcomponents using [*Get*].",
  "[*BuildPaclet*] accepts the following options:",
  TableForm@{
    {"\"BuildDirectory\"","\"build/\"","The working directory of [*BuildPaclet*]"},
    {"\"CacheDirectory\"","\"cache/\"","The directory for caching things between builds"}
  },
  "File pre/post-processors are effectively handled using [*ProcessFile*].",
  "File pre-processors are applied to each file in ```dir``` before it is loaded during paclet load. External files are left untouched.",
  "File post-processors are applied at the end once all files are loaded.",
  "Predefined file processors include [*UsageCompiler,CompatibilityChecker,CleanBuildActions*] and [*VariableLeakTracer*].",
  "During evaluation of [*BuildPaclet[\[Ellipsis]]*], the following global variables are set:",
  TableForm@{
    {"[*$BuildActive*]",True},
    {"[*$BuiltPaclet*]","Name of the paclet being built"},
    {"[*$BuildCacheDirectory*]","Absolute path of the specified cache directory"}
  },
  "The working directory is the specified build directory when calling any of the processors.",
  "Global pre-processors are called before anything is loaded, but after basic validation checks have been performed.",
  "Global post-processors are called after everything is loaded and after the file post-processors have been applied.",
  "Global processors get called with no arguments.",
  "[*DocumentationBuilder*] is designed as a global post-processor for [*BuildPaclet*]."
};


SeeAlso[BuildPaclet]=Hold[$BuiltPaclet,$BuildActive,$BuildCacheDirectory,DocumentationBuilder,ProcessFile,CompatibilityChecker,UsageCompiler];


DocumentationHeader[$BuildActive]=FSHeader["0.48.0"];


Details[$BuildActive]={
  "[*$BuildActive*] is [*True*] during evaluation of [*BuildPaclet[\[Ellipsis]]*] and [*False*] otherwise.",
  "[*$BuildActive*] controls the evaluation of [*BuildAction[\[Ellipsis]]*] expressions."
};


SeeAlso[$BuildActive]=Hold[BuildAction,BuildPaclet,$BuiltPaclet,$BuildCacheDirectory];


DocumentationHeader[$BuiltPaclet]=FSHeader["0.55.1"];


Details[$BuiltPaclet]={
  "[*$BuiltPaclet*] is set during the evaluation of [*BuildPaclet[\[Ellipsis]]*] and \"\" otherwise.",
  "[*$BuiltPaclet*] is set to the paclet name as specified in the \"PacletInfo.m\" file."
};


SeeAlso[$BuiltPaclet]=Hold[BuildPaclet,$BuildActive,$BuildCacheDirectory];


DocumentationHeader[$BuildCacheDirectory]=FSHeader["0.83.10"];


Details[$BuildCacheDirectory]={
  "[*$BuildCacheDirectory*] is set during the evaluation of [*BuildPaclet[\[Ellipsis]]*] and \"\" otherwise.",
  "[*$BuildCacheDirectory*] is set to the absolute path of the cache directory specified for [*BuildPaclet*] via the \"CacheDirectory\" option."
};


SeeAlso[$BuildCacheDirectory]=Hold[BuildPaclet,$BuildActive,$BuiltPaclet]


End[]
