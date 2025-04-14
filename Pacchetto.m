BeginPackage["Pacchetto`"]

aUI::usage = "aUI[] mostra:
- una matrice binaria cliccabile;
- slider RGB che aggiornano una matrice RGB;
- visualizzazione della matrice RGB sia come valori che come colori."


bUi::usage = "bUi[] fornisce esercizi interattivi per comprendere le trasformazioni lineari:
             rotazione, riflessione, scalatura e shear."


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

      (* SLIDERS CON VALORI A DESTRA *)
      Column[{
        Style["Regola i canali RGB:", Bold],

        Row[{
          Style["R", Bold, Red], 
          Slider[
            Dynamic[r, (r = Round[#]) &],
            {0, 255},
            ContinuousAction -> False,
            ImageSize -> 200
          ],
          Spacer[10],
          Dynamic[Style[r, Red, Bold]]
        }],

        Row[{
          Style["G", Bold, Darker[Green]], 
          Slider[
            Dynamic[g, (g = Round[#]) &],
            {0, 255},
            ContinuousAction -> False,
            ImageSize -> 200
          ],
          Spacer[10],
          Dynamic[Style[g, Darker[Green], Bold]]
        }],

        Row[{
          Style["B", Bold, Blue], 
          Slider[
            Dynamic[b, (b = Round[#]) &],
            {0, 255},
            ContinuousAction -> False,
            ImageSize -> 200
          ],
          Spacer[10],
          Dynamic[Style[b, Blue, Bold]]
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

(*_______________________________________________________________________________________________*)
(* Funzione di visualizzazione di un quadrato con freccia centrale *)
quadratoConFreccia[pts_] := Graphics[
  {
    Thick, Line[pts[[1 ;; 5]]],  (* contorno quadrato *)
    Red, Arrow[{pts[[6]], pts[[7]]}]  (* freccia *)
  },
  PlotRange -> {{-3, 3}, {-3, 3}},
  Axes -> True,
  AxesOrigin -> {0, 0},
  AspectRatio -> 1,
  ImageSize -> Medium
]

(* Punti iniziali: quadrato + freccia verso l’alto *)
p0 := {{0, 0}, {1, 0}, {1, 1}, {0, 1}, {0, 0}, {0.5, 0.5}, {0.5, 1.2}}

(* Funzione che applica una matrice ai punti *)
trasforma[mat_] := (mat.# & /@ p0)

(* Funzione principale *)
bUi[] := Column[{

  Style["1. Rotazione", Bold, 16],
  DynamicModule[{θ = 0},
    Column[{
      Slider[Dynamic[θ], {0, 2 Pi}, Appearance -> "Labeled"],
      Dynamic[quadratoConFreccia[trasforma[{{Cos[θ], -Sin[θ]}, {Sin[θ], Cos[θ]}}]]]
    }]
  ],

  Divider[],

  Style["2. Riflessione", Bold, 16],
  DynamicModule[{mat = IdentityMatrix[2]},
    Column[{
      Row[{
        Button["Riflessione X", mat = {{1, 0}, {0, -1}}],
        Button["Riflessione Y", mat = {{-1, 0}, {0, 1}}],
        Button["Riflessione diagonale y=x", mat = {{0, 1}, {1, 0}}]
      }],
      Dynamic[quadratoConFreccia[trasforma[mat]]]
    }]
  ],

  Divider[],

  Style["3. Scalatura", Bold, 16],
  DynamicModule[{sx = 1, sy = 1},
    Column[{
      Row[{"Scala X: ", Slider[Dynamic[sx], {0.1, 3}, Appearance -> "Labeled"]}],
      Row[{"Scala Y: ", Slider[Dynamic[sy], {0.1, 3}, Appearance -> "Labeled"]}],
      Dynamic[quadratoConFreccia[trasforma[{{sx, 0}, {0, sy}}]]]
    }]
  ],

  Divider[],

  Style["4. Shear (Deformazione)", Bold, 16],
  DynamicModule[{k = 0},
    Column[{
      Row[{"k (taglio orizzontale): ", Slider[Dynamic[k], {-2, 2}, Appearance -> "Labeled"]}],
      Dynamic[quadratoConFreccia[trasforma[{{1, k}, {0, 1}}]]]
    }]
  ]
}]








End[]
EndPackage[]
