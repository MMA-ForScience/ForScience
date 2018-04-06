(* ::Package:: *)

PublishRelease::usage=FormatUsage@"PublishRelease[opts] creates a new GitHub release for a paclet file in the current folder. Requires access token with public_repo access.";


Begin["`Private`"]


PublishRelease::remoteNewer="The online version of the source code (`2`) is newer than the version of the local paclet file (`1`). Ensure that the latest version is built.";
PublishRelease::localNewer="The version of the local paclet file (`1`) is newer than the online version of the source code (`2`). Ensure that the latest changes have been pushed.";
PublishRelease::checkFailed="Could not connect to GitHub.";
PublishRelease::createFailed="Could not create new release draft. Failed with message: ``";
PublishRelease::uploadFailed="Could not upload paclet file. Failed with message: ``";
PublishRelease::publishFailed="Could not publish release. Failed with message: ``";
PublishRelease[OptionsPattern[]]:=Let[
  {
    repo=OptionValue@"Repository",
    branch=OptionValue@"Branch",
    pacletFile=First@FileNames@"*.paclet",
    packageName=OptionValue@"PackageName"/.Automatic->First@StringCases[pacletFile,RegularExpression["(.*)-[^-]*"]->"$1"],
    localVerStr=StringTake[pacletFile,{12,-8}],
    localVer=ToExpression/@StringSplit[localVerStr,"."],
    remoteVerStr=Lookup[
      Association@@Import[
        SPrintF["https://raw.githubusercontent.com/``/``/``/PacletInfo.m",repo,branch,packageName]
      ],
      Key@Version,
      Message[PublishRelease::checkFailed];Abort[];
    ],
    remoteVer=ToExpression/@StringSplit[remoteVerStr,"."],
    headers="Headers"->{"Authorization"->"token "<>OptionValue@"Token"}
  },
  Switch[Order[localVer,remoteVer],
    1,Message[PublishRelease::remoteNewer,localVerStr,remoteVerStr],
    -1,Message[PublishRelease::localNewer,localVerStr,remoteVerStr],
    0,DynamicModule[
      {prerelease=True},
      Row@{
        Button[SPrintF["Publish `` version `` on GitHub",packageName,localVerStr],
          Module[
            {createResponse,uploadUrl,uploadFileRespone,publishResponse},
            Echo["Creating release draft..."];
            createResponse=Import[
              HTTPRequest[
                SPrintF["https://api.github.com/repos/``/releases",repo],
                <|
                  "Body"->ExportString[<|
                    "tag_name"->"v"<>localVerStr,
                    "target_commitish"->branch,
                    "name"->"Version "<>localVerStr,
                    "draft"->True,
                    "prerelease"->prerelease
                  |>,"RawJSON"],
                  headers
                |>
              ],
              "RawJSON"
            ];
            uploadUrl=StringReplace["{"~~__~~"}"->"?name="<>pacletFile]@Lookup[createResponse,"upload_url",Message[PublishRelease::createFailed,createResponse@"message"];Abort[]];
            Echo["Uploading paclet file..."];
            uploadFileRespone=Import[
              HTTPRequest[
                uploadUrl,
                <|
                  "Body"->ByteArray@BinaryReadList[pacletFile,"Byte"],
                  headers,
                  "ContentType"->"application/zip",
                  Method->"POST"
                |>
              ],
              "RawJSON"
            ];
            Lookup[uploadFileRespone,"url",Message[PublishRelease::uploadFailed,uploadFileRespone@"message"]Abort[];];
            Echo["Publishing release..."];
            publishResponse=Import[
              HTTPRequest[
                createResponse@"url",
                <|
                  "Body"->ExportString[<|"draft"->False|>,"RawJSON"],
                  headers
              |>
              ],
              "RawJSON"
            ];
            Lookup[publishResponse,"url",Message[PublishRelease::publishFailed,publishResponse@"message"]Abort[];];
            Echo["Done."];
          ],
          Method->"Queued"
        ],
        "  Prerelease: ",
        Checkbox@Dynamic@prerelease
      }
    ]
  ]
]
Options[PublishRelease]={"Token"->None,"Branch"->"master","Repository"->"MMA-ForScience/ForScience","PackageName"->Automatic};
SyntaxInformation[PublishRelease]={"ArgumentsPattern"->{OptionsPattern[]}};


End[]
