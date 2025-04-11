BeginPackage["Pacchetto`"]

(* USAGE MESSAGE *)
aUI::usage = "aUI[] mostra un'interfaccia interattiva composta da:
- una scacchiera 8x8 (ArrayPlot) che rappresenta visivamente una matrice con valori 0 (nero) e 255 (bianco);
- una griglia di bottoni cliccabili che permettono di modificare ogni cella, passando da 0 a 255 e viceversa.";

Begin["`Private`"]

aUI[] := DynamicModule[
  {
   (* Matrice inizializzata con 255 (bianco) *)
   mat = ConstantArray[255, {8, 8}]
  },

  Row[{

    (* Funzione per cambiare il valore della cella *)Column[{
      Text["Clicca su una cella per passare da 0 a 255 e viceversa:"],
      Grid[
        Table[
          With[{i = i, j = j},
            Button[
              Dynamic[mat[[i, j]]],
              mat[[i, j]] = If[mat[[i, j]] == 0, 255, 0],
              Appearance -> None,
              BaseStyle -> {FontSize -> 14, FontWeight -> Bold},
              Background -> Dynamic[
                If[mat[[i, j]] == 0, Gray, LightGray]
              ]
            ]
          ],
          {i, 8}, {j, 8}
        ],
        Frame -> All
      ]
    }],
    Spacer[20],



    (* Scacchiera a sinistra *)
    Dynamic[
      ArrayPlot[
        mat,
        ColorFunction -> (If[# == 0, Black, White] &),
        PlotRange -> {0, 255},
        PlotRangePadding -> None,
        Mesh -> All,
        MeshStyle -> Black,
        Frame -> True,
        FrameTicks -> None,
        AspectRatio -> 1,
        ImageSize -> 240
      ]
    ]
  }]
]

End[]

EndPackage[]
