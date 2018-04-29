Begin["`Private`"]


DownValues[NewDocumentationNotebookIndexer]=DownValues[NewDocumentationNotebookIndexer]/.
  HoldPattern@AddToClassPath[p_]:>AddToClassPath[p,Prepend->True];

IndexDocumentation[dir_]:=With[
  {
    indexDirectory=FileNameJoin@{Directory[],dir,"Index"},
    spellDirectory=FileNameJoin@{Directory[],dir,"SpellIndex"},
    searchDirectory=FileNameJoin@{Directory[],dir,DocumentationSearch`Private`$indexName}
  },
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
  ]
]


End[]