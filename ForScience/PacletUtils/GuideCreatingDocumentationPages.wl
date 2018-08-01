(* ::Package:: *)

$GuideCreatingDocPages=Guide["Creating Documentation Pages"];


DocumentationHeader[$GuideCreatingDocPages]=FSGuideHeader;


Abstract[$GuideCreatingDocPages]="The ForScience PacletUtils subpaclet contains powerful documentation creation utilities, enabling a fully Wolfram Language based workflow.";


GuideSections[$GuideCreatingDocPages]={
  {
    {DocumentationBuilder,Text["build individual pages or everything that is documented"]},
    {DocumentationHeader,Text["control basic documentation page appearance"]}
  },
  {
    SectionTitle["Usage Messages"],
    {Usage,FormatUsage,Text["create and specify formatted usage messages"]},
    {ParseFormatting,MakeUsageString,FormatUsageCase,Text["gain more granular control over the formatting process"]}
  },
  {
    SectionTitle["Symbol Reference Pages"],
    {Usage,Text["specify usage cases"]},
    {Details,Text["specify contents of \"Details and Options\""]},
    {Examples,ExampleInput,Text["create interactive examples"]},
    {SeeAlso,Text["refer to other symbols"]},
    {Tutorials,Guides,Text["refer to related tutorials and guides"]}
  },
  {
    SectionTitle["Documenation Guides"],
    {Guide,GuideQ,Text["create a new guide"]},
    {Abstract,Text["specify a summary"]},
    {GuideSections,SectionTitle,Text["specify sections with different functions"]},
    {Tutorials,Guides,Text["refer to related tutorials and guides"]}
  }
};


Guides[$GuideCreatingDocPages]={$GuidePacletUtils};
