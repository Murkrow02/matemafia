BeginPackage["Pacchetto`"]

aUI::usage = 
  "aUI rappresenta il componente dell'interfaccia utente dell'applicazione. \
Fornisce controlli interattivi per modificare una matrice binaria (0/255), \
visualizzarla in bianco e nero, regolare i canali di colore RGB tramite slider \
e applicare i valori selezionati a una matrice di colori.";

bUI::usage = "
bUI[] crea una interfaccia grafica composta da tre pannelli per applicare trasformazioni geometriche 
su un'immagine di esempio (ruotazione, riflessione e scala). 

Ogni pannello utilizza Manipulate[] per:
  – ruotare l'immagine di un angolo variabile in gradi, mostrando anche la matrice di rotazione e il 
    grafico di sin(angolo) con indicazione del punto corrente;
  – riflettere l'immagine rispetto all'asse X o all'asse Y, visualizzando la matrice di riflessione;
  – scalare l'immagine con fattori sx e sy, calcolando la matrice di scala, il determinante, evidenziando 
    eventuali avvisi e mostrando l'effetto sul quadrato unitario.

Uso:
  bUI[]

Non modifica le variabili globali e si basa su ExampleData[{\"TestImage\",\"House\"}].";

cUI::usage = "cUI represents the user interface component of the application. It is used to manage and display the graphical interface elements.";

es::usage = 
  "es[] mostra un'immagine di esempio e permette di scorrere tra 5 trasformazioni lineari casuali con pulsanti. Può essere chiamata anche come es[seed_Integer] per ripetere una generazione specifica.";

Begin["`Private`"]


(* ============================== SEZIONE A ============================== *)

aUI[] := DynamicModule[
  {
   (* Inizializza una matrice 5x5 con valore 255 (bianco) per rappresentare l'immagine binaria *)
   mat = ConstantArray[255, {5, 5}],
   
   (* Inizializza una matrice 5x5 di triplette RGB, tutte bianche ({255,255,255}) *)
   rgbMat = ConstantArray[{255, 255, 255}, {5, 5}],
   
   (* Variabili per i valori RGB controllati tramite slider *)
   r = 255, g = 255, b = 255
  },

  (* Contenitore principale dell'interfaccia: tutto organizzato in colonne verticali *)
  Column[{

    (* PRIMA SEZIONE: matrice binaria interattiva + visualizzazione grafica *)
    Row[{

      (* Colonna con testo esplicativo *)
      Column[{
        Style["Esempio interattivo 1: Matrici RGB", Bold, 14],
        Spacer[5],
        Text@Column[{"Questo esercizio consente di interagire con una matrice 5 x 5, dove ciascuna cella puo' assumere valori binari: 0 (nero) o 255 (bianco)."}],
        Spacer[5],
        Text@Column[{"L'utente puo' modificare i valori delle celle cliccandoci sopra, osservando simultaneamente la rappresentazione numerica e grafica della matrice."}],
        Spacer[5],
        Text@Column[{"Ogni cella e' rappresentata da un pulsante che mostra il valore corrente (0 o 255). Cliccando su una cella, il suo valore viene invertito: da 0 a 255 o viceversa."}],
        Spacer[5],
        Text@Column[{"Accanto alla matrice numerica, e' presente una rappresentazione grafica che mostra la matrice in scala di grigi: le celle con valore 0 appaiono nere, mentre quelle con valore 255 appaiono bianche."}],
        Spacer[5],
        
        (* Griglia 5x5: ogni cella è un pulsante che alterna 0/255 *)
        Grid[
          Table[
            With[{i = i, j = j},
              Button[
                Dynamic[mat[[i, j]]], (* Mostra il valore corrente della cella in tempo reale *)

                (* Azione al clic: cambia il valore tra 0 e 255 *)
                mat[[i, j]] = If[mat[[i, j]] == 0, 255, 0],

                Appearance -> None,
                BaseStyle -> {FontSize -> 14, FontWeight -> Bold},
                Background -> Dynamic[
                  If[mat[[i, j]] == 0, Gray, LightGray]
                ],
                ImageSize -> {40, 40}
              ]
            ],
            {i, 5}, {j, 5}
          ],
          Frame -> All,
          Spacings -> {0, 0}
        ]
      }],

      Spacer[6], (* Distanza tra griglia e grafico *)

      (* Visualizzazione scacchiera interattiva *)
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

    Spacer[30], (* Distanza verticale tra sezioni *)

    (* Colonna con testo esplicativo *)
    Column[{
      Style["Esempio interattivo 1: Colori RGB", Bold, 14],
      Spacer[5],
      Text@Column[{"Questo esercizio permette di esplorare la composizione dei colori attraverso i canali RGB (Rosso, Verde, Blu)."}],
      Spacer[5],
      Text@Column[{"Tramite gli slider, e' possibile regolare i valori dei tre canali per generare un colore personalizzato."}],
      Spacer[5],
      Text@Column[{"Premendo il pulsante \"Applica RGB a tutta la matrice\", il colore selezionato viene applicato a tutte le celle della matrice 5 x 5."}],
      Spacer[5],
      Text@Column[{"Ogni cella mostra i suoi valori RGB numerici e la rappresentazione grafica accanto visualizza i colori reali corrispondenti."}],
      Spacer[5],
      Text@Column[{"Questo strumento aiuta a comprendere come i diversi livelli di R, G e B si combinano per formare i colori digitali."}],
      Spacer[5]
    }],

    (* SECONDA SEZIONE: matrice RGB con valori testuali, visualizzazione colorata, e slider *)
    Row[{

      (* Visualizzazione testuale della matrice RGB (ogni cella mostra i valori R, G, B) *)
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

      Spacer[20], (* Spazio tra valori numerici e mappa colorata *)

      (* Visualizzazione grafica della matrice RGB in colore reale *)
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

      (* Slider e controlli per modificare e applicare i valori RGB *)
      Column[{
        Style["Regola i canali RGB:", Bold],

        (* SLIDER ROSSO *)
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

        (* SLIDER VERDE *)
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

        (* SLIDER BLU *)
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

        (* Pulsante per aggiornare l'intera matrice RGB con il colore selezionato *)
        Button[
          "Applica RGB a tutta la matrice",
          rgbMat = ConstantArray[{Round[r], Round[g], Round[b]}, {5, 5}],
          ImageSize -> 200
        ]
      }]
    }]
  }]
]


(* ============================== SEZIONE B ============================== *)
(* Funzione per la riflessione dell'immagine *)
riflessione[] := Module[{},
  Manipulate[
    Module[{img, riflessa, matrice},
      img = ExampleData[{"TestImage", "House"}];
      
      {riflessa, matrice} = If[asse == "X",
        {ImageReflect[img, Top], {{1, 0}, {0, -1}}},
        {ImageReflect[img, Left], {{-1, 0}, {0, 1}}}
      ];
      
      Grid[{{
        riflessa,
        Column[{
          Panel[
            Column[{
              Style["ISTRUZIONI:", Bold, 20, Darker[Blue]],
              Style["1. Scegli l'asse di riflessione dal menu a tendina:", 17],
              Style["2. X = Specchio verticale (sinistra ↔ destra)", 17],
              Style["3. Y = Specchio orizzontale (sopra ↕ sotto)", 17]
            }, Alignment -> Left],
            Background -> Lighter[Gray, 0.9]
          ],
          Spacer[10],
          Style["Matrice della Riflessione", Bold, 16], 
          MatrixForm[matrice]
        }]
      }}, Spacings -> 2]
    ],
    {{asse, "X", 
      Column[{
        Style["RIFLESSIONE", Bold, 20, Darker[Blue]],
        "(X = ribalta sinistra/destra)", 
        "(Y = ribalta sopra/sotto)"
      }]
    }, {"X", "Y"}}
  ]
]

(* Funzione per il ridimensionamento dell'immagine *)
scala[] := Module[{},
  Manipulate[
    Module[{img, scalata, matrice, det, unitSquare, transformedSquare, warning, plotRange},
      img = ExampleData[{"TestImage", "House"}];
      scalata = ImageResize[img, Scaled[{sx, sy}]];
      
      matrice = {{sx, 0}, {0, sy}};
      det = sx * sy;
      
      unitSquare = Polygon[{{0, 0}, {1, 0}, {1, 1}, {0, 1}}];
      transformedSquare = GeometricTransformation[unitSquare, ScalingTransform[{sx, sy}]];
      
      plotRange = {{-0.5, Max[1.5, sx + 0.5]}, {-0.5, Max[1.5, sy + 0.5]}};
      
      warning = Which[
        det == 0, Style["ATTENZIONE: Immagine appiattita!", Red, Bold],
        det < 0.1, Style["Attenzione: Distorsione estrema!", Orange, Bold],
        True, ""
      ];
      
      Grid[{{ 
        scalata,
        Column[{
          Panel[
            Column[{
              Style["ISTRUZIONI:", Bold, 20, Darker[Blue]],
              Style["• Usa i due slider per regolare l'ingrandimento lungo gli assi X e Y.", 17],
              Style["• Valore 1 = dimensione originale", 17],
              Style["• Valore < 1 = rimpicciolisce l'immagine", 17],
              Style["• Valore > 1 = ingrandisce l'immagine", 17]
            }, Alignment -> Left],
            Background -> Lighter[Gray, 0.9]
          ],
          Style["Matrice di Scala", Bold, 16], 
          MatrixForm[matrice],
          Style["Fattore di Ingrandimento (Determinante): " <> ToString[det], Bold, Darker[Green]],
          warning,
          Graphics[{
            {EdgeForm[Black], LightBlue, unitSquare},
            {EdgeForm[{Thick, Red}], Opacity[0.5], Red, transformedSquare},
            Text[Style["1", 12], {0.5, -0.1}], Text[Style["1", 12], {-0.1, 0.5}],
            Text[Style[ToString[sx], 12, Red], {sx/2, -0.1}], 
            Text[Style[ToString[sy], 12, Red], {-0.1, sy/2}],
            Gray, Dashed, Line[{{0, sy}, {sx, sy}}], Line[{{sx, 0}, {sx, sy}}],
            Axes -> True, PlotLabel -> Style["Trasformazione Geometrica", 14],
            ImageSize -> 300, PlotRange -> plotRange
          }]
        }, Alignment -> Center]
      }}, Spacings -> 3]
    ],

{{sx, 1, 
  Column[{
    Style["SCALA", Bold, 20, Darker[Blue]],
    "Scala Orizzontale (X)"
  }]
}, 0.0, 1.5, 0.1, Appearance -> "Labeled", ImageSize -> Small},

{{sy, 1, "Scala Verticale (Y)"}, 0.0, 1.5, 0.1, 
 Appearance -> "Labeled", ImageSize -> Small},
     
    Delimiter,
    Panel[Row[{
      Style["PRESET:", Bold, 12, Darker[Blue]], Spacer[10],
      Button["1:1", {sx = 1, sy = 1}, Tooltip -> "Ripristina dimensioni originali"],
      Button["1.5:1", {sx = 1.5, sy = 1}, Tooltip -> "50% più largo"],
      Button["1:1.5", {sx = 1, sy = 1.5}, Tooltip -> "50% più alto"],
      Button["0.5:1", {sx = 0.5, sy = 1}, Tooltip -> "Metà larghezza"],
      Button["1:0.5", {sx = 1, sy = 0.5}, Tooltip -> "Metà altezza"]
    }], Background -> Lighter[Yellow, 0.8]]
  ]
]



(* ============================== SEZIONE C ============================== *)

ClearAll[cUI]

cUI[] :=  (* Definisce la funzione senza argomenti *)
 Deploy @   (* Deploy rende l'espressione non editabile dall'utente *)
 Module[
  {
    (* Variabili locali del modulo --------------------------------- *)
    imageDisplaySize  = 300,   (* lato in pixel per le immagini principali *)
    neighborhoodDisplaySize = 250 (* lato per la preview del vicinato *)
  },

  (* Layout principale: una colonna di elementi -------------------- *)
  Column[{

    (* ===== 1. Intestazione ===== *)
    Style["Esempio interattivo 3: Sfocatura con Kernel (Box Blur)", Bold, 14],
    Spacer[5],   (* piccola distanza verticale *)

    (* Blocco di testo descrittivo, organizzato a colonne *)
    Text @ Column[{
      "Come funziona:",
      " - Muovi lo slider per cambiare la dimensione del kernel (3, 5, 7, 9).",
      " - Clicca sull'immagine originale per scegliere il pixel centrale (non serve trascinare).",
      " - L'immagine sfocata a destra si aggiorna automaticamente.",
      " - Il pannello in basso mostra il vicinato e il valore calcolato."
    }],
    Spacer[10],

    (* ===== 2. Area interattiva ===== *)
    DynamicModule[{
      kernelSize = 3,                 (* valore iniziale dello slider *)
      locatorPosition = {50, 50},     (* posizione iniziale del cursore rosso *)
      img = ExampleData[{"TestImage", "House"}]  (* immagine di esempio *)
    },

      Column[{
        (* 2a. Slider per scegliere la dimensione del kernel -------- *)
        Slider[ Dynamic[kernelSize], {3, 9, 2}, Appearance -> "Labeled", ImageSize -> Full],
        Spacer[5],

        (* 2b. Sotto‑modulo che tiene le dimensioni dell'immagine ---- *)
        DynamicModule[{ imageDimensions = ImageDimensions[img] },

          (* Contenuto dinamico: si aggiorna quando kernelSize o locatorPosition cambiano *)
          Dynamic[
            Module[
              {
                (* Variabili interne alla convoluzione -------------- *)
                kSize, kernel, locX, locY, imageData,
                neighborhood, convolvedValue, padding, blurredImg,
                originalImgWithRect
              },

              (* ---------- Pre‑calcoli ----------------------------- *)
              kSize  = kernelSize;                                      (* dimensione corrente del kernel *)
              kernel = ConstantArray[ 1 / kSize^2, {kSize, kSize} ];    (* kernel uniforme *)

              (* Converte la posizione del Locator da coordinate grafiche a indici di matrice *)
              locX = Round[ locatorPosition[[1]] ];
              locY = Round[ imageDimensions[[2]] - locatorPosition[[2]] + 1 ];

              imageData = ImageData[ img ];    (* matrice (riga, colonna, canale) con i pixel *)
              padding   = Floor[ kSize / 2 ];  (* raggio del kernel intorno al centro *)

              (* Applica la convoluzione e ridimensiona l'immagine sfocata *)
              blurredImg = ImageResize[ ImageConvolve[ img, kernel ], imageDisplaySize ];

              (* Disegna il rettangolo sul punto scelto, poi rasterizza in immagine *)
              originalImgWithRect = Rasterize[
                Show[
                  img,
                  Graphics[{
                    Red, Thickness[0.01],
                    Rectangle[ {locatorPosition[[1]] - kSize/2, locatorPosition[[2]] - kSize/2},
                               {locatorPosition[[1]] + kSize/2, locatorPosition[[2]] + kSize/2} ]
                  }]
                ],
                RasterSize -> imageDisplaySize
              ];

              (* Estrae il vicinato del pixel centrale -------------- *)
              neighborhood = Table[
                imageData[[ Clip[locY + i - padding, {1, imageDimensions[[2]]}],
                            Clip[locX + j - padding, {1, imageDimensions[[1]]}] ]],
                {i, 1, kSize}, {j, 1, kSize}
              ];

              (* Calcola il valore convoluto (media pesata) *)
              convolvedValue = Total[ Flatten[ neighborhood * kernel ] ];

              (* ========== Layout visivo dei risultati ============= *)
              Column[{

                (* --- Blocchi in alto: originale, sfocata, kernel --- *)
                Row[{

                  (* Immagine originale con Locator *)
                  Column[{
                    Style["Immagine originale", Bold],
                    LocatorPane[
                      Dynamic[ locatorPosition ],
                      Image[ originalImgWithRect, ImageSize -> imageDisplaySize ],
                      LocatorShape -> Graphics[{ Circle[{0, 0}, 5] }]
                    ]
                  }],

                  Spacer[20],

                  (* Immagine sfocata *)
                  Column[{
                    Style["Immagine sfocata", Bold],
                    Image[ blurredImg, ImageSize -> imageDisplaySize ]
                  }],

                  Spacer[20],

                  (* Matrice del kernel *)
                  Column[{
                    Style["Kernel " <> ToString[kSize] <> " x " <> ToString[kSize], Bold],
                    MatrixForm[ kernel ]
                  }]

                }, Alignment -> Top],

                Spacer[10],
                Style[ StringRepeat["-", 60], Gray ],   (* linea di separazione *)
                Spacer[5],

                (* --- Dettagli locali (vicinato) ------------------- *)
                Style["Dettagli locali", Bold],
                Row[{
                  Style["Neighborhood: ", Bold],
                  Image[ ImageResize[ Image[ neighborhood ], neighborhoodDisplaySize ],
                        ImageSize -> neighborhoodDisplaySize ]
                }]
              }]
            ]   
          ]      
        ]       
      }]        
    ]           
  }]           
 ];            



(* ========= 1. PULIZIA DI SYMBOL RESIDUI ========= *)
ClearAll[randomTransform, esUI];   (* elimina vecchie definizioni *)
Remove[Pacchetto"`Private`*"];              (* rimuove simboli privati stantii *)

(* ========= 2. TRASFORMAZIONI CASUALI ========= *)
randomTransform[] := Module[{lista},
  lista = {
    {"Identita",       IdentityMatrix[2]},
    {"Rotazione 90",   {{0, -1}, {1, 0}}},
    {"Rotazione 180",  {{-1, 0}, {0, -1}}},
    {"Rotazione 270",  {{0, 1}, {-1, 0}}},
    {"Riflessione X",  {{1, 0}, {0, -1}}},
    {"Riflessione Y",  {{-1, 0}, {0, 1}}},
    {"Shear Orizz.",   {{1, 1}, {0, 1}}},
    {"Shear Vert.",    {{1, 0}, {1, 1}}},
    {"Scala x2",       {{2, 0}, {0, 2}}},
    {"Scala 1/2",      {{1/2, 0}, {0, 1/2}}}
  };
  RandomChoice[lista]   (* sempre {descrizione, matrice 2x2} *)
];

(* ========= 3. FUNZIONE PRINCIPALE ========= *)
esUI[seed_: Automatic] := Module[
  {img, dims, centro, transfs, imgT, seme},

  (* seed riproducibile ------------------------------------------- *)
  seme  = If[IntegerQ[seed], seed, RandomInteger[10^6]];
  SeedRandom[seme];

  (* immagine di partenza ----------------------------------------- *)
  img = ExampleData[{"TestImage",
     RandomChoice[{
       "House", "Mandrill", "Boat", "Peppers", "Girl",
       "Aerial", "Airplane", "House2", "Moon", "Tank",
       "Tank2", "Tank3"}]}];

  dims   = ImageDimensions[img];
  centro = Mean /@ Transpose[{{1, 1}, dims}];

  (* 5 trasformazioni casuali ------------------------------------- *)
  transfs = Table[randomTransform[], {5}];

  (* immagini trasformate precalcolate ---------------------------- *)
  imgT = Table[
    With[{m = transfs[[i, 2]]},
      ImageTransformation[
        img,
        Function[p, centro + m.(p - centro)],
        DataRange -> Full, Resampling -> "Linear"]
    ],
    {i, 5}
  ];

  (* ================= INTERFACCIA ================================= *)
  DynamicModule[
    {idx = 1, matrUtente = ConstantArray[0, {2, 2}],
     esito = "", imgUtente = img},

    Deploy @ Panel @ Column[{

      (* intestazione + pulsanti ---------------------------------- *)
      Framed[
        Column[{
          Dynamic@Style["Esercizio " <> ToString[idx] <> "/5", Bold, 16, Darker@Green],
          Style["Seed: " <> ToString[seme], Italic, 12, Gray],
          Grid[{{
            Button["Precedente",
              If[idx > 1,
                idx--; matrUtente = ConstantArray[0, {2, 2}]; esito = ""; imgUtente = img;],
              Appearance -> "Frameless", ImageSize -> 100,
              Background -> Lighter[Blue, .9]],
            Button["Successivo",
              If[idx < 5,
                idx++; matrUtente = ConstantArray[0, {2, 2}]; esito = ""; imgUtente = img;],
              Appearance -> "Frameless", ImageSize -> 100,
              Background -> Lighter[Blue, .9]],
            Button["Suggerimento",
              CreateDialog[
                Deploy @ Column[{
                  Style["Matrice corretta", Bold, 14],
                  MatrixForm[transfs[[idx, 2]]],
                  DefaultButton[]
                }],
                WindowTitle -> "Suggerimento"],
              Appearance -> "Frameless",
              Background -> Lighter[Green, .8]]
          }}]
        }],
        FrameStyle -> LightGray, RoundingRadius -> 5
      ],

      Spacer[8],
      Style[Dynamic["Trasformazione: " <> transfs[[idx, 1]]], Bold, 14, Blue],

      (* immagini -------------------------------------------------- *)
      Grid[{{
        Labeled[img, "Originale", Top],
        Spacer[10],
        Labeled[Dynamic[imgT[[idx]]], "Trasformata", Top]
      }}],

      Spacer[6],
      Style["Inserisci la tua matrice 2x2:", Bold],
      Grid[{
        {InputField[Dynamic[matrUtente[[1, 1]]], Number, FieldSize -> 4],
         InputField[Dynamic[matrUtente[[1, 2]]], Number, FieldSize -> 4]},
        {InputField[Dynamic[matrUtente[[2, 1]]], Number, FieldSize -> 4],
         InputField[Dynamic[matrUtente[[2, 2]]], Number, FieldSize -> 4]}
      }],

      Button["Verifica",
        Module[{ok, f},
          ok    = matrUtente === transfs[[idx, 2]];
          esito = If[ok, "Corretto!", "Sbagliato!"];
          f     = Function[p, centro + matrUtente.(p - centro)];
          imgUtente = ImageTransformation[img, f, DataRange -> Full, Resampling -> "Linear"];
        ],
        ImageSize -> Medium, Background -> Lighter[Green, .8]],

      Spacer[8],
      Dynamic[
        If[esito =!= "",
          Column[{
            Style[esito, Bold, 14, If[esito === "Corretto!", Darker@Green, Red]],
            Grid[{{ Labeled[img, "Originale", Top],
                    Spacer[10],
                    Labeled[imgUtente, "Tua trasformazione", Top] }}]
          }, Spacings -> 1.2],
          ""],
        TrackedSymbols :> {esito}]
    }, Spacings -> 1.2]
  ]
];


(* ============================== SEZIONE ESERCIZIO ============================== *)

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

(* Definizione della funzione principale "es" che accetta un parametro opzionale "seed" *)
es[seed_: Automatic] := Module[
  {
    img,            (* immagine originale selezionata casualmente *)
    dims,           (* dimensioni dell'immagine *)
    center,         (* centro geometrico dell'immagine *)
    transformations,(* lista di 5 trasformazioni casuali *)
    transformedImgs,(* immagini ottenute dalle trasformazioni *)
    seedUsed        (* seed effettivamente usato per la generazione casuale *)
  },

  (* Determina quale seed usare:
     - se l'utente fornisce un intero, lo usa direttamente
     - altrimenti, genera un intero casuale tra 0 e 10^6 *)
  seedUsed = If[IntegerQ[seed], seed, RandomInteger[10^6]];
  SeedRandom[seedUsed]; (* Imposta il generatore casuale per riproducibilità *)

  (* Seleziona un'immagine di test casuale tra quelle elencate *)
  img = ExampleData[{
    "TestImage", 
    RandomChoice[{
      "House", "Mandrill", "Boat", "Peppers", "Girl", 
      "Aerial", "Airplane", "House2", "Moon", "Tank", 
      "Tank2", "Tank3"
    }]
  }];

  (* Ottiene larghezza e altezza dell'immagine in pixel *)
  dims = ImageDimensions[img];

  (* Calcola le coordinate del centro dell'immagine:
     - costruisce due punti: {1,1} (angolo in alto a sinistra) e {w, h}
     - prende la media tra le due coordinate (centro del rettangolo) *)
  center = Mean /@ Transpose[{{1, 1}, dims}];

  (* Crea una lista di 5 trasformazioni casuali 
     - ogni trasformazione è una coppia: descrizione testuale e matrice 2x2 *)
  transformations = Table[randomTransform[], {5}];

  (* Applica ciascuna trasformazione all'immagine:
     - per ogni trasformazione, costruisce una funzione p ↦ centro + M . (p - centro)
     - applica la trasformazione all'immagine usando ImageTransformation *)
  transformedImgs = Table[
    Module[
      {
        matrix = transformations[[i, 2]], (* estrae la matrice i-esima *)
        transfFun                        (* funzione geometrica associata *)
      },
      transfFun = Function[
        p, center + matrix . (p - center) (* trasforma ogni punto rispetto al centro *)
      ];
      ImageTransformation[
        img, transfFun, 
        DataRange -> Full,               (* specifica che i punti coprono tutta l'immagine *)
        Resampling -> "Linear"           (* interpolazione lineare per migliore qualità *)
      ]
    ],
    {i, 5} (* ripete per ciascuna delle 5 trasformazioni *)
  ];

  (* Crea l'interfaccia utente interattiva tramite DynamicModule *)
  DynamicModule[
    {
      index = 1,                         (* numero dell'esercizio corrente: 1–5 *)
      userMatrix = ConstantArray[0, {2, 2}], (* matrice inserita dall'utente *)
      resultText = "",                  (* testo con risultato "Corretto!" o "Sbagliato!" *)
      userImage = img                   (* immagine trasformata dall'utente *)
    },

    (* Crea un pannello principale con tutti gli elementi grafici *)
    Panel[
      Column[{

        (* Area superiore: titolo e controlli *)
        Framed[
          Column[{

            (* Titolo dinamico: mostra il numero dell'esercizio e il seed usato *)
            Dynamic[
              Column[{
                Style[
                  "Esercizio " <> ToString[index] <> "/5", 
                  Bold, 16, Darker[Green]
                ],
                Spacer[5],
                Style[
                  "Seed: " <> ToString[seedUsed], 
                  Italic, 12, Darker[Gray]
                ]
              }]
            ],

            Spacer[5],

            (* Sezione con tre pulsanti: Precedente, Successivo, Suggerimento *)
            Grid[{
              {
                (* Pulsante: passa all'esercizio precedente *)
                Button[
                  Style["Precedente", Bold, 14, Darker[Blue]],
                  If[index > 1,
                    index--;
                    userMatrix = ConstantArray[0, {2, 2}]; (* resetta la matrice utente *)
                    resultText = "";                       (* resetta il testo del risultato *)
                    userImage = img                        (* resetta immagine utente *)
                  ],
                  Appearance -> "Frameless",
                  ImageSize -> 120,
                  Background -> Lighter[Blue, 0.9]
                ],

                (* Pulsante: passa all'esercizio successivo *)
                Button[
                  Style["Successivo", Bold, 14, Darker[Blue]],
                  If[index < 5,
                    index++;
                    userMatrix = ConstantArray[0, {2, 2}];
                    resultText = "";
                    userImage = img
                  ],
                  Appearance -> "Frameless",
                  ImageSize -> 120,
                  Background -> Lighter[Blue, 0.9]
                ],

                (* Pulsante: mostra la matrice corretta dell'esercizio corrente *)
                Button[
                  Style["Suggerimento", Bold, 14, Darker[Yellow]],
                  CreateDialog[
                    Panel[
                      Column[{
                        Style[
                          "Matrice della trasformazione corrente", 
                          Bold, 16, Darker@Blue
                        ],
                        Spacer[10],
                        Framed[
                          Style[
                            MatrixForm[transformations[[index, 2]]], 
                            16, Black
                          ],
                          FrameStyle -> LightGray,
                          Background -> Lighter[Gray, 0.9],
                          RoundingRadius -> 5,
                          FrameMargins -> 15
                        ],
                        Spacer[15],
                        DefaultButton[] (* pulsante OK *)
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
          FrameStyle -> Directive[Gray, Thin],
          RoundingRadius -> 5
        ],

        Spacer[10],

        (* Descrizione della trasformazione corrente *)
        Style[
          Dynamic["Trasformazione: " <> transformations[[index, 1]]],
          Bold, 14, Blue
        ],

        (* Visualizzazione: confronto immagine originale e trasformata *)
        Grid[{
          {
            Labeled[
              Framed[img, FrameStyle -> LightGray],
              Style["Originale", Bold],
              Top
            ],
            Spacer[20],
            Labeled[
              Framed[
                Dynamic[transformedImgs[[index]]],
                FrameStyle -> LightGray
              ],
              Style["Trasformata", Bold],
              Top
            ]
          }
        }],

        Spacer[5],
        Style["Inserisci la tua matrice 2x2:", Bold, 12],

        (* Input della matrice utente: 4 campi numerici *)
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

        (* Verifica e output *)
        DynamicModule[{},
          Column[{

            (* Pulsante "Verifica" che controlla se la matrice inserita è corretta *)
            Button[
              Style["Verifica", Bold, 14, Darker[Red]],
              Module[
                {
                  isCorrect,  (* vero se la matrice è uguale a quella target *)
                  matrixFun  (* funzione geometrica basata sulla matrice utente *)
                },
                isCorrect = userMatrix === transformations[[index, 2]];
                resultText = If[isCorrect, "Corretto!", "Sbagliato!"];
                matrixFun = Function[p, center + userMatrix . (p - center)];
                userImage = ImageTransformation[
                  img, matrixFun, DataRange -> Full, Resampling -> "Linear"
                ];
              ],
              ImageSize -> Medium,
              Background -> Lighter[Green, 0.8]
            ],

            Spacer[10],

            (* Mostra dinamicamente il risultato e la trasformazione utente *)
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
                }, Spacings -> 1.5],
                "" (* se nessun risultato, mostra stringa vuota *)
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



End[]
EndPackage[]