BeginPackage["FaizonZaman`MSPLink`Utilities`"]

BuildMaxPatcher::usage = "BuildMaxPatcher[assoc] builds a symbolic max patcher from an association."

Begin["`Private`"]

MaxPatcherJSONToAssociation[json_]:= MapAt[Association, json, Position[json, {__Rule}]]

ProcessMaxPatcherData[dataKey_String, data_]:= dataKey -> iProcessMaxPatcherData[dataKey, data]

iProcessMaxPatcherData["boxes", data_]:= Lookup[data, "box"]

processPatchLine[line : KeyValuePattern[{"destination" -> d_, "order" -> o_, "source" -> s_}]] := DirectedEdge[s, d, o]
processPatchLine[line : KeyValuePattern[{"destination" -> d_, "source" -> s_}]] := DirectedEdge[s, d]

iProcessMaxPatcherData["lines", data_]:= Lookup[data, "patchline"] // Map[processPatchLine]

GetMaxPatcherData[patcherAssoc: KeyValuePattern[{"patcher" -> _}]]:= Block[
    {res},
    res = patcherAssoc // Lookup["patcher"];
    res //= KeySelect[MatchQ["boxes" | "lines"]];
    res //= KeyValueMap[ProcessMaxPatcherData];
    <| res |>
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

End[]
EndPackage[]

