BeginPackage["PacchettoTest`"]

es::usage = 
  "es[] mostra un'immagine di esempio e permette di scorrere tra 5 trasformazioni lineari casuali con pulsanti. Può essere chiamata anche come es[seed_Integer] per ripetere una generazione specifica.";

Begin["`Private`"]

(* Funzione aggiornata per creare una trasformazione casuale più ricca *)
randomTransform[] := Module[{transformTypeChoice, subChoice},
  transformTypeChoice = RandomChoice[{"Rotazione", "Scalatura", "Riflessione"}];
  Switch[transformTypeChoice,
    
    "Rotazione",
    subChoice = RandomChoice[{
      {"Rotazione 0 gradi",    IdentityMatrix[2]},
      {"Rotazione 45 gradi",   {{0.7071, -0.7071}, {0.7071, 0.7071}}},
      {"Rotazione 90 gradi",   {{0, -1}, {1, 0}}},
      {"Rotazione 135 gradi",  {{-0.7071, -0.7071}, {0.7071, -0.7071}}},
      {"Rotazione 180 gradi",  {{-1, 0}, {0, -1}}},
      {"Rotazione 225 gradi",  {{-0.7071, 0.7071}, {-0.7071, -0.7071}}},
      {"Rotazione 270 gradi",  {{0, 1}, {-1, 0}}},
      {"Rotazione 315 gradi",  {{0.7071, 0.7071}, {-0.7071, 0.7071}}}
    }],
    
    "Scalatura",
    Module[{sx, sy},
      sx = RandomChoice[{-4, -3, -2, -1, 1, 2, 3, 4}];
      sy = RandomChoice[{-4, -3, -2, -1, 1, 2, 3, 4}];
      subChoice = {
        "Scalatura (" <> ToString[sx] <> ", " <> ToString[sy] <> ")",
        DiagonalMatrix[{sx, sy}]
      };
    ],
    
    "Riflessione",
    subChoice = RandomChoice[{
      {"Riflessione X",      {{1, 0}, {0, -1}}},
      {"Riflessione Y",      {{-1, 0}, {0, 1}}},
      {"Riflessione Y=X",    {{0, 1}, {1, 0}}},
      {"Riflessione Y=-X",   {{0, -1}, {-1, 0}}},
      {"Riflessione Y=2X",   (1/5) {{-3, 4}, {4, 3}}},
      {"Riflessione Y=-1/2X",(1/5) {{-1, 4}, {4, 1}}}
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
      ImageTransformation[img, transfFun, DataRange -> Full, Resampling -> "Linear"]
    ],
    {i, 5}
  ];
  
  DynamicModule[{index = 1, userMatrix = ConstantArray[0, {2, 2}], resultText = "", userImage = img},
    Panel[
      Column[{
        Framed[
          Column[{
            Dynamic[
              Style["Esercizio " <> ToString[index] <> "/5", Bold, 14, Darker@Green, Editable -> False]
            ],
            Spacer[5],
            Grid[{
              {
                Button["<-- Precedente",
                  If[index > 1,
                    index--;
                    userMatrix = ConstantArray[0, {2, 2}];
                    resultText = "";
                    userImage = img;
                  ],
                  Appearance -> "Frameless", ImageSize -> 100, Background -> LightBlue
                ],
                Button["Successivo -->",
                  If[index < 5,
                    index++;
                    userMatrix = ConstantArray[0, {2, 2}];
                    resultText = "";
                    userImage = img;
                  ],
                  Appearance -> "Frameless", ImageSize -> 100, Background -> LightBlue
                ],
                Button["Suggerimento",
                  CreateDialog[
                    Column[{
                      Style["Matrice della trasformazione corrente", Bold, 16, Darker@Blue, Editable -> False],
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
            }, Spacings -> {2, 2}]
          }],
          FrameStyle -> Directive[Gray, Thin], RoundingRadius -> 5
        ],
        
        Spacer[10],
        Style[
          Dynamic["Trasformazione: " <> transformations[[index, 1]]],
          Bold, 14, Blue, Editable -> False
        ],
        
        Grid[{
          {
            Labeled[
              Framed[img, FrameStyle -> LightGray],
              Style["Originale", Bold, Editable -> False],
              Top
            ],
            Spacer[20],
            Labeled[
              Framed[Dynamic[transformedImgs[[index]]], FrameStyle -> LightGray],
              Style["Trasformata", Bold, Editable -> False],
              Top
            ]
          }
        }],
        
        Spacer[5],
        Style["Inserisci la tua matrice 2x2:", Bold, 12, Editable -> False],
        
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
        DynamicModule[{},
          Column[{
            Button["Verifica",
              Module[{isCorrect, matrixFun},
                isCorrect = userMatrix === transformations[[index, 2]];
                resultText = If[isCorrect, "Corretto!", "Sbagliato!"];
                matrixFun = Function[p, center + userMatrix . (p - center)];
                userImage = ImageTransformation[img, matrixFun, DataRange -> Full, Resampling -> "Linear"];
              ],
              ImageSize -> Medium, Background -> LightGreen
            ],
            Spacer[10],
            Dynamic[
              If[resultText =!= "",
                Column[{
                  Style[
                    resultText,
                    Bold, 14,
                    If[resultText === "Corretto!", Darker[Green], Red],
                    Editable -> False
                  ],
                  Grid[{
                    {
                      Labeled[
                        Framed[img, FrameStyle -> LightGray],
                        Style["Originale", Bold, Editable -> False],
                        Top
                      ],
                      Spacer[20],
                      Labeled[
                        Framed[userImage, FrameStyle -> LightGray],
                        Style["Tua trasformazione", Bold, Editable -> False],
                        Top
                      ]
                    }
                  }]
                },
                Spacings -> 1.5
                ],
                ""
              ]
            ]
          }]
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
