(* ::Package:: *)

$TutorialCreatingSymbolPages=Tutorial["Creating Symbol Documentation Pages"];


Begin[BuildAction]


DocumentationHeader[$TutorialCreatingSymbolPages]=FSTutorialHeader;


TutorialSections[$TutorialCreatingSymbolPages,"Introduction"]={
  "The ForScience paclet provides all the tools necessary to build documentation pages with the same look and functionality as the original documentation of ```Mathematica```. The information to generate these pages is simply attached to symbols. Formatting is achieved via a simple markup syntax instead of the string box structure normally used. This allows the documentation builder tools to have more control over the data and it is more suited for use with version control systems, as file changes are more easily identified.",
  "This tutorial discusses how to use the documentation framework of the ForScience paclet to create a fully featured documentation page for a symbol."
};


TutorialSections[$TutorialCreatingSymbolPages,"Metadata Symbols"]={
  "The different sections of a symbols documentation page are handled by different metadata symbols, as listed in the following table:",
  Labeled[
    Grid@{
      {Label["Symbol"],Label["Handles"]},
      {DocumentationHeader,"Basic information about the header and footer of the documentation notebook"},
      {Usage,"Usage messages of symbols, similar to sym::usage"},
      {Details,"Content (text, tables, \[Ellipsis]) of the \"Details and Options\" section"},
      {Examples,"Example (sub)sections, demonstrating sample in/outputs"},
      {SeeAlso,"Related symbols that might also be of interest"},
      {Tutorials,"Related tutorials"},
      {Guides,"Related guides"}
    },
    "Metadata symbols for symbol documentation pages"
  ],
  "All information stored for a symbol are conveniently attached to that symbol as upvalues, making it easy to check and potentially clear the data. The different symbols support different types of content, as each is adapted for a specific section of the final documentation notebook. Generally, the loosely structured sections (e.g. [*Details*] and [*Examples*] in the case of symbols) support the insertion of arbitrary contents, specified as [*Cell*], [*BoxData*] or raw expressions. See the individual documentation pages for more information."
};


TutorialSections[$TutorialCreatingSymbolPages,"Creating the Documentation Page","Setting up the symbol"]={
  "The very first step is to load the ForScience package that enables all the functionality needed:",
  ExampleInput[
    Needs["ForScience`PacletUtils`"]
  ],
  "The first step to creating a documentation page is to create a symbol or function with some interesting functionality. For the purpose of this tutorial, the function SignedSqrt will be used:",
  ExampleInput[Clear@SignedSqrt;,Visible->False],
  ExampleInput[
    SignedSqrt[x_?Positive]:=Sqrt[x],
    SignedSqrt[x_]:=-Sqrt[-x]
  ],
  "This function simply preserves the sign of a given number when computing the square root, instead of generating imaginary results.",
  "To enable building of the documentation page by [*DocumentationBuilder*], the [*DocumentationHeader*] of SignedSqrt needs to be set.",
  ExampleInput[
    DocumentationHeader[SignedSqrt]={"EXAMPLE SYMBOL",Red,"An example from the ForScience documentation"};
  ],
  "Currently, the documentation page for the newly created symbol is very empty:",
  ExampleInput[
    DocumentationBuilder[SignedSqrt]
  ],
  ExampleInput[NotebookClose[%];,Visible->False],
  "The following sections show how content can be added to each of the sections to make the page more informative."
};


TutorialSections[$TutorialCreatingSymbolPages,"Creating the Documentation Page","Giving a Usage Message"]={
  "The first important step is to attach a usage message to the function. This gives the user an overview over the different ways to call a given function together with a brief description of the functionality. In the case of the SignedSqrt function, the message is very simple:",
  ExampleInput[
    Usage[SignedSqrt]="SignedSqrt[x] returns [*Sqrt[x]*] for positive ```x```, and -[*Sqrt[-x]*] for negative ```x```.";
  ],
  "Note the use of the formatting specifications (explained in full detail in the documentation of [*FormatUsage*]), which control the formatting and hyperlinking (see below) of the text. The effect of this assignment is threefold:",
  "First, the usage string is attached to SignedSqrt as upvalue, as mentioned previously.",
  ExampleInput[
    "Definition[SignedSqrt]"
  ],
  "Second, the usage message SignedSqrt::usage is set to the formatted version of the message set. Manually specifying this usage message with proper formatting can be quite difficult, but [*Usage*] ensures that the generated string is fully compatible with what the front end expects:",
  ExampleInput[
    "?SignedSqrt"
  ],
  "Also note how hovering over the symbol provides the familiar drop-down with the usage cases and descriptions.",
  BoxData@GraphicsBox[RasterBox[CompressedData["
  1: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
  a/8HdHDvQw=="],{{0,94},{371,0}},{0,255},ColorFunction->RGBColor],ImageSizeRaw->{371, 94},PlotRange->{{0, 371}, {0, 94}}],
  "The third thing that happens is that the usage cases are now listed in the documentation page of SignedSqrt, properly formatted and hyperlinked:",
  ExampleInput[
    DocumentationBuilder[SignedSqrt]
  ],
  ExampleInput[NotebookClose[%];,Visible->False]
};


TutorialSections[$TutorialCreatingSymbolPages,"Creating the Documentation Page","Adding Details"]={
  "Now that the usage message is set up, it's time to add some further details to the documentation page. The [*Details*] metadata symbol handles all the content of the \"Details and Options\" section, which typically contains a list of short notes about the function and tables detailing the options and possible option values. In the case of SignedSqrt, there is not much to say:",
  ExampleInput[
    "Details[SignedSqrt]={
      \"[*SignedSqrt*] is equivalent to [*Sqrt*] for positive numbers.\",
      \"[*SignedSqrt*] for negative numbers returns minus the square root of the absolute value of the number.\",
      \"This function is defined as part of the <*Tutorial//Creating Symbol Documentation Pages*> tutorial.\"
    };"
  ],
  "Again, the data are attached to SignedSqrt as an upvalue. The documentation page now contain an additional section:",
  ExampleInput[
    DocumentationBuilder[SignedSqrt]
  ],
  ExampleInput[NotebookClose[%];,Visible->False]
};


TutorialSections[$TutorialCreatingSymbolPages,"Creating the Documentation Page","Adding Examples"]={
  "The last big part of any symbol documentation is the example section, which is accessed via the [*Examples*] metadata symbol. To simplify access to the different, possibly nested, sections and subsection, [*Examples*] supports accessing each (sub)section individually using [*Examples[sym,sec,subsec,\[Ellipsis]]*]. Example code with its associated output can be added using [*ExampleInput*], as demonstrated in the following:",
  ExampleInput[
    "Examples[SignedSqrt,\"Basic examples\"]={
      {
        \"For positive numbers, [*SignedSqrt*] works just like [*Sqrt*]:\",
        ExampleInput[
          SignedSqrt[4]
        ]
      },
      {
        \"For negative numbers, the sign is essentially left alone:\",
        ExampleInput[
          SignedSqrt[-4]
        ]
      }
    };"
  ],
  ExampleInput[
    "Examples[SignedSqrt,\"Possible Issues\"]={
      {
        \"[*SignedSqrt*] may behave unexpectedly for arguments that are not real numbers:\",
        ExampleInput[
          SignedSqrt[a],
          SignedSqrt[4+2i]
        ]
      }
    };"
  ],
  "And again, the data are stored as upvalues and the documentation page now includes an additional section:",
  ExampleInput[
    DocumentationBuilder[SignedSqrt]
  ],
  ExampleInput[NotebookClose[%];,Visible->False]
};


TutorialSections[$TutorialCreatingSymbolPages,"Creating the Documentation Page","Related symbols, guides, ..."]={
  "The final information of interest to the user comes in the form of references to related symbols, guides and tutorials. These parts of the documentation page are handles by [*SeeAlso*], [*Guides*] and [*Tutorials*], respectively.",
  ExampleInput[
    SeeAlso[SignedSqrt]={Sqrt};,
    Tutorials[SignedSqrt]={"Creating Symbol Documentation Pages"};
  ],
  ExampleInput[
    DocumentationBuilder[SignedSqrt]
  ],
  ExampleInput[NotebookClose[%];,Visible->False]
};


TutorialSections[$TutorialCreatingSymbolPages,"Closing Remarks"]={
  "This tutorial is not intended as a comprehensive overview of all features supported by the ForScience documentation framework. Instead, it is to be understood as a \"How to get started\" guide that explains the basics. For for in-depth information on the individual sections of the documentation page, see the documentation of the respective symbols. Furthermore, the framework also supports other types of documentation pages, with a similar principle. Details on those can be found e.g. in [*Tutorial*], [*TutorialOverview*] and [*Guide*]."
};


Guides[$TutorialCreatingSymbolPages]={$GuideCreatingDocPages};


End[]
