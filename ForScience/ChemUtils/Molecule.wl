(* ::Package:: *)

Molecule::usage=FormatUsage@"Molecule[atoms,bonds] describes a molecule to be plotted with '''MoleculePlot3D'''. ```atoms``` is a list of rules of the the form '''{```element```_1->```pos```_1,\[Ellipsis]}'''. ```bonds``` (if not omitted) is an adjacency matrix or a list of bond specifications (see '''ToBond'''). Use '''Normal@Molecule[\[Ellipsis]]''' to convert to graphics primitives.";


Begin["`Private`"]


$ElementRadii=<|"hydrogen"->24.`,"helium"->28.`,"lithium"->44.`,"beryllium"->38.`,"boron"->36.`,"carbon"->34.`,"nitrogen"->32.`,"oxygen"->31.`,"fluorine"->30.`,"neon"->30.8`,"sodium"->48.`,"magnesium"->44.`,"aluminum"->42.`,"silicon"->42.`,"phosphorus"->39.`,"sulfur"->36.`,"chlorine"->36.`,"argon"->37.6`,"potassium"->56.`,"calcium"->48.`,"scandium"->46.`,"titanium"->43.`,"vanadium"->41.`,"chromium"->41.`,"manganese"->41.`,"iron"->41.`,"cobalt"->40.`,"nickel"->40.`,"copper"->40.`,"zinc"->42.`,"gallium"->42.`,"germanium"->42.`,"arsenic"->41.`,"selenium"->38.`,"bromine"->38.`,"krypton"->40.400000000000006`,"rubidium"->58.`,"strontium"->51.`,"yttrium"->48.`,"zirconium"->46.`,"niobium"->43.`,"molybdenum"->42.`,"technetium"->41.`,"ruthenium"->41.`,"rhodium"->40.`,"palladium"->41.`,"silver"->42.`,"cadmium"->44.`,"indium"->44.`,"tin"->45.`,"antimony"->44.`,"tellurium"->42.`,"iodine"->42.`,"xenon"->43.2`,"cesium"->60.`,"barium"->54.`,"lanthanum"->50.`,"cerium"->49.6`,"praseodymium"->49.400000000000006`,"neodymium"->49.`,"promethium"->48.6`,"samarium"->48.400000000000006`,"europium"->48.`,"gadolinium"->47.6`,"terbium"->47.400000000000006`,"dysprosium"->47.`,"holmium"->46.6`,"erbium"->46.400000000000006`,"thulium"->46.`,"ytterbium"->45.6`,"lutetium"->45.400000000000006`,"hafnium"->45.`,"tantalum"->44.`,"tungsten"->42.`,"rhenium"->41.`,"osmium"->40.`,"iridium"->40.`,"platinum"->41.`,"gold"->42.`,"mercury"->41.`,"thallium"->44.`,"lead"->46.`,"bismuth"->46.`,"polonium"->40.`,"astatine"->40.`,"radon"->40.`,"francium"->40,"radium"->40.`,"actinium"->40.`,"thorium"->48.`,"protactinium"->40.`,"uranium"->46.`,"neptunium"->40.`,"plutonium"->40.`,"americium"->40.`,"curium"->40.`,"berkelium"->40.`,"californium"->40.`,"einsteinium"->40.`,"fermium"->40.`,"mendelevium"->40.`,"nobelium"->40.`,"lawrencium"->40.`,"rutherfordium"->40.`,"dubnium"->40.`,"seaborgium"->40.`,"bohrium"->40.`,"hassium"->40.`,"meitnerium"->40.`,"darmstadtium"->40.`,"roentgenium"->40.`,"copernicium"->40.`,"nihonium"->40.`,"moscovium"->40.`,"tennessine"->40.`,"oganesson"->40.`|>;
$ElementColors=<|"hydrogen"->RGBColor[0.65, 0.7, 0.7],"helium"->RGBColor[0.836713, 1., 1.],"lithium"->RGBColor[0.799435, 0.543572, 0.997559],"beryllium"->RGBColor[0.770565, 0.964309, 0.0442359],"boron"->RGBColor[1., 0.709804, 0.709804],"carbon"->RGBColor[0.4, 0.4, 0.4],"nitrogen"->RGBColor[0.291989, 0.437977, 0.888609],"oxygen"->RGBColor[0.800498, 0.201504, 0.192061],"fluorine"->RGBColor[0.578462, 0.85539, 0.408855],"neon"->RGBColor[0.677263, 0.928423, 0.955287],"sodium"->RGBColor[0.658708, 0.492173, 0.842842],"magnesium"->RGBColor[0.628274, 0.850553, 0.0782731],"aluminum"->RGBColor[0.8913, 0.631904, 0.627399],"silicon"->RGBColor[0.941176, 0.784314, 0.627451],"phosphorus"->RGBColor[1., 0.501961, 0],"sulfur"->RGBColor[0.90443, 0.97015, 0.13504],"chlorine"->RGBColor[0.412698, 0.932689, 0.166398],"argon"->RGBColor[0.546138, 0.844244, 0.892092],"potassium"->RGBColor[0.534026, 0.420729, 0.705621],"calcium"->RGBColor[0.480072, 0.744591, 0.0955222],"scandium"->RGBColor[0.901961, 0.901961, 0.901961],"titanium"->RGBColor[0.74902, 0.760784, 0.780392],"vanadium"->RGBColor[0.65098, 0.65098, 0.670588],"chromium"->RGBColor[0.541176, 0.6, 0.780392],"manganese"->RGBColor[0.611765, 0.478431, 0.780392],"iron"->RGBColor[0.878431, 0.4, 0.2],"cobalt"->RGBColor[0.941176, 0.564706, 0.627451],"nickel"->RGBColor[0.313725, 0.815686, 0.313725],"copper"->RGBColor[0.784314, 0.501961, 0.2],"zinc"->RGBColor[0.490196, 0.501961, 0.690196],"gallium"->RGBColor[0.800757, 0.542666, 0.533513],"germanium"->RGBColor[0.60508, 0.632465, 0.576489],"arsenic"->RGBColor[0.741176, 0.501961, 0.890196],"selenium"->RGBColor[0.917248, 0.657833, 0.0706628],"bromine"->RGBColor[0.58847, 0.22163, 0.16064],"krypton"->RGBColor[0.426019, 0.747462, 0.810413],"rubidium"->RGBColor[0.425391, 0.329242, 0.585895],"strontium"->RGBColor[0.325959, 0.646423, 0.095983],"yttrium"->RGBColor[0.531014, 1., 1.],"zirconium"->RGBColor[0.458599, 0.917466, 0.918573],"niobium"->RGBColor[0.385036, 0.834854, 0.841681],"molybdenum"->RGBColor[0.310325, 0.752163, 0.769323],"technetium"->RGBColor[0.234466, 0.669394, 0.701499],"ruthenium"->RGBColor[0.157459, 0.586546, 0.638209],"rhodium"->RGBColor[0.0793033, 0.50362, 0.579453],"palladium"->RGBColor[0., 0.420615, 0.525231],"silver"->RGBColor[0.752941, 0.752941, 0.752941],"cadmium"->RGBColor[1., 0.85098, 0.560784],"indium"->RGBColor[0.728371, 0.440594, 0.422196],"tin"->RGBColor[0.39799, 0.491477, 0.495586],"antimony"->RGBColor[0.619608, 0.388235, 0.709804],"tellurium"->RGBColor[0.816706, 0.451332, 0.0100947],"iodine"->RGBColor[0.580392, 0, 0.580392],"xenon"->RGBColor[0.316906, 0.638078, 0.710252],"cesium"->RGBColor[0.332803, 0.217712, 0.483666],"barium"->RGBColor[0.165935, 0.55605, 0.0796556],"lanthanum"->RGBColor[0.928084, 0.716075, 0.329427],"cerium"->RGBColor[0.894824, 0.731424, 0.325131],"praseodymium"->RGBColor[0.86523, 0.707999, 0.315261],"neodymium"->RGBColor[0.837836, 0.662974, 0.301635],"promethium"->RGBColor[0.811992, 0.607859, 0.285626],"samarium"->RGBColor[0.787563, 0.549894, 0.268279],"europium"->RGBColor[0.764628, 0.493261, 0.250405],"gadolinium"->RGBColor[0.743177, 0.440115, 0.23269],"terbium"->RGBColor[0.72281, 0.39143, 0.215783],"dysprosium"->RGBColor[0.702434, 0.347663, 0.200392],"holmium"->RGBColor[0.679962, 0.309234, 0.187368],"erbium"->RGBColor[0.652012, 0.276823, 0.17779],"thulium"->RGBColor[0.613603, 0.251489, 0.173042],"ytterbium"->RGBColor[0.557855, 0.234598, 0.17489],"lutetium"->RGBColor[0.475685, 0.227573, 0.18555],"hafnium"->RGBColor[0.781537, 0.717388, 0.716579],"tantalum"->RGBColor[0.734443, 0.544489, 0.683471],"tungsten"->RGBColor[0.681179, 0.360409, 0.63675],"rhenium"->RGBColor[0.605181, 0.367584, 0.556343],"osmium"->RGBColor[0.521806, 0.382125, 0.469204],"iridium"->RGBColor[0.445624, 0.373159, 0.399069],"platinum"->RGBColor[0.815686, 0.815686, 0.878431],"gold"->RGBColor[1., 0.819608, 0.137255],"mercury"->RGBColor[0.721569, 0.721569, 0.815686],"thallium"->RGBColor[0.65098, 0.329412, 0.301961],"lead"->RGBColor[0.341176, 0.34902, 0.380392],"bismuth"->RGBColor[0.619608, 0.309804, 0.709804],"polonium"->RGBColor[0.670588, 0.360784, 0],"astatine"->RGBColor[0.458824, 0.309804, 0.270588],"radon"->RGBColor[0.218799, 0.516091, 0.591608],"francium"->RGBColor[0.25626, 0.0861372, 0.398932],"radium"->RGBColor[0., 0.473472, 0.04654],"actinium"->RGBColor[0.322042, 0.71693, 0.988479],"thorium"->RGBColor[0.3608, 0.67166, 0.943003],"protactinium"->RGBColor[0.397469, 0.628, 0.898853],"uranium"->RGBColor[0.43205, 0.58595, 0.856029],"neptunium"->RGBColor[0.464542, 0.54551, 0.814532],"plutonium"->RGBColor[0.494945, 0.506679, 0.774361],"americium"->RGBColor[0.52326, 0.469458, 0.735517],"curium"->RGBColor[0.549486, 0.433847, 0.697999],"berkelium"->RGBColor[0.573624, 0.399845, 0.661808],"californium"->RGBColor[0.595673, 0.367454, 0.626942],"einsteinium"->RGBColor[0.615633, 0.336672, 0.593404],"fermium"->RGBColor[0.633505, 0.307499, 0.561191],"mendelevium"->RGBColor[0.649288, 0.279937, 0.530305],"nobelium"->RGBColor[0.662982, 0.253984, 0.500746],"lawrencium"->RGBColor[0.674588, 0.22964, 0.472513],"rutherfordium"->RGBColor[0.684106, 0.206907, 0.445606],"dubnium"->RGBColor[0.691534, 0.185783, 0.420025],"seaborgium"->RGBColor[0.696874, 0.166269, 0.395772],"bohrium"->RGBColor[0.700126, 0.148365, 0.372844],"hassium"->RGBColor[0.701289, 0.13207, 0.351243],"meitnerium"->RGBColor[0.700363, 0.117385, 0.330968],"darmstadtium"->RGBColor[0.697348, 0.10431, 0.31202],"roentgenium"->RGBColor[0.692245, 0.0928444, 0.294398],"copernicium"->RGBColor[0.685054, 0.0829886, 0.278102],"nihonium"->RGBColor[0.675773, 0.0747426, 0.263133],"moscovium"->RGBColor[0.650947, 0.0630797, 0.237174],"tennessine"->RGBColor[0.635401, 0.056628, 0.226184],"oganesson"->RGBColor[0.635401, 0.0528, 0.226184]|>;

ApplyScale[b_,Scaled[s_]]:=b s
ApplyScale[_,s_]:=s

Options[DrawBond]={"BondStyle"->Directive[],"BondRadius"->Scaled[1],"BondSpacing"->Scaled[1]};
DrawBond[{s1:{p1_,_},s2:{p2_,_}},t_,{nb1_,nb2_},OptionsPattern[]]:=Let[
  {
    n1=If[t==1,None,iGetBondNormal[{p1,p2},nb1]],
    n2=If[t==1,None,iGetBondNormal[{p2,p1},nb2]],
    offset=If[t==1,None,Normalize[(n1+If[n1.n2>=0,1,-1]n2)\[Cross](p1-p2)]]
  },
  (
    {br,bs,o}\[Function]iDrawBond[
      s1,
      s2,
      #,
      ApplyScale[br,OptionValue["BondRadius"]],
      OptionValue["BondStyle"]
    ]&/@(
      ApplyScale[bs,OptionValue["BondSpacing"]]offset #&/@o
    )
  )@@Switch[t,1,{15,0,{0}},2,{8,14,{1,-1}},3,{6,21,{1,0,-1}}]
]

iDrawBond[{p1_,sty1_},{p2_,sty2_},offset_,r_,sty_]:=Let[
  {
    sp1=p1+offset,
    sp2=p2+offset,
    mid=Mean@{sp1,sp2}
  },
  {{Directive[sty1,sty],Tube[{sp1,mid},r]},{Directive[sty2,sty],Tube[{mid,sp2},r]}}
]
iGetBondNormal[{p1_,p2_},neigh_]:=Let[
  {
    offsets=Normalize[#-p1]&/@Complement[neigh,{p2}],
    avg=Normalize@Total@offsets
  },
  If[Length@offsets>0,Normalize[(p2-p1)\[Cross]avg],{0,0,0}]
]

ElementInterpreter[el_]:=ElementInterpreter[el]=Interpreter["Element"][el]["Name"]

Attributes[StyleHold]={HoldAll};

Molecule[atoms_,o:OptionsPattern[]]:=Molecule[atoms,None,o]
Options[Molecule]=Join[{BaseStyle->Directive[],"SpaceFilling"->Automatic,Tooltip->False,"AtomStyle"->Directive[],"AtomRadius"->Scaled[1]},Options[DrawBond]];
SyntaxInformation[Molecule]:={"ArgumentsPattern"->{_,_.,OptionsPattern[]}};
Normal[Molecule[atoms_,bonds:(_?ArrayQ|None),o:OptionsPattern[]]]^:=Let[
  {
    spaceFilling=OptionValue[Molecule,"SpaceFilling"]/.Automatic->If[bonds===None,True,False],
    elements=ElementInterpreter/@atoms[[All,1]],
    styles=Directive[$ElementColors@#,OptionValue[Molecule,"AtomStyle"]]&/@elements,
    pAtoms=Reap[
      MapThread[
        {
          #3,
          ApplyToWrapped[
            pos\[Function](
            (s\[Function]If[OptionValue[Molecule,Tooltip],Tooltip[s,#2],s])@
             Sphere[Sow@PadRight[pos,3],ApplyScale[If[spaceFilling,5,1]$ElementRadii@#2,OptionValue[Molecule,"AtomRadius"]]]
            ),
            #1,
            _List
          ]
        }&,
        {Normal[atoms][[All,2]],elements,styles}
      ]
    ],
    coords=First[pAtoms[[2]],{}],
    pBonds=Reap@With[
      {check=IntegerQ@#&&1<=#<=Length@coords&},
      ApplyToWrapped[
        Function[{b,s},
          If[MatchQ[#,Bond[x_?check,y_?check][_]/;x!=y],{Sow@#,Hold@s},{}]&@ToBond@b,
          {HoldRest}
        ],
        #,
        s_?(FirstHead@ToBond[#]===Bond&),
        _Style
      ]&/@If[
        MatrixQ@bonds,
        AdjacencyToBonds@bonds,
        bonds/.None->{}
      ]
    ],
    bondMap=Cases[First[pBonds[[2]],{}],Bond[#,p_][_]:>p]&/@Range@Length@atoms
  },
  {
    If[spaceFilling,Nothing,Specularity[White,100]],
    EdgeForm@None,
    CapForm@None,
    AbsoluteThickness@3,
    OptionValue[Molecule,BaseStyle],
    First@pAtoms,
    First@pBonds/.
     {Bond[p1_,p2_][t_],Hold@s_}:>With[
       {r=DrawBond[
        {
          coords[[#]],
          Directive[
            #,
            StyleHold@@Unevaluated@s
          ]&/@styles[[#]]
        }\[Transpose]&[{p1,p2}],
        t,
        coords[[#]]&/@bondMap[[{p1,p2}]],
        FilterRules[{o},Options[DrawBond]]
      ]},
      r/;True
      ]//.ContextualRule[Style[_,s___]:>s,StyleHold]/.StyleHold[s___]:>s
  }//.ContextualRule[Directive[d___]:>d,Directive]/.ContextualRule[Directive[d_]:>d,_]
]


End[]
