(* ::Package:: *)

Begin["`Private`"]


DeclareSectionAccessor[acc_,{invFormMsg_,noMixItemMsg_,noMixSubMsg_,needSubMsg_,invKeyMsg_},symPat_,keyPat_]:=(
  CheckSectionAssoc[acc][ass_Association]:=With[
    {errKeys=Select[Keys@ass,Not@*MatchQ[keyPat]]},
    Message[MessageName[acc,invKeyMsg],#]&/@errKeys;
    If[Length@errKeys>0,
      False,
      AllTrue[ass,CheckSectionAssoc[acc]]
    ]
  ];
  CheckSectionAssoc[acc][{_List...}]:=True;
  CheckSectionAssoc[acc][item_]:=(Message[MessageName[acc,invFormMsg],item];False);


  acc/:HoldPattern[acc[sym:symPat,cats:(keyPat..)]=newItem:{_List...}|_Association?(CheckSectionAssoc[acc])]:=
    Catch[
      Module[
        {
          path={cats},
          item=acc[sym],
          subItem
        },
        subItem=item;
        Do[
          subItem=Lookup[
            subItem,
            path[[i]],
            item=Insert[item,path[[i]]-><||>,Append[path[[;;i-1]],-1]];<||>
          ];
          If[ListQ@subItem,
            Message[MessageName[acc,noMixSubMsg],path[[i+1]],HoldForm@sym,path[[;;i]]];
            Throw[Null]
          ],
          {i,Length@path-1}
        ];
        If[ListQ@newItem&&AssociationQ@subItem@Last@path,
          Message[MessageName[acc,noMixItemMsg],HoldForm@sym,path];
          Throw[Null]
        ];
        If[AssociationQ@newItem&&ListQ@subItem@Last@path,
          Message[MessageName[acc,noMixSubMsg],Last@path,HoldForm@sym,path];
          Throw[Null]
        ];
        acc[sym]^=Insert[item,Last@path->newItem,If[!MissingQ@subItem@Last@path,path,Append[Most@path,-1]]];
        newItem
      ]
    ];
  acc[sym:symPat,cats:(keyPat..)]:=Quiet@Check[Extract[acc[sym],{cats}],{}];
  HoldPattern[acc[symPat,__]=newItem_]^:=(Message[MessageName[acc,invFormMsg],newItem];newItem);
  acc/:HoldPattern[acc[sym:symPat]=item_Association?(CheckSectionAssoc[acc])]:=(acc[sym]^=item);
  acc/:HoldPattern[acc[sym:symPat]={_List...}]:=Message[MessageName[acc,needSubMsg],HoldForm@sym];
  acc/:HoldPattern[acc[sym:symPat,cats:(keyPat..)]=.]:=(acc[sym,##]=Quiet@KeyDrop[acc[sym,##],Last@{cats}])&@@Most@{cats};
  acc/:HoldPattern[acc[sym:symPat]=.]:=acc[sym]=<||>;
  acc[symPat]:=<||>;
  acc[symPat,__]:={};
)


End[]