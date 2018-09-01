(* ::Package:: *)

Usage[TransformedTicks]="TransformedTicks[s] represents tick marks with label values scaled by ```s```.
TransformedTicks[func] represents tick marks with label values transformed by applying ```func```.
TransformedTicks[{func,ifunc}] uses the explicitly specified inverse function ```ifunc```.
TransformedTicks[spec,scaling] uses the scaling functions specified by ```scaling```.";


Begin["`Private`"]


TransformedTicks[s_?NumericQ,scaling_|PatternSequence[]][limits__]:=TransformedTicks[{s #&,#/s&},scaling][limits]
TransformedTicks[{func_,ifunc_},scaling_:{Identity,Identity}][limits__]:=Let[
  {
    tLimits=func/@{limits},
    rLimits=Round[tLimits,10.^(Round@Log10[-Subtract@@tLimits]-4)]
  },
  Replace[
    Charting`ScaledTicks[scaling]@@rLimits,
    {x_,lbl_,rest__}:>{ifunc[x/.Thread[rLimits->tLimits]],lbl,rest},
    1
  ]
]
TransformedTicks[func_,scaling_|PatternSequence[]][limits__]:=TransformedTicks[{func,InverseFunction[func]},scaling][limits]


End[]
