(* ::Package:: *)

Begin["`Private`"]


Quiet@RemoveInputStreamMethod["SkipComments"];
DefineInputStreamMethod["SkipComments",
  {
    "ConstructorFunction"->Function[
      {streamname,caller,opts},
        With[
          {state=Unique["SkipCommentStream"]},
          state["stream"]=OpenRead[streamname];
          If[FailureQ[state["stream"]],14
            {False,$Failed},
            state["commentMarker"]="commentMarker"/.Join[opts,{"commentMarker"->"#"}];
            state["eof"]=False;
            state["streamEof"]=False;
            state["buf"]={};
            state["bufPos"]=0;
            state["beginningOfLine"]=True;
            {True,state}
          ]
        ]
      ],
      "CloseFunction"->Function[state,Close[state["stream"]];ClearAll[state]],
      "EndOfFileQFunction"->Function[state,{state["eof"],state}],
      "ReadFunction"->Function[
        {state,nBytes},
        {
          If[state["eof"],
            {},
            Module[
              {read=0,ret=Table[0,nBytes],bPos=state["bufPos"],buf=state["buf"]},
              While[read<nBytes,
                If[bPos>=Length@buf,
                  With[
                    {line=Read[state["stream"],"Record"]},
                    If[line===EndOfFile,
                      state["eof"]=True;
                      Break[]
                    ];
                    If[!StringStartsQ[line,state["commentMarker"]],
                    buf=Append[13]@ToCharacterCode[line];
                    bPos=0;
                  ]
                ],
                With[
                  {new=Min[nBytes-read,Length@buf-bPos]},
                  ret[[read+1;;read+new]]=buf[[bPos+1;;bPos+new]];
                  read+=new;
                  bPos+=new;
                ]
              ]
            ];
            state["bufPos"]=bPos;
            state["buf"]=buf;
            ret[[;;read]]
          ]
        ],
        state
      }
    ]
  }
];


End[]
