(* ::Package:: *)

BeginPackage["ForScience`PacletUtils`",{"PacletManager`","JLink`","DocumentationSearch`"}]


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
<<`DocID`;
<<`DocUtils`;
<<`DocumentationHeader`;
<<`DocumentationCache`;
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
<<`DocumentationOptions`;
<<`Abstract`;
<<`GuideSections`;
<<`TutorialSections`;
<<`OverviewEntries`;
<<`Details`;
<<`ExampleInput`;
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


<<`PacletSelfCheck`;


BuildAction[
  <<`GuidePacletUtils`;
  <<`GuideCreatingDocumentationPages`;

  <<`TutorialCreatingSymbolPages`;
]


EndPackage[]
