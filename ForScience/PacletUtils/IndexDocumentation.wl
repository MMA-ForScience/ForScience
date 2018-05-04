Begin["`Private`"]


DownValues[NewDocumentationNotebookIndexer]=DownValues[NewDocumentationNotebookIndexer]/.
  HoldPattern@AddToClassPath[p_]:>AddToClassPath[p,Prepend->True];


Options[IndexDocumentation]=Options[DocumentationCachePut];


IndexDocumentation[dir_,useCached_,OptionsPattern[]]:=With[
  {
    cacheDirectory=FileNameJoin@{Directory[],OptionValue["CacheDirectory"],"indexes"},
    indexDirectory=FileNameJoin@{Directory[],dir,"Index"},
    spellDirectory=FileNameJoin@{Directory[],dir,"SpellIndex"},
    searchDirectory=FileNameJoin@{Directory[],dir,DocumentationSearch`Private`$indexName}
  },
  With[
    {
      cachedIndex=FileNameJoin@{cacheDirectory,"Index"},
      cachedSpell=FileNameJoin@{cacheDirectory,"SpellIndex"},
      cachedSearch=FileNameJoin@{cacheDirectory,DocumentationSearch`Private`$indexName}
    },
    With[
      {
        cachedDirs={cachedIndex,cachedSpell,cachedSearch},
        dirs={indexDirectory,spellDirectory,searchDirectory}
      },
      If[
        !useCached||
        !AllTrue[cachedDirs,DirectoryQ]||
        Check[
          MapThread[CopyDirectory,{cachedDirs,dirs}];
          False,
          Quiet[DeleteDirectory[#,DeleteContents->True]&/@Join[dirs,cachedDirs]];
          True
        ],
        With[
          {
            oldJVM=JLink`Package`getDefaultJVM[],
            oldCP=JavaClassPath[]
          },
          Internal`WithLocalSettings[
            (* use separate JVM for indexer, as old lucene library breaks help center *)
            InstallJava[ForceLaunch->True,Default->True],
            With[
              {indexer=NewDocumentationNotebookIndexer@indexDirectory},
              AddDocumentationNotebook[indexer,#]&/@FileNames["*.nb",dir,\[Infinity]];
              CloseDocumentationNotebookIndexer@indexer;
              CreateSpellIndex[indexDirectory,spellDirectory];
            ],
            UninstallJava[];
            (*reset classpath to ensure new lucene is found on new JVMs*)
            JLink`Package`$currentClassPath=oldCP;
            JLink`Package`setDefaultJVM[oldJVM];
          ];
          CreateDirectory@searchDirectory;
          First[(*get the JavaObject of the newly created search index to close it*)
            TextSearch`PackageScope`createHandle[
              Quiet@CreateDocumentationIndex[
                dir,
                searchDirectory,
                DocumentationSearch`Private`$indexVersion
              ]
            ]
          ]@close[];
        ];
        Quiet@CreateDirectory[cacheDirectory];
        Quiet[DeleteDirectory[#,DeleteContents->True]&/@cachedDirs];
        MapThread[CopyDirectory,{dirs,cachedDirs}];
      ]
    ]
  ]
]


End[]