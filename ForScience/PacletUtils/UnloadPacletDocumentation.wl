(* ::Package:: *)

UnloadPacletDocumentation::usage=FormatUsage@"UnloadPacletDocumentation[paclet] attempts to gracefully unload the documentation of ```paclet``` in order to remove any locks on the directory.";
LoadPacletDocumentation::usage=FormatUsage@"LoadPacletDocumentation[paclet] attempts to load the documentation of a newly installed paclet.";


Begin["`Private`"]

Begin["PacletManager`Documentation`Private`"]
If[!TrueQ@ForScience`PacletUtils`Private`$PacletDocSearchEvaluationLeakFixed&&($VersionNumber<11.2),
  (* fix the error message occuring when starting the documentation center only after DocumentationSearch has been loaded *)
  ForScience`PacletUtils`Private`$PacletDocSearchEvaluationLeakFixed=True;
  DownValues[loadDocSearchPackage]=DownValues[loadDocSearchPackage]/.
   HoldPattern[(_=$searchLanguage)]:>(
     (* this code originally uses Evaluate[Symbol[...]]=...  which fails if the symbol already has a value *)
     ToExpression["DocumentationSearch`$SearchLanguage",InputForm,Hold]/.Hold[s_]:>(s=$searchLanguage)
   )
]
End[]


(* maps the given function over all registered instances of TextSearchIndex *)
ApplyToTextSearchIndexInstances[func_]:=JavaBlock[
  (* first, get the Class object for the TextSearchIndex class *)
  LoadJavaClass["com.wolfram.jlink.JLinkClassLoader"];
  indexClass=JLinkClassLoader`classFromName["com.wolfram.textsearch.TextSearchIndex"];
  (* get java.lang.reflect.Field references to the private fields we need and make them accessible *)
  instances=indexClass@getDeclaredField["instances"];
  directories=indexClass@getDeclaredField["directories"];
  paths=indexClass@getDeclaredField["paths"];
  java`lang`reflect`Field`setAccessible[{instances,directories,paths},True];
  Map[
    (* we supply the function with the object and the value of the two private files 'directories' and 'paths' *)
    func[#,directories@get[#],paths@get[#]]&,
    (* get the instance map (Map<Path,WeakReference<TextSearchIndex>>) and get the dereferenced values *)
    #@get[]&/@JavaObjectToExpression@instances@get[Null]@values[]
  ]
]


UnloadPacletDocumentation::notFound="Paclet `` not found";


UnloadPacletDocumentation[paclet_]:=
With[
  {basePath=FindFile[paclet<>"`"]},
  If[FailureQ@basePath,
    Message[UnloadPacletDocumentation::notFound,paclet],
    With[
      {path=DirectoryName@basePath},
      If[$VersionNumber<11.2,
        (* in 11.1, we can simply call CloseDocumentationIndex on all (spell)indexes that lie in the paclets directory *)
        CloseDocumentationIndex/@Select[
          Join[DocumentationIndexes[],DocumentationSpellIndexes[]],
          StringStartsQ[path]
        ],
        (* in 11.2/11.3, we have to carefully remove the paths from the TextSearchIndex instances via JLink and reflection *)
        ApplyToTextSearchIndexInstances[(* map over all instances *)
          Function[
          {index,directories,paths},
            Map[(* go through all directories add to the TextSearchIndex *)
              If[(* if a directory lies within the paclet directory ... *)
                StringStartsQ[#@getDirectory[]@toAbsolutePath[]@toString[],path],
                (* remove it both from directories (List<...>) and paths (Set<Path>) *)
                directories@remove[#];
                paths@remove[#@getDirectory[]];
              ]&,
              JavaObjectToExpression@directories
            ];
            (* call index.finalizeWrites() - this closes the .indexReader to release the lock *)
            (* it also resets both .indexReader and .indexSearcher to null, so that they will be recreated upon the next call to .search *)
            index@finalizeWrites[];
            (* if the list of directories is now empty, close the index and release the object *)
            (* this happens in 11.2 for the TextSearchIndex instance that creates the TextSearchIndex directory upon updating of the old index *)
            If[directories@size[]==0,
              (* close the instance. This also removes it from the .instances map on the java side *)
              index@close[];
              (* release the object in order to invalidate the entry cached by Mathematica. This ensures that a new instance is created when updating the index the next time *)
              ReleaseJavaObject@index;
            ];
          ]
        ]
      ];
    ]
  ]
]


LoadPacletDocumentation[paclet_]:=Which[11.2<=$VersionNumber,(*this is only necessary in 11.2+, 11.1 properly handles paclet installation *)
  Get["DocumentationSearch`"] (* this seems to be sufficient to get the documentation back up and running *)
]


End[]
