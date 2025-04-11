BeginPackage["Pacchetto`"]

aUI::usage = "aUI[] mostra:
- una matrice binaria cliccabile;
- slider RGB che aggiornano una matrice RGB;
- visualizzazione della matrice RGB sia come valori che come colori."

Begin["`Private`"]

aUI[] := DynamicModule[
  {
   mat = ConstantArray[255, {5, 5}],
   rgbMat = ConstantArray[{255, 255, 255}, {5, 5}],
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
                Background -> Dynamic[If[mat[[i, j]] == 0, Gray, LightGray]],
                ImageSize -> {40, 40}
              ]
            ],
            {i, 5}, {j, 5}
          ],
          Frame -> All,
          Spacings -> {0, 0}
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
          ImageSize -> 200
        ]
      ]
    }],

    Spacer[30],

    (* RIGA 2: Matrice RGB + ArrayPlot RGB + SLIDER A DESTRA *)
    Row[{

      (* RGB VALUES GRID *)
      Dynamic[
        Grid[
          Table[
            With[{val = rgbMat[[i, j]]},
              Pane[
                Column[
                  Style[#, FontFamily -> "Courier", FontSize -> 10, FontWeight -> Medium] & /@ val,
                  Alignment -> Center,
                  Spacings -> 0.5
                ],
                {50, 50},
                Alignment -> Center
              ]
            ],
            {i, 5}, {j, 5}
          ],
          Frame -> All,
          Spacings -> {0, 0},
          Alignment -> Center,
          ItemSize -> All
        ]
      ],

      Spacer[20],

      (* COLOR MATRIX *)
      Dynamic[
        ArrayPlot[
          Map[RGBColor @@ (#/255) &, rgbMat, {2}],
          Mesh -> All,
          MeshStyle -> Black,
          Frame -> True,
          FrameTicks -> None,
          AspectRatio -> 1,
          ImageSize -> 200
        ]
      ],

      Spacer[20],

      (* SLIDERS A DESTRA SENZA MODIFICABILI *)
      Column[{
        Style["Regola i canali RGB:", Bold],

        Row[{
          Style["R", Bold, Red], 
          Slider[
            Dynamic[r, (r = Round[#]) &],
            {0, 255},
            ContinuousAction -> False,
            ImageSize -> 200
          ]
        }],

        Row[{
          Style["G", Bold, Darker[Green]], 
          Slider[
            Dynamic[g, (g = Round[#]) &],
            {0, 255},
            ContinuousAction -> False,
            ImageSize -> 200
          ]
        }],

        Row[{
          Style["B", Bold, Blue], 
          Slider[
            Dynamic[b, (b = Round[#]) &],
            {0, 255},
            ContinuousAction -> False,
            ImageSize -> 200
          ]
        }],

        Spacer[10],

        Button[
          "Applica RGB a tutta la matrice",
          rgbMat = ConstantArray[{Round[r], Round[g], Round[b]}, {5, 5}],
          ImageSize -> 200
        ]
      }]
    }]
  }]
]

End[]
EndPackage[]
