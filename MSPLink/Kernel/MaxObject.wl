BeginPackage["FaizonZaman`MSPLink`MaxObject`"]

Begin["`Private`"]
Needs["PacletTools`"];

(* ::Section:: *)
(*MaxObject*)

$MaxObjectImage = FileNameJoin[{DirectoryName[$InputFileName, 2], "Assets", "max_object.png"}] // Import;
$MaxObjectIcon = Graphics[{$MaxObjectImage}, ImageSize -> Dynamic[{Automatic, 3.5 CurrentValue["FontCapHeight"]/AbsoluteCurrentValue[Magnification]}]];

(* TODO: #11 Create default MetaInformation for MaxObjects *)
$DefaultMaxObjectMetaInformation = {};

keyrules = {"id" -> "ID", "maxclass" -> "MaxClass", "numinlets" -> "Inlets", "numoutlets" -> "Outlets", "outlettype" -> "OutletType", "patching_rect" -> "Rectangle", "text" -> "Text"};
inversekeyrules = Map[Reverse, keyrules];

MaxObjectInfoLookup[asc_?MaxObjectAscQ,key_String] := With[
    {res = Lookup[asc, key]}, 
    If[
        MissingQ[res], Nothing,
        BoxForm`SummaryItem[ {(key /. keyrules) <> ": ", res}]
        ]
    ]

FaizonZaman`MSPLink`MaxObject /: MakeBoxes[obj : FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ], form : (StandardForm | TraditionalForm)] := 
    Module[
        {above, below},
        above = {
            {
                MaxObjectInfoLookup[asc, "id"],
                MaxObjectInfoLookup[asc, "maxclass"]
                },
            {
                MaxObjectInfoLookup[asc, "numinlets"],
                MaxObjectInfoLookup[asc, "numoutlets"]
                }
            };
        below = {
            MaxObjectInfoLookup[asc, "text"],
            MaxObjectInfoLookup[asc, "outlettype"]
        };
        BoxForm`ArrangeSummaryBox[
            FaizonZaman`MSPLink`MaxObject,(*head*)
            obj,(*interpretation*)
            $MaxObjectIcon,(*icon, use None if not needed*)(*above and below must be in a format suitable for Grid or Column*)
            above,(*always shown content*)
            below,(*expandable content*)
            form,
            "Interpretable" -> Automatic
            ]
        ];
(* Basic keys that should always exist *)
MaxObjectAscQ[asc_?AssociationQ] := AllTrue[{"id", "maxclass", "numinlets", "numoutlets", "patching_rect"}, KeyExistsQ[asc, #] &]
MaxObjectAscQ[_] = False;

FaizonZaman`MSPLink`MaxObjectQ[FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]] := True;
FaizonZaman`MSPLink`MaxObjectQ[FaizonZaman`MSPLink`MaxObject[_]] := False;

MaxRectangle[{x_,y_,w_,h_}] := Rectangle[{x, -y},{x + (w .5),-y+(h 0.5)}];

FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["ID"] := asc["id"]
FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["MaxClass"] := asc["maxclass"]
FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["Inlets"] := asc["numinlets"]
FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["Outlets"] := asc["numoutlets"]
FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["OutletType"] := asc["outlettype"]
FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["PatchingRectangle"] := asc["patching_rect"]
FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["Rectangle"] := MaxRectangle[asc["patching_rect"]]
FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["Text"] := asc["text"]
FaizonZaman`MSPLink`MaxObject[asc_?MaxObjectAscQ]["Properties"] := {"ID", "MaxClass", "Inlets", "Outlets", "OutletType", "Rectangle", "Text"}

FaizonZaman`MSPLink`MaxObjectLookup[mo:FaizonZaman`MSPLink`MaxObject[_?MaxObjectAscQ], key_String] := mo[key]
FaizonZaman`MSPLink`MaxObjectLookup[mos:{FaizonZaman`MSPLink`MaxObject[_?MaxObjectAscQ]..}, key_String] := FaizonZaman`MSPLink`MaxObjectLookup[key] /@ mos

FaizonZaman`MSPLink`MaxObjectLookup[key_String][mo:FaizonZaman`MSPLink`MaxObject[_?MaxObjectAscQ]] := FaizonZaman`MSPLink`MaxObjectLookup[mo, key]
FaizonZaman`MSPLink`MaxObjectLookup[key_String][mos:{FaizonZaman`MSPLink`MaxObject[_?MaxObjectAscQ] ..}] := FaizonZaman`MSPLink`MaxObjectLookup[mos, key]

FaizonZaman`MSPLink`MaxObject["Properties"] = {"ID", "MaxClass", "Inlets", "Outlets", "OutletType", "Rectangle", "Text"};
End[]

EndPackage[]