(* ::Package:: *)

UpdateForScience::usage=FormatUsage@"UpdateForScience[] checks whether a newer version of the ForScience package is available. If one is found, it can be downloaded by pressing a button. Use the option '''\"IncludePreReleases\"''' to control whether pre-releases should be ignored.";


Begin["`Private`"]


UpdateForScience[OptionsPattern[]]:=Let[
  {
    latest=First[
      MaximalBy[DateObject@#["published_at"]&]@
       If[OptionValue["IncludePreReleases"],Identity,Select[!#prerelease&]]
        [
          Association@@@Import["https://api.github.com/repos/MMA-ForScience/ForScience/releases","JSON"]
        ],
      <|"tag_name"->"v0.0.0","name"->"","assets"->{}|>
    ],
    file=SelectFirst[Association@@@#assets,StringMatchQ[#name,__~~".paclet"]&,None]&@latest,
    preRel=latest["prerelease"],
    version=StringDrop[latest["tag_name"],1],
    curVer=First[PacletFind["ForScience"],<|"Version"->"0.0.0"|>]["Version"]
  },
  If[
    Order@@(FromDigits/@StringSplit[#,"."]&/@{curVer,version})>0,
    Row@{
      SPrintF["Found version ````, current version is ``.",version,If[preRel," (pre-release)",""],curVer],
      Button[
        "Download & Install",
        PacletUninstall/@PacletFind["ForScience"];
        PacletInstall[URLDownload[#["browser_download_url"],FileNameJoin@{$TemporaryDirectory,#name}]]&@file;
        Print@If[
          PacletFind["ForScience"][[1]]["Version"]===version,
          "Successfully updated",
          "Something went wrong, check manually."
        ];,
        Method->"Queued"
      ]
    },
    "No newer version available"
  ]
]
Options[UpdateForScience]={"IncludePreReleases"->True};
SyntaxInformation[UpdateForScience]={"ArgumentsPattern"->{OptionsPattern[]}};


End[]
