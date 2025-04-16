BeginPackage["PacchettoTest`"]

es::usage = 
  "es[] mostra un'immagine di esempio e permette di scorrere tra 5 trasformazioni lineari casuali con pulsanti. \
   Può essere chiamata anche come es[seed_Integer] per ripetere una generazione specifica.";

Begin["`Private`"]

(* Funzione per creare una trasformazione casuale con valori interi nella matrice *)
randomTransform[] := Module[{transformTypeChoice, subChoice},
  transformTypeChoice = RandomChoice[{"Rotazione", "Scalatura", "Riflessione"}];
  Switch[transformTypeChoice,
    "Rotazione",
    subChoice = RandomChoice[{
      {"Rotazione 0°",    {{1, 0}, {0, 1}}},
      {"Rotazione 90°",   {{0, -1}, {1, 0}}},
      {"Rotazione 180°",  {{-1, 0}, {0, -1}}},
      {"Rotazione 270°",  {{0, 1}, {-1, 0}}}
    }],
    "Scalatura",
    Module[{sx, sy},
      sx = RandomChoice[{-2, -1, 1, 2}];
      sy = RandomChoice[{-2, -1, 1, 2}];
      subChoice = {
        "Scalatura (" <> ToString[sx] <> ", " <> ToString[sy] <> ")",
        DiagonalMatrix[{sx, sy}]
      };
    ],
    "Riflessione",
    subChoice = RandomChoice[{
      {"Riflessione X",    {{1,  0}, {0, -1}}},
      {"Riflessione Y",    {{-1, 0}, {0,  1}}},
      {"Riflessione Y=X",  {{0,  1}, {1,  0}}},
      {"Riflessione Y=-X", {{0, -1}, {-1, 0}}}
    }]
  ];
  subChoice
];

(* Funzione principale con interfaccia migliorata *)
es[seed_: Automatic] := Module[
  {
    img, dims, center,
    transformations, transformedImgs
  },
  
  If[IntegerQ[seed], SeedRandom[seed], SeedRandom[]];
  
  img = ExampleData[{"TestImage", "House"}];
  dims = ImageDimensions[img];
  center = Mean /@ Transpose[{{1, 1}, dims}];
  
  transformations = Table[randomTransform[], {5}];
  
  transformedImgs = Table[
    Module[{matrix = transformations[[i, 2]], transfFun},
      transfFun = Function[p, center + matrix . (p - center)];
      ImageTransformation[img, transfFun, DataRange -> Full, 
        Resampling -> "Linear"]
    ],
    {i, 5}
  ];
  
  DynamicModule[{index = 1, userMatrix = ConstantArray[0, {2, 2}]},
    Panel[
      Column[{
        Style[
          If[IntegerQ[seed],
            "Seed: " <> ToString[seed],
            Style["Seed casuale (non riproducibile)", Gray]
          ],
          Italic, 12
        ],
        
        Framed[
          Grid[{
            {
              Button["⟵ Precedente", If[index > 1, index--], 
                Appearance -> "Frameless", ImageSize -> 100, Background -> LightBlue],
              Button["Successivo ⟶", If[index < 5, index++], 
                Appearance -> "Frameless", ImageSize -> 100, Background -> LightBlue],
              Button["💡 Suggerimento",
                CreateDialog[
                  Column[{
                    Style["Matrice della trasformazione corrente", Bold, 16, Darker@Blue],
                    Spacer[10],
                    Style[MatrixForm[transformations[[index, 2]]], 14],
                    Spacer[20],
                    DefaultButton[]
                  }],
                  WindowTitle -> "Suggerimento",
                  WindowSize -> {300, 250}
                ],
                Appearance -> "Frameless", Background -> LightYellow
              ]
            }
          }, Spacings -> {2, 2}], 
          FrameStyle -> Directive[Gray, Thin], RoundingRadius -> 5
        ],
        
        Spacer[10],
        Style[Dynamic["🔁 Trasformazione: " <> transformations[[index, 1]]], Bold, 14, Blue],
        
        Grid[{
          {
            Labeled[Framed[img, FrameStyle -> LightGray], "Originale", Top],
            Spacer[20],
            Labeled[Framed[Dynamic[transformedImgs[[index]]], FrameStyle -> LightGray], "Trasformata", Top]
          }
        }],
        
        Spacer[5],
        Style["🧮 Inserisci la tua matrice 2×2:", Bold, 12],
        Grid[{
          {
            InputField[Dynamic[userMatrix[[1, 1]]], Number, FieldSize -> 4],
            InputField[Dynamic[userMatrix[[1, 2]]], Number, FieldSize -> 4]
          },
          {
            InputField[Dynamic[userMatrix[[2, 1]]], Number, FieldSize -> 4],
            InputField[Dynamic[userMatrix[[2, 2]]], Number, FieldSize -> 4]
          }
        }, Spacings -> {2, 2}],
        
        Spacer[5],
        Button["✅ Verifica",
          If[
            userMatrix === transformations[[index, 2]],
            CreateDialog[{Style["✔️ Corretto!", Bold, 16, Darker[Green]], DefaultButton[]}],
            CreateDialog[{Style["❌ Sbagliato!", Bold, 16, Red], DefaultButton[]}]
          ],
          ImageSize -> Medium, Background -> LightGreen
        ]
      },
      Spacings -> 1.5
      ],
      BaseStyle -> {FontFamily -> "Helvetica", FontSize -> 12}
    ]
  ]
];

End[];
EndPackage[];