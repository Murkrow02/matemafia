BeginPackage["Pacchetto`"]

aUI::usage = "aUI[] mostra:
- una matrice binaria cliccabile;
- slider RGB che aggiornano una matrice RGB;
- visualizzazione della matrice RGB sia come valori che come colori.";

Begin["`Private`"]

aUI[] := DynamicModule[
  {
   mat = ConstantArray[255, {8, 8}],
   rgbMat = ConstantArray[{255, 255, 255}, {8, 8}],
   r = 255, g = 255, b = 255
  },

  Column[{

    (* RIGA 1: matrice 0/255 + ArrayPlot *)
    Row[{

      Column[{
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

    }], (* Fine prima riga *)

    Spacer[30],

    (* RIGA 2: Slider RGB + Matrice RGB + ArrayPlot RGB *)
    Row[{

      (* SLIDERS *)
      Column[{
        Style["Regola i canali RGB:", Bold],
        Slider[
          Dynamic[r, (r = #) &],
          {0, 255},
          Appearance -> "Labeled",
          ContinuousAction -> False,
          ImageSize -> 200
        ],
        Slider[
          Dynamic[g, (g = #) &],
          {0, 255},
          Appearance -> "Labeled",
          ContinuousAction -> False,
          ImageSize -> 200
        ],
        Slider[
          Dynamic[b, (b = #) &],
          {0, 255},
          Appearance -> "Labeled",
          ContinuousAction -> False,
          ImageSize -> 200
        ],
        Button["Applica RGB a tutta la matrice",
          rgbMat = ConstantArray[{r, g, b}, {8, 8}]
        ]
      }],

      Spacer[20],

      (* RGB VALUES GRID (readonly, no wrapping) *)
      Dynamic[
        Grid[
          Table[
            With[{i = i, j = j},
              Style[
                StringJoin@Riffle[ToString /@ IntegerPart /@ rgbMat[[i, j]], ", "],
                FontFamily -> "Courier",
                FontSize -> 10,
                FontWeight -> Medium,
                FixedWidth -> 40
              ]
            ],
            {i, 8}, {j, 8}
          ],
          Frame -> All,
          Alignment -> Center,
          ColumnWidths -> 7,  (* Set fixed column width for all columns *)
          RowHeights -> 30,    (* Set fixed row height *)
          ItemSize -> {1, 1}   (* Prevent resizing based on content *)
        ]
      ],

      Spacer[20],

      (* COLOR MATRIX *)
      Dynamic[
        ArrayPlot[
          Map[
            RGBColor @@ (#/255) &,
            rgbMat,
            {2}
          ],
          Mesh -> All,
          MeshStyle -> Black,
          Frame -> True,
          FrameTicks -> None,
          AspectRatio -> 1,
          ImageSize -> 240
        ]
      ]

    }] (* Fine seconda riga *)

  }] (* Fine Column *)
]

End[]

EndPackage[]