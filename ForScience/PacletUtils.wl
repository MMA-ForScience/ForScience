(* ::Package:: *)

BeginPackage["ForScience`PacletUtils`",{"ForScience`","PacletManager`","JLink`","DocumentationSearch`"}]


(*usage formatting utilities, need to make public before defining, as they're already used in the usage definition*)
<<`FormatUsageCase`;
<<`ParseFormatting`;
<<`MakeUsageString`;
<<`FormatUsage`;
<<`Usage`;

<<`ProcessFile`;
<<`BuildPaclet`;
<<`BuildAction`;
<<`DocumentationType`;
<<`DocumentationCache`;
<<`DocumentationStyling`;
<<`DocID`;
<<`DocUtils`;
<<`DocumentationOptions`;
<<`DocumentationHeader`;
<<`DocumentationFooter`;
<<`IndexDocumentation`;
<<`DocumentationBuilder`;
<<`GuideDocumenter`;
<<`TutorialDocumenter`;
<<`TutorialOverviewDocumenter`;
<<`SymbolDocumenter`;
<<`UsageSection`;
<<`DeclareMetadataHandler`;
<<`DeclareSectionAccessor`;
<<`ExampleInput`;
<<`Abstract`;
<<`GuideSections`;
<<`TutorialSections`;
<<`OverviewEntries`;
<<`Details`;
<<`Examples`;
<<`SeeAlso`;
<<`Tutorials`;
<<`Guides`;
<<`FSHeader`;
<<`CleanExampleDirectory`;
<<`CompatibilityChecker`;
<<`VariableLeakTracer`;
<<`UsageCompiler`;
<<`BuildTimeEvaluate`;
<<`UnloadPacletDocumentation`;


BuildAction[
  (* guide & tutorial symbols. Need to declare them here, as they're used inside Begin[BuildAction] ... End[] *)
  $GuidePacletUtils;
  $GuideCreatingDocPages;
  $TutorialCreatingSymbolPages;
]


<<`FormatUsageCaseDoc`;
<<`ParseFormattingDoc`;
<<`MakeUsageStringDoc`;
<<`FormatUsageDoc`;
<<`UsageDoc`;

<<`ProcessFileDoc`;
<<`BuildPacletDoc`;
<<`BuildActionDoc`;
<<`DocumentationBuilderDoc`;
<<`DocumentationHeaderDoc`;
<<`DocumentationOptionsDoc`;
<<`GuideDoc`;
<<`TutorialDoc`;
<<`TutorialSectionsDoc`;
<<`TutorialOverviewDoc`;
<<`OverviewEntriesDoc`;
<<`AbstractDoc`;
<<`GuideSectionsDoc`;
<<`DetailsDoc`;
<<`ExamplesDoc`;
<<`ExampleInputDoc`;
<<`SeeAlsoDoc`;
<<`TutorialsDoc`;
<<`GuidesDoc`;
<<`FSHeaderDoc`;
<<`CleanExampleDirectoryDoc`;
<<`CompatibilityCheckerDoc`;
<<`VariableLeakTracerDoc`;
<<`UsageCompilerDoc`;
<<`BuildTimeEvaluateDoc`;


<<`PacletSelfCheck`;


BuildAction[
  <<`GuidePacletUtils`;
  <<`GuideCreatingDocumentationPages`;

  <<`TutorialCreatingSymbolPages`;
]


EndPackage[]
