BeginPackage["Pacchetto`"]




aUI::usage = "aUI represents the user interface component of the application. It is used to manage and display the graphical interface elements.";
bUI::usage = "bUI represents the user interface component of the application. It is used to manage and display the graphical interface elements.";





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
    matrice = N[{
       {Cos[angolo Degree], -Sin[angolo Degree]},
       {Sin[angolo Degree], Cos[angolo Degree]}
       }];
    
    grafico = Plot[
      Sin[x Degree],
      {x, 0, 360},
      PlotStyle -> Red,
      Epilog -> {
        Red, PointSize[Large],
        Point[{angolo, Sin[angolo Degree]}]
        },
      AxesLabel -> {"Angolo (°)", "sin(angolo)"},
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
     Button["0°", angolo = 0],
     Button["30°", angolo = 30],
     Button["45°", angolo = 45],
     Button["60°", angolo = 60],
     Button["90°", angolo = 90],
     Button["180°", angolo = 180],
     Button["270°", angolo = 270],
     Button["360°", angolo = 360]
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
      det == 0, Style["⚠️ Determinant is ZERO (collapsed to a line/point)!", Red, Bold],
      det < 0.1, Style["⚠️ Near-zero determinant (severe distortion)!", Orange, Bold],
      True, ""
    ];
    
    (* Grid layout *)
    Grid[{
      {scalata, 
       Column[{
         Style["Scaling Matrix", Bold, 14],
         MatrixForm[matrice],
         Spacer[10],
         Style["Determinant: " <> ToString[det], Bold, Darker[Green]],
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
   {{sx, 1, "Scale X"}, 0.0, 1.5, 0.1, Appearance -> "Labeled"},
   {{sy, 1, "Scale Y"}, 0.0, 1.5, 0.1, Appearance -> "Labeled"},
   
   (* Quick-set buttons *)
   Delimiter,
   Row[{
     Button["1:1", {sx = 1, sy = 1}],
     Button["2:1", {sx = 1, sy = 0.5}],
     Button["1:2", {sx = 0.5, sy = 1}],
   }, Spacer[5]],
   
   (* Enlarge the Manipulate window *)
   ControlPlacement -> Top,
   Paneled -> True,
   FrameMargins -> 10  ]
]

bUI[] := Column[{
  Style["Rotazione", Bold, 14],
  rotazione[],
  Style["Riflessione", Bold, 14],
  riflessione[],
  Style["Scala", Bold, 14],
  scala[]
  }]





 

End[]
EndPackage[]
