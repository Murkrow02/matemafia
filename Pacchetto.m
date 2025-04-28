BeginPackage["Pacchetto`"]




aUI::usage = "aUI represents the user interface component of the application. It is used to manage and display the graphical interface elements.";
bUI::usage = "bUI represents the user interface component of the application. It is used to manage and display the graphical interface elements.";
cUI::usage = "cUI represents the user interface component of the application. It is used to manage and display the graphical interface elements.";




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

rotazione[] := Module[{},
  Manipulate[
   Module[{img, rotata, matrice, grafico},
    
    img = ExampleData[{"TestImage", "House"}];
    rotata = ImageRotate[img, angolo Degree, Background -> White];
    
    (* Matrice di rotazione *)
    matrice = Round[N[{
      {Cos[angolo Degree], -Sin[angolo Degree]},
      {Sin[angolo Degree],  Cos[angolo Degree]}
    }], 0.0001];
    
    (* Grafico della funzione seno con punto rosso *)

    grafico = Plot[
      Sin[x Degree],
      {x, 0, 360},
      PlotStyle -> Red,
      Epilog -> {
        Red, PointSize[Large],
        Point[{angolo, Sin[angolo Degree]}]
        },
      AxesLabel -> {"Angolo (\[Degree])", "sin(angolo)"},
      PlotRange -> {{0, 360}, {-1.1, 1.1}},
      ImageSize -> 300
      ];
    
    Grid[{
      {
       rotata,
       Column[{
        MatrixForm[matrice],
         grafico
         }, Spacings -> 2]
       }
      }, Spacings -> {2, 2}]
    ],
   
   {{angolo, 0, "Angolo (gradi)"}, 
    0, 360, 1, 
    Appearance -> "Labeled"},
   
   Delimiter,
   Row[{
     Button["0\[Degree]", angolo = 0],
     Button["30\[Degree]", angolo = 30],
     Button["45\[Degree]", angolo = 45],
     Button["60\[Degree]", angolo = 60],
     Button["90\[Degree]", angolo = 90],
     Button["180\[Degree]", angolo = 180],
     Button["270\[Degree]", angolo = 270],
     Button["360\[Degree]", angolo = 360]
     }, Spacer[5]]
   ]
 ]

riflessione[] := Module[{},

 Manipulate[
  Module[{img, riflessa, matrice},
   img = ExampleData[{"TestImage", "House"}];
   {riflessa, matrice} =
    If[asse == "X",
     {ImageReflect[img, Top], {{1, 0}, {0, -1}}},
     {ImageReflect[img, Left], {{-1, 0}, {0, 1}}}
     ];
   Grid[{
     {riflessa, MatrixForm[matrice]}
     }, Spacings -> {2, 2}]
   ],
  {{asse, "X", "Asse di riflessione"}, {"X", "Y"}}
  ]
 ]


scala[] := Module[{},
  Manipulate[
   Module[{img, scalata, matrice, det, unitSquare, transformedSquare, 
     warning, plotRange},
    
    (* Original image with dynamic padding to prevent clipping *)
    img = ExampleData[{"TestImage", "House"}];
    
    (* Apply scaling *)
    scalata = ImageResize[img, Scaled[{sx, sy}]];
    
    (* Transformation matrix and determinant *)
    matrice = {{sx, 0}, {0, sy}};
    det = sx * sy;
    
    (* Visualize the transformation on a unit square *)
    unitSquare = Polygon[{{0, 0}, {1, 0}, {1, 1}, {0, 1}}];
    transformedSquare = GeometricTransformation[unitSquare, ScalingTransform[{sx, sy}]];
    
    (* Determine plot range based on scaling *)
    plotRange = {{-0.5, Max[1.5, sx + 0.5]}, {-0.5, Max[1.5, sy + 0.5]}};
    
    (* Warnings *)
    warning = Which[
      det == 0, Style["Il determinante e' ZERO (collassato a una linea/punto)!", Red, Bold],
      det < 0.1, Style["Determinante quasi zero (distorsione severa)!", Orange, Bold],
      True, ""
    ];
    
    (* Grid layout *)
    Grid[{
      {scalata, 
       Column[{
         Style["Matrice di Scala", Bold, 14],
         MatrixForm[matrice],
         Spacer[10],
         Style["Determinante: " <> ToString[det], Bold, Darker[Green]],
         warning,
         Spacer[10],
         Graphics[{
           {EdgeForm[Black], LightBlue, unitSquare},
          {EdgeForm[{Thick, Red}], Opacity[0.5], Red, transformedSquare},
           (* Add dimension labels *)
           Text[Style["1", 12], {0.5, -0.1}],
           Text[Style["1", 12], {-0.1, 0.5}],
           Text[Style[ToString[sx], 12, Red], {sx/2, -0.1}],
           Text[Style[ToString[sy], 12, Red], {-0.1, sy/2}],
           (* Add axis labels *)
           Text[Style["X", 14], {plotRange[[1, 2]] - 0.2, -0.3}],
           Text[Style["Y", 14], {-0.3, plotRange[[2, 2]] - 0.2}],
           (* Add grid lines *)
           Gray, Dashed,
           Line[{{0, sy}, {sx, sy}}], 
           Line[{{sx, 0}, {sx, sy}}],
           Axes -> True,
           AxesStyle -> Thick,
           PlotLabel -> Style["Unit Square → Transformed", 14],
           ImageSize -> 300,
           PlotRange -> plotRange
         }]
       }, Alignment -> Center]}
    }, Spacings -> 3, Alignment -> Center]
   ],
   
   (* Controls *)
   {{sx, 1, "Scala X"}, 0.0, 1.5, 0.1, Appearance -> "Labeled"},
   {{sy, 1, "Scala Y"}, 0.0, 1.5, 0.1, Appearance -> "Labeled"},
   
   (* Quick-set buttons *)
   Delimiter,
   Row[{
      Button["1:1", {sx = 1, sy = 1}],
      Spacer[5],
      Button["2:1", {sx = 1, sy = 0.5}],
      Spacer[5],
      Button["1:2", {sx = 0.5, sy = 1}]
    }],
   ControlPlacement -> Top,
   Paneled -> True,
   FrameMargins -> 10]
]
    

bUI[] := Column[{
  Style["Rotazione", Bold, 14],
  rotazione[],
  Style["Riflessione", Bold, 14],
  riflessione[],
  Style["Scala", Bold, 14],
  scala[]
  }]

cUI[] := Column[{
  Style["Esercizio 1: Sfocatura con Kernel", Bold, 16],
  
  Text[
   "Questo esercizio illustra l'effetto di un kernel di sfocatura su un'immagine. " <>
    "Un kernel e una piccola matrice che viene fatta scorrere su ogni pixel dell'immagine. " <>
    "Il nuovo valore di ogni pixel e calcolato come la media dei valori dei pixel vicini, pesati dai valori del kernel. " <>
    "Qui, utilizziamo un kernel di media uniforme, dove tutti i pesi sono uguali a 1/(dimensione del kernel)^2."
   ],
  
  DynamicModule[{kernelSize = 3, locatorPosition = {50, 50}, 
    img = ExampleData[{"TestImage", "House"}]},
   Column[{
    Slider[Dynamic[kernelSize], {3, 9, 2}, Appearance -> "Labeled", 
     ImageSize -> Full],
    
    DynamicModule[{imageDimensions = ImageDimensions[img]},
     Dynamic[
      Module[{kSize = kernelSize, kernel, locX, locY, imageData, 
        neighborhood, convolvedValue, padding, blurredImg},
       kernel = ConstantArray[1/kSize^2, {kSize, kSize}];
       locX = Round[locatorPosition[[1]]];
       locY = Round[imageDimensions[[2]] - locatorPosition[[2]] + 1];
       imageData = ImageData[img];
       padding = Floor[kSize/2];
       blurredImg = ImageConvolve[img, kernel];
       
       neighborhood = 
        Table[imageData[[Clip[locY + i - padding, {1, imageDimensions[[2]]}], 
           Clip[locX + j - padding, {1, imageDimensions[[1]]}]]], 
         {i, 1, kSize}, {j, 1, kSize}];
       
       convolvedValue = Sum[neighborhood[[i, j]] * kernel[[i, j]], 
         {i, 1, kSize}, {j, 1, kSize}];
       
       Column[{
        Row[{
         Column[{
          Style["Immagine Originale", Bold],
          LocatorPane[Dynamic[locatorPosition], 
           Dynamic[
            Show[img, 
             Graphics[{Red, Thickness[0.01], 
               Rectangle[{locatorPosition[[1]] - kSize/2, 
                 locatorPosition[[2]] - kSize/2}, 
                {locatorPosition[[1]] + kSize/2, 
                 locatorPosition[[2]] + kSize/2}]}]]], 
           LocatorShape -> Graphics[{Circle[{0, 0}, 5]}], 
           ImageSize -> 300]
          }],
         Spacer[20],
         Column[{
          Style["Immagine Sfocata", Bold],
          Image[blurredImg, ImageSize -> 300]
          }],
         Spacer[20],
         Column[{
          Style["Kernel (Dimensione: " <> ToString[kSize] <> ")", Bold],
          MatrixForm[kernel]
          }]
         }, Alignment -> Top],
        
        Style["Dettagli Locali (Intorno al Locatore)", Bold],
        Row[{Style["Neighborhood:", Bold], 
          Image[neighborhood, ImageSize -> Scaled[0.5]]}],
        Row[{Style["Valore Pixel Originale (centro): ", Bold], 
          PaddedForm[imageData[[locY, locX]], {3, 3}]}],
        Row[{Style["Valore Pixel Convoluto: ", Bold], 
          PaddedForm[convolvedValue, {3, 3}]}]
        }]
       ]
      ]
     ]
    }]
   ]
  }]




esUI[] := Module[
  {
    houseCoords, targetCoords, transformedCoords,
    a11 = 1, a12 = 0, a21 = 0, a22 = 1, 
    userMatrix, resultGraphics, feedback, correctMatrix, seed = 1234
  },

  SeedRandom[seed];

  (* House di esempio *)
  houseCoords = {{0, 0}, {1, 0}, {1, 1}, {0, 1}, {0, 0}, {0.5, 1.5}, {1, 1}};
  
  (* Trasformazione da indovinare *)
  correctMatrix = {{0, -1}, {1, 0}}; (* es: rotazione 90\[Degree] anti-oraria *)
  
  targetCoords = (correctMatrix.# & /@ houseCoords);
  
  feedback = "";

  Column[{
    Row[{
      Graphics[{Thick, Blue, Line[houseCoords]}, PlotRange -> {{-2, 2}, {-2, 2}}, 
        ImageSize -> 250, Axes -> True, AxesOrigin -> {0, 0}], 
      Spacer[20],
      Graphics[{Thick, Green, Line[targetCoords]}, PlotRange -> {{-2, 2}, {-2, 2}}, 
        ImageSize -> 250, Axes -> True, AxesOrigin -> {0, 0}]
    }],
    
    "Inserisci la matrice di trasformazione (2x2):",
    
    Grid[{
      {
        InputField[Dynamic[a11], Number, FieldSize -> 4],
        InputField[Dynamic[a12], Number, FieldSize -> 4]
      },
      {
        InputField[Dynamic[a21], Number, FieldSize -> 4],
        InputField[Dynamic[a22], Number, FieldSize -> 4]
      }
    }, Spacings -> {2, 2}],
    
    Button["Applica trasformazione",
      (
        userMatrix = {{a11, a12}, {a21, a22}};
        transformedCoords = (userMatrix.# & /@ houseCoords);
        If[
          SameQ[Round[transformedCoords, 0.01], Round[targetCoords, 0.01]],
          feedback = Style["✅ Corretto!", Darker[Green], 16],
          feedback = Style["❌ Sbagliato. Riprova!", Red, 16]
        ];
      ),
      ImageSize -> Large
    ],
    
    Dynamic[feedback],
    
    Dynamic[
      Graphics[{Thick, Red, Line[transformedCoords]}, PlotRange -> {{-2, 2}, {-2, 2}}, 
        ImageSize -> 250, Axes -> True, AxesOrigin -> {0, 0}]
    ]
  }]
]

End[]
EndPackage[]
