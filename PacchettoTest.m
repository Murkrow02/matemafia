BeginPackage["PacchettoTest`"]

es::usage = 
  "es[] mostra un'immagine di esempio e permette di scorrere tra 5 trasformazioni lineari casuali con pulsanti. \
   Può essere chiamata anche come es[seed_Integer] per ripetere una generazione specifica.";

esGai::usage = 
  "esGai[] carica un'immagine di esempio e applica una trasformazione lineare casuale (rotazione, scalatura o \
   riflessione) mostrando l'immagine originale e quella trasformata.";

Begin["`Private`"]

(* Funzione per creare una trasformazione casuale con valori interi nella matrice *)
randomTransform[] := Module[{transformTypeChoice, subChoice},
  
  (* Scegliamo la categoria di trasformazione in modo uniforme *)
  transformTypeChoice = RandomChoice[{"Rotazione", "Scalatura", "Riflessione"}];
  
  Switch[transformTypeChoice,
    
    "Rotazione",
    (* Rotazioni a multipli di 90° con matrici intere *)
    subChoice = RandomChoice[{
      {"Rotazione 0°",    {{1, 0}, {0, 1}}},
      {"Rotazione 90°",   {{0, -1}, {1, 0}}},
      {"Rotazione 180°",  {{-1, 0}, {0, -1}}},
      {"Rotazione 270°",  {{0, 1}, {-1, 0}}}
    }],
    
    "Scalatura",
    (* Scalatura con fattori interi scelti da un piccolo insieme: -2, -1, 1, 2. 
       Se vuoi solo scalature positive, rimuovi i valori negativi. *)
    Module[{sx, sy},
      sx = RandomChoice[{-2, -1, 1, 2}];
      sy = RandomChoice[{-2, -1, 1, 2}];
      subChoice = {
        "Scalatura (" <> ToString[sx] <> ", " <> ToString[sy] <> ")",
        DiagonalMatrix[{sx, sy}]
      };
    ],
    
    "Riflessione",
    (* Varie riflessioni “classiche” con matrici integer *)
    subChoice = RandomChoice[{
      {"Riflessione X",    {{1,  0}, {0, -1}}},   (* riflette intorno all’asse x *)
      {"Riflessione Y",    {{-1, 0}, {0,  1}}},   (* riflette intorno all’asse y *)
      {"Riflessione Y=X",  {{0,  1}, {1,  0}}},   (* riflette rispetto alla diagonale y=x *)
      {"Riflessione Y=-X", {{0, -1}, {-1, 0}}}    (* riflette rispetto alla diagonale y=-x *)
    }]
  ];
  
  subChoice
];

(* Funzione principale con supporto al seed *)
es[seed_: Automatic] := Module[
  {
    img, dims, center,
    transformations, transformedImgs
  },
  
  (* Se l'utente specifica un seed, usiamolo per fissare la sequenza random *)
  If[IntegerQ[seed], SeedRandom[seed], SeedRandom[]];
  
  (* Carica l'immagine di esempio *)
  img = ExampleData[{"TestImage", "House"}];
  dims = ImageDimensions[img];
  center = Mean /@ Transpose[{{1, 1}, dims}];
  
  (* Genera 5 trasformazioni casuali *)
  transformations = Table[randomTransform[], {5}];
  
  (* Applica ciascuna trasformazione all'immagine *)
  transformedImgs = Table[
    Module[{matrix = transformations[[i, 2]], transfFun},
      transfFun = Function[p, center + matrix . (p - center)];
      ImageTransformation[img, transfFun, DataRange -> Full, 
        Resampling -> "Linear"]
    ],
    {i, 5}
  ];
  
  (* DynamicModule per navigare tra le trasformazioni con pulsanti *)
  DynamicModule[{index = 1},
    Column[{
      Style[
        If[IntegerQ[seed],
          "Seed: " <> ToString[seed],
          Style["Seed casuale (non riproducibile)", Gray]
        ],
        Italic, 12
      ],
      Row[{
        Button["<-- Precedente", If[index > 1, index--], Method -> "Queued"],
        Spacer[20],
        Button["Successivo -->", If[index < 5, index++], Method -> "Queued"]
      }],
      Style[Dynamic["Trasformazione: " <> transformations[[index, 1]]], Bold, 14],
      Row[{
        Labeled[img, "Originale", Top],
        Spacer[20],
        Labeled[Dynamic[transformedImgs[[index]]], "Trasformata", Top]
      }],
      Style["Matrice applicata:", Bold, 12],
      Dynamic[MatrixForm[transformations[[index, 2]]]]
    }]
  ]
];

End[];
EndPackage[];
