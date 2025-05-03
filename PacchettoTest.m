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

(* Funzione principale per esercitarsi con trasformazioni lineari su immagini *)

(* Questo esercizio interattivo ti aiuta a comprendere le trasformazioni lineari 2D applicate alle immagini. 
Viene mostrata un'immagine originale e la sua versione trasformata con una matrice 2x2. 
Il tuo compito è inserire la matrice che pensi sia stata usata. *)
es[seed_: Automatic] := Module[
  {
    img,          (* Immagine originale *)
    dims,         (* Dimensioni dell'immagine *)
    center,       (* Centro dell'immagine *)
    transformations,  (* Lista di trasformazioni da applicare *)
    transformedImgs,  (* Lista di immagini trasformate *)
    seedUsed      (* Seed effettivo usato per generare risultati ripetibili *)
  },
  
  (* Imposta il seed per la generazione casuale, se fornito è usato, altrimenti viene generato uno nuovo *)
  seedUsed = If[IntegerQ[seed], seed, RandomInteger[10^6]];
  SeedRandom[seedUsed]; (* Inizializza il generatore di numeri casuali *)

  (* Seleziona una delle immagini di test fornite da Wolfram Language in modo casuale *)
  img = ExampleData[{"TestImage", 
    RandomChoice[{
      "House", "Mandrill", "Boat", "Peppers", "Girl",
      "Aerial", "Airplane", "House2", "Moon", "Tank",
      "Tank2", "Tank3"
    }]}];

  (* Calcola le dimensioni dell'immagine e il suo centro *)
  dims = ImageDimensions[img];
  center = Mean /@ Transpose[{{1, 1}, dims}]; (* Centro come media dei due estremi *)

  (* Crea una lista di 5 trasformazioni casuali *)
  transformations = Table[randomTransform[], {5}];

  (* Applica le trasformazioni all'immagine originale *)
  transformedImgs = Table[
    Module[
      {
        matrix = transformations[[i, 2]],  (* Matrice della trasformazione corrente *)
        transfFun                        (* Funzione di trasformazione sui pixel *)
      },
      transfFun = Function[p, center + matrix . (p - center)];
      ImageTransformation[
        img, transfFun,
        DataRange -> Full,                (* Applica la trasformazione su tutta l'immagine *)
        Resampling -> "Linear"            (* Interpolazione lineare per qualità visiva *)
      ]
    ],
    {i, 5}
  ];

  (* Crea l'interfaccia utente interattiva *)
  DynamicModule[
    {
      index = 1,                          (* Indice dell'esercizio corrente (da 1 a 5) *)
      userMatrix = ConstantArray[0, {2, 2}], (* Matrice inserita dall'utente *)
      resultText = "",                   (* Messaggio "Corretto"/"Sbagliato" *)
      userImage = img                    (* Immagine trasformata con la matrice utente *)
    },
    
    (* Pannello principale *)
    Panel[
      Column[{

        (* Blocco in alto con titolo esercizio e seed *)
        Framed[
          Column[{
            Dynamic[
              Column[{
                Style["Esercizio " <> ToString[index] <> "/5", Bold, 16, Darker[Green]],
                Spacer[5],
                Style["Seed: " <> ToString[seedUsed], Italic, 12, Darker[Gray]]
              }]
            ],
            Spacer[5],

            (* Pulsanti di navigazione e suggerimento *)
            Grid[{
              {
                (* Pulsante per passare all'esercizio precedente *)
                Button[
                  Style["Precedente", Bold, 14, Darker[Blue]],
                  If[index > 1,
                    index--;
                    userMatrix = ConstantArray[0, {2, 2}];
                    resultText = "";
                    userImage = img;
                  ],
                  Appearance -> "Frameless",
                  ImageSize -> 120,
                  Background -> Lighter[Blue, 0.9]
                ],
                
                (* Pulsante per passare all'esercizio successivo *)
                Button[
                  Style["Successivo", Bold, 14, Darker[Blue]],
                  If[index < 5,
                    index++;
                    userMatrix = ConstantArray[0, {2, 2}];
                    resultText = "";
                    userImage = img;
                  ],
                  Appearance -> "Frameless",
                  ImageSize -> 120,
                  Background -> Lighter[Blue, 0.9]
                ],
                
                (* Pulsante per visualizzare la matrice della trasformazione corrente *)
                Button[
                  Style["Suggerimento", Bold, 14, Darker[Yellow]],
                  CreateDialog[
                    Panel[
                      Column[{
                        Style["Matrice della trasformazione corrente", Bold, 16, Darker@Blue],
                        Spacer[10],
                        Framed[
                          Style[
                            MatrixForm[transformations[[index, 2]]], (* Mostra la matrice *)
                            16, Black
                          ],
                          FrameStyle -> LightGray,
                          Background -> Lighter[Gray, 0.9],
                          RoundingRadius -> 5,
                          FrameMargins -> 15
                        ],
                        Spacer[15],
                        DefaultButton[]
                      },
                      Spacings -> 1.5],
                      BaseStyle -> {FontFamily -> "Helvetica", FontSize -> 12}
                    ],
                    WindowTitle -> "Suggerimento",
                    WindowSize -> {300, 300},
                    Background -> White
                  ],
                  Appearance -> "Frameless",
                  Background -> Lighter[Green, 0.8]
                ]
              }
            }, Spacings -> {2, 2}]
          }],
          FrameStyle -> Directive[Gray, Thin], RoundingRadius -> 5
        ],

        Spacer[10],

        (* Mostra il tipo di trasformazione (solo descrizione testuale) *)
        Style[
          Dynamic["Trasformazione: " <> transformations[[index, 1]]],
          Bold, 14, Blue
        ],

        (* Visualizzazione delle immagini: originale e trasformata *)
        Grid[{
          {
            Labeled[
              Framed[img, FrameStyle -> LightGray],
              Style["Originale", Bold],
              Top
            ],
            Spacer[20],
            Labeled[
              Framed[Dynamic[transformedImgs[[index]]], FrameStyle -> LightGray],
              Style["Trasformata", Bold],
              Top
            ]
          }
        }],

        Spacer[5],
        (* Input per la matrice da parte dell'utente *)
        Style["Inserisci la tua matrice 2x2:", Bold, 12],
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
        (* Pulsante per verificare la risposta dell'utente *)
        DynamicModule[{},
          Column[{
            Button[
              Style["Verifica", Bold, 14, Darker[Red]],
              Module[{isCorrect, matrixFun},
                (* Verifica se la matrice utente è esattamente uguale a quella vera *)
                isCorrect = userMatrix === transformations[[index, 2]];
                resultText = If[isCorrect, "Corretto!", "Sbagliato!"];
                
                (* Applica la trasformazione dell'utente e aggiorna l'immagine *)
                matrixFun = Function[p, center + userMatrix . (p - center)];
                userImage = ImageTransformation[
                  img, matrixFun,
                  DataRange -> Full,
                  Resampling -> "Linear"
                ];
              ],
              ImageSize -> Medium,
              Background -> Lighter[Green, 0.8]
            ],
            Spacer[10],

            (* Mostra il risultato ("Corretto"/"Sbagliato") e l'immagine trasformata dall'utente *)
            Dynamic[
              If[resultText =!= "",
                Column[{
                  Style[
                    resultText,
                    Bold, 14,
                    If[resultText === "Corretto!", Darker[Green], Red]
                  ],
                  Grid[{
                    {
                      Labeled[
                        Framed[img, FrameStyle -> LightGray],
                        Style["Originale", Bold],
                        Top
                      ],
                      Spacer[20],
                      Labeled[
                        Framed[userImage, FrameStyle -> LightGray],
                        Style["Tua trasformazione", Bold],
                        Top
                      ]
                    }
                  }]
                },
                Spacings -> 1.5
                ],
                ""
              ],
              TrackedSymbols :> {resultText}
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
