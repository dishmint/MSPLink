BeginPackage["FaizonZaman`MSPLink`Utilities`"]

BuildMaxPatcher::usage = "BuildMaxPatcher[assoc] builds a symbolic max patcher from an association."

Begin["`Private`"]

MaxPatcherJSONToAssociation[json_]:= MapAt[Association, json, Position[json, {__Rule}]]

ProcessMaxPatcherData[data: KeyValuePattern[{"boxes"->_, "lines"->_}]]:= Block[
    {
        boxes = data["boxes"],
        lines = data["lines"]
        },
    boxes //= iProcessMaxPatcherData["boxes", #]&;
    lines //= iProcessMaxPatcherData["lines", boxes, #]&;
    <| "boxes" -> boxes, "lines" -> lines |>
    ]
(* ProcessMaxPatcherData[dataKey_String, data_]:= dataKey -> iProcessMaxPatcherData[dataKey, data] *)

iProcessMaxPatcherData["boxes", data_]:= Map[FaizonZaman`MSPLink`MaxObject, Lookup[data, "box"]]

processPatchLine[line : KeyValuePattern[{"destination" -> d_, "order" -> o_, "source" -> s_}]] := DirectedEdge[s, d, o]
processPatchLine[line : KeyValuePattern[{"destination" -> d_, "source" -> s_}]] := DirectedEdge[s, d]

FaizonZaman`MSPLink`GetMaxObject[id_String][boxes_List]:= FaizonZaman`MSPLink`GetMaxObject[boxes, id]
FaizonZaman`MSPLink`GetMaxObject[boxes_List, id_String]:= SelectFirst[boxes, MatchQ[#["ID"], id]&]

iProcessMaxPatcherData["lines", boxes_, data_]:= Block[
    {res},
    res = data;
    res //= Lookup["patchline"];
    res //= Map[processPatchLine];
    res //= Replace[
        #,
        {
            DirectedEdge[s_List,d_List,o_] :> DirectedEdge[FaizonZaman`MSPLink`GetMaxObject[boxes, First[s]], FaizonZaman`MSPLink`GetMaxObject[boxes, First[d]], o],
            DirectedEdge[s_List,d_List] :> DirectedEdge[FaizonZaman`MSPLink`GetMaxObject[boxes, First[s]], FaizonZaman`MSPLink`GetMaxObject[boxes, First[d]]]
            },
        Infinity
        ]&
    ]

GetMaxPatcherData[patcherAssoc: KeyValuePattern[{"patcher" -> _}]]:= Block[
    {res},
    res = patcherAssoc // Lookup["patcher"];
    res //= KeySelect[MatchQ["boxes" | "lines"]];
    res //= ProcessMaxPatcherData
    ]
GetMaxPatcherMetaInformation[patcherAssoc: KeyValuePattern[{"patcher" -> _}]]:= patcherAssoc // Lookup["patcher"] // KeySelect[Not@*MatchQ["boxes" | "lines"]]

Default[BuildMaxPatcher, 2] = None;
(* TODO: use ImportedMaxPatcherAssociationQ to check the arguments here *)
BuildMaxPatcher[patcherJSON: KeyValuePattern[{"patcher" -> _}], patcherName_.] := Block[
    {
        patcherAssociation,
        data,
        metaInformation
        },
    patcherAssociation = MaxPatcherJSONToAssociation[patcherJSON];

    metaInformation = Append[GetMaxPatcherMetaInformation[patcherAssociation], <| "PatcherName" -> patcherName |>];
    data = GetMaxPatcherData[patcherAssociation];
    
    FaizonZaman`MSPLink`MaxPatcher[Append[data, <| MetaInformation -> metaInformation |>]]
    ]

(* TODO: Fix cutoff disks *)
MaxObjectShapeFunction[{xc_, yc_}, name_, {w_, h_}] := Block[
    {xmin = xc - w, xmax = xc + w, ymin = yc - h, ymax = yc + h},
    Inset[
        Tooltip[
            Graphics[{Gray,EdgeForm[Black], Disk[{0,0}, {w, h} 0.5]}, ImageSize -> Full], name], {xc,yc}, Automatic, Dynamic[0.0225 CurrentValue["FontMWidth"]/AbsoluteCurrentValue[Magnification]
            ],
        BaseStyle -> {Directive[Full], ImagePadding -> (Max[w,h]+ 0.5)}
        ]
    ];

(* TODO: Better rendering of object rectangles *)
(* FaizonZaman`MSPLink`MaxObjectShapeFunction[{xc_, yc_}, name_, {w_, h_}] := Block[
    {xmin = xc - w, xmax = xc + w, ymin = yc - h, ymax = yc + h},
    Inset[Tooltip[Graphics[{Directive[White, EdgeForm[Black]], name["Rectangle"]}], name], {xc,yc}, Automatic, Dynamic[0.0225 CurrentValue["FontMWidth"]/AbsoluteCurrentValue[Magnification]]]
    ] *)

Options[FaizonZaman`MSPLink`MaxPatcherGraph] = {
    VertexShapeFunction -> Automatic,
    EdgeShapeFunction -> "ShortUnfilledArrow",
    ImageSize -> Medium
    } ~Join~FilterRules[Options[Graph], Except[VertexShapeFunction | EdgeShapeFunction | ImageSize]];
FaizonZaman`MSPLink`MaxPatcherGraph[edges:{__DirectedEdge}, opts: OptionsPattern[FaizonZaman`MSPLink`MaxPatcherGraph]]:= With[
    {vsf = Replace[OptionValue[FaizonZaman`MSPLink`MaxPatcherGraph, VertexShapeFunction], Automatic -> MaxObjectShapeFunction]},
    Graph[edges, VertexShapeFunction -> vsf, EdgeShapeFunction -> OptionValue[EdgeShapeFunction], ImageSize -> OptionValue[ImageSize], opts]
    ]
FaizonZaman`MSPLink`MaxPatcherGraph[mp_FaizonZaman`MSPLink`MaxPatcher, opts: OptionsPattern[FaizonZaman`MSPLink`MaxPatcherGraph]]:= With[
    {vsf = Replace[OptionValue[VertexShapeFunction], Automatic -> MaxObjectShapeFunction]},
    Graph[mp["Lines"], VertexShapeFunction -> vsf, EdgeShapeFunction -> OptionValue[EdgeShapeFunction], ImageSize -> OptionValue[ImageSize], opts]
    ]

End[]
EndPackage[]

