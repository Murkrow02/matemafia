(* :Title: Matemafia: introduzione a ... )
( :Context: context da fare )
( :Author: Davide De Rosa, Marco Coppola, Valerio Pio De Nicola, Marco Miozza )
( :Summary:  )
( :Copyright: Matemafia2025 )
( :Package Version: 1 )
( :Mathematica Version: 14.2 )
( :History: last modified 08/05/2025 )
( :Keywords: matrix, rgb, img, trans, scale, rotation )
( :Sources: biblio/sitog )
( :Limitations: this is for educational purposes only. )
( :Discussion: da fare )
( :Requirements: da fare )
( :Warning: package Context is not defined *)

BeginPackage["Pacchetto`"]

aUI::usage = 
  "aUI[] crea un'interfaccia grafica interattiva che consente di esplorare il funzionamento delle immagini digitali in scala di grigi e a colori. \
  L'interfaccia è suddivisa in due sezioni: nella prima l'utente può modificare \
  una matrice binaria 5x5 cliccando sulle celle, osservando in tempo reale la \
  rappresentazione numerica e la visualizzazione grafica corrispondente; nella \
  seconda, è possibile controllare i valori RGB tramite tre slider e applicare \
  il colore selezionato a una matrice 5x5, con visualizzazione sia numerica \
  sia cromatica.";


aUIButton::usage =
  "aUIButton[] visualizza un pulsante «Avvia esempio interattivo» al clic carica l'interfaccia aUI[].";


bUI::usage = 
  "bUI[] crea un'interfaccia grafica interattiva che permette di esplorare tre trasformazioni geometriche fondamentali applicate a un'immagine digitale: rotazione, riflessione e ridimensionamento. \
  Ogni sezione fornisce controlli intuitivi e una rappresentazione visuale della trasformazione applicata, accompagnata dalla relativa matrice. \
  L'interfaccia è progettata per supportare la comprensione visiva e numerica delle trasformazioni lineari nel piano.";


rotazione::usage = 
  "rotazione[] apre un'interfaccia interattiva che permette di ruotare un'immagine bidimensionale. \
  L'utente può selezionare l'angolo di rotazione tramite uno slider oppure scegliere tra valori predefiniti. \
  Viene mostrata l'immagine ruotata, la matrice di rotazione associata e un grafico della funzione seno con indicazione del punto corrente.";

riflessione::usage = 
  "riflessione[] apre un'interfaccia interattiva che consente di riflettere un'immagine rispetto all'asse X o all'asse Y. \
  L'utente può scegliere l'asse tramite un menu a tendina e visualizzare il risultato della trasformazione insieme alla relativa matrice di riflessione.";

scala::usage = 
  "scala[] apre un'interfaccia interattiva che consente di ridimensionare un'immagine secondo fattori di scala orizzontale e verticale. \
  I valori possono essere modificati tramite slider o selezionati da preset rapidi. \
  L'interfaccia visualizza l'immagine scalata, la matrice di trasformazione, il determinante (area relativa) e la trasformazione geometrica applicata a un quadrato unitario.";





bUIButton::usage =
  "aUIButton[] visualizza un pulsante «Avvia esempio interattivo» al clic carica l'interfaccia bUI[].";





cUI::usage = "cUI represents the user interface component of the application. It is used to manage and display the graphical interface elements.";



cUIButton::usage =
  "aUIButton[] visualizza un pulsante «Avvia esempio interattivo»; \
al clic carica l'interfaccia cUI[].";


es::usage = 
  "es[] mostra un'immagine di esempio e permette di scorrere tra 5 trasformazioni lineari casuali con pulsanti. Può essere chiamata anche come es[seed_Integer] per ripetere una generazione specifica.";

SenCosCalcUI::usage = "SenCosCalcUI[] avvia un'interfaccia per calcolare seno e coseno di un angolo specifico in gradi."
esUI::usage = "esUI[] mostra un'immagine di esempio e permette di scorrere tra 5 trasformazioni lineari casuali con pulsanti. Può essere chiamata anche come es[seed_Integer] per ripetere una generazione specifica.";

esUIButton::usage =
  "aUIButton[] visualizza un pulsante «Avvia esempio interattivo»; \
al clic carica l'interfaccia cUI[].";

Begin["`Private`"]


(* ============================== SEZIONE A ============================== *)

aUI[] := DynamicModule[                       (* DynamicModule crea un'interfaccia interattiva con variabili locali che mantengono il loro stato tra le interazioni *)

  {
   mat = ConstantArray[255, {5, 5}],          (* Crea una matrice 5x5 piena di 255, rappresentando un'immagine binaria tutta bianca *)

   rgbMat = ConstantArray[{255, 255, 255}, {5, 5}],  (* Matrice 5x5 di colori RGB bianchi *)

   r = 255, g = 255, b = 255                  (* Variabili iniziali dei canali rosso, verde e blu per lo slider *)
  },

  Column[{                                    (* Column impila verticalmente gli elementi dati come lista *)

    Column[{                                  (* Prima sezione dell’interfaccia: interazione con matrice binaria *)
      Style["Esempio interattivo 1: Matrici RGB", Bold, 14],  (* Style applica uno stile al testo: grassetto, dimensione 14 *)
      Spacer[5],                              (* Spacer aggiunge uno spazio verticale di 5 punti *)

      Text@Column[{                           (* Text renderizza una colonna di stringhe come testo spiegato *)
        "Questo esercizio consente di interagire con una matrice 5 x 5, dove ciascuna cella puo' assumere valori binari: 0 (nero) o 255 (bianco).",
        "L'utente puo' modificare i valori delle celle cliccandoci sopra, osservando simultaneamente la rappresentazione numerica e grafica della matrice.",
        "Ogni cella e' rappresentata da un pulsante che mostra il valore corrente (0 o 255). Cliccando su una cella, il suo valore viene invertito: da 0 a 255 o viceversa.",
        "Accanto alla matrice numerica, e' presente una rappresentazione grafica che mostra la matrice in scala di grigi: le celle con valore 0 appaiono nere, mentre quelle con valore 255 appaiono bianche."
      }],
      Spacer[5],

      Row[{                                   (* Row allinea orizzontalmente più elementi *)

        Grid[                                 (* Grid costruisce una griglia di elementi *)
          Table[                              (* Table genera una matrice di pulsanti 5x5 *)
            With[{i = i, j = j},              (* With salva i valori di i e j in modo che vengano catturati correttamente nei controlli dinamici *)
              Button[                         (* Crea un pulsante per ogni cella della matrice *)
                Dynamic[mat[[i, j]]],         (* Dynamic lega il contenuto del pulsante al valore della cella i,j.  *)               
                mat[[i, j]] = If[mat[[i, j]] == 0, 255, 0],  (* If cambia 0 in 255 e viceversa. Quando il pulsante viene cliccato, il valore della cella viene invertito *)
                Appearance -> None,           (* Nessuna apparenza grafica predefinita per il pulsante *)
                BaseStyle -> {FontSize -> 14, FontWeight -> Bold},  (* Stile del testo interno *)
                Background -> Dynamic[        (* Sfondo del pulsante dipende dinamicamente dal valore della cella *)
                  If[mat[[i, j]] == 0, Gray, LightGray] (* Se il valore è 0, il pulsante è grigio scuro, altrimenti grigio chiaro *)
                ],
                ImageSize -> {40, 40}         (* Dimensione in pixel del pulsante *)
              ]
            ],
            {i, 5}, {j, 5}                    (* Table genera una matrice 5x5 di pulsanti *)
          ],
          Frame -> All,                       (* Aggiunge un bordo a ogni cella della griglia *)
          Spacings -> {0, 0}                  (* Nessuno spazio extra tra le celle *)
        ],

        Spacer[20],                           (* Spazio orizzontale tra la griglia e la rappresentazione grafica *)

        Dynamic[                              (* Dynamic aggiorna l'immagine ogni volta che mat cambia *)
          ArrayPlot[                          (* ArrayPlot visualizza la matrice binaria come immagine *)   
            mat,                              (* Visualizza la matrice binaria *)
            ColorFunction -> (If[# == 0, Black, White] &),  (* Funzione anonima: 0 -> nero, 255 -> bianco *)
            PlotRange -> {0, 255},            (* Definisce il range di valori da 0 a 255 *)
            PlotRangePadding -> None,         (* Nessun padding extra intorno all'immagine *)
            Mesh -> All, MeshStyle -> Black,  (* Aggiunge griglia nera *)
            Frame -> True, FrameTicks -> None,  (* Nessun tick sugli assi *)
            AspectRatio -> 1, ImageSize -> 200  (* Mantiene il rapporto di aspetto 1:1 e dimensione dell'immagine 200x200 pixel *)
          ]
        ]
      }]
    }],

    Spacer[30],                               (* Spazio visivo tra le due sezioni  *)

    Column[{                                  (* Seconda sezione dell’interfaccia: matrice RGB *)
      Style["Esempio interattivo 2: Colori RGB", Bold, 14], (* Titolo della sezione *)
      Spacer[5],

      Text@Column[{                           (* Descrizione testuale della sezione RGB *)
        "Questo esercizio permette di esplorare la composizione dei colori attraverso i canali RGB (Rosso, Verde, Blu).",
        "Tramite gli slider, e' possibile regolare i valori dei tre canali per generare un colore personalizzato.",
        "Premendo il pulsante \"Applica RGB a tutta la matrice\", il colore selezionato viene applicato a tutte le celle della matrice 5 x 5.",
        "Ogni cella mostra i suoi valori RGB numerici e la rappresentazione grafica accanto visualizza i colori reali corrispondenti.",
        "Questo strumento aiuta a comprendere come i diversi livelli di R, G e B si combinano per formare i colori digitali."
      }],
      Spacer[10],

      Row[{                                   (* Riga con griglia numerica, ArrayPlot, slider *)
        Dynamic[                              (* Aggiorna dinamicamente i valori RGB delle celle *)
          Grid[                               (* Griglia per visualizzare i valori RGB *)
            Table[                            (* Tabella per ogni cella della matrice RGB *)
              With[{val = rgbMat[[i, j]]},    (* With salva la tripla RGB in val *)
                Pane[                         (* Pane per visualizzare i valori RGB in una cella *)
                  Column[                     (* Colonna che visualizza i tre valori RGB *)
                    Style[#, FontFamily -> "Courier", FontSize -> 10, FontWeight -> Medium] & /@ val,  
                                              (* Applica la funzione Style a ciascun elemento della lista val: ogni numero RGB viene 
                                              stilizzato con font monospace ("Courier"), dimensione 10 e peso medio.
                                              L’operatore & crea una funzione anonima, mentre /@ è una forma compatta di Map
                                              che applica quella funzione a ogni elemento di val *)
                    Alignment -> Center,      (* Allinea al centro *)
                    Spacings -> 0.5           (* Spaziatura tra i valori RGB *)
                  ],
                  {50, 50},                   (* Dimensione del riquadro per ogni cella *)
                  Alignment -> Center         (* Allinea al centro *)
                ]
              ],
              {i, 5}, {j, 5}                  (* Table genera una matrice 5x5 di pulsanti *)
            ],
            Frame -> All, Spacings -> {0, 0}, Alignment -> Center, ItemSize -> All (* Allinea al centro *)
          ]
        ],

        Spacer[20], 

        Dynamic[                             (* Aggiorna dinamicamente l'immagine RGB *)
          ArrayPlot[                         (* ArrayPlot visualizza la matrice RGB come immagine *)
          Map[RGBColor @@ (#/255) &, rgbMat, {2}],  (* Applica a ogni cella della matrice una normalizzazione dei valori RGB da [0–255] a [0–1] e li converte in oggetti RGBColor per la visualizzazione corretta dei colori *)
            Mesh -> All, MeshStyle -> Black, (* Aggiunge griglia nera *)
            Frame -> True, FrameTicks -> None,      (* Nessun tick sugli assi *)
            AspectRatio -> 1, ImageSize -> 200      (* Mantiene il rapporto di aspetto 1:1 e dimensione dell'immagine 200x200 pixel *)
          ]
        ],

        Spacer[20],

        Column[{                                    (* Colonna con gli slider RGB e il pulsante *)
          Style["Regola i canali RGB:", Bold],

          Row[{                                     (* Slider per il canale Rosso *)
            Style["R", Bold, Red],                  (* Stile del testo per il canale rosso *)
            Slider[                                 (* Slider interattivo *)
              Dynamic[r, (r = Round[#]) &],         (* Dynamic con funzione setter che arrotonda il valore *)
              {0, 255},                             (* Range del valore da 0 a 255 *)
              ContinuousAction -> False,            (* Aggiorna solo al rilascio del mouse *)
              ImageSize -> 200                      (* Dimensione dello slider *)
            ],
            Spacer[10],
            Dynamic[Style[r, Red, Bold]]            (* Visualizza dinamicamente il valore corrente in rosso *)
          }],

          Row[{                                     (* Slider per il canale Verde *)
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

          Row[{                                   (* Slider per il canale Blu *)
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

          Button[                                (* Pulsante per aggiornare l'intera matrice RGB con il colore scelto *)
            "Applica RGB a tutta la matrice",
            rgbMat = ConstantArray[{Round[r], Round[g], Round[b]}, {5, 5}],  (* Crea una matrice 5x5 in cui ogni cella contiene la tripla RGB corrente arrotondata, replicata in tutte le posizioni *)
            ImageSize -> 200                     (* Dimensione del pulsante *)
          ]
        }]
      }]
    }]
  }]
]


(* ============================== SEZIONE B ============================== *)

(* Funzione per la rotazione dell'immagine *)

rotazione[] := Module[{},  (* Module serve a localizzare le variabili dichiarate al suo interno. In questo caso è vuoto perché tutte le variabili sono gestite dentro Manipulate *)

  Manipulate[              (* Manipulate genera un'interfaccia interattiva legata alla variabile 'angolo', con controlli (slider, bottoni) e aggiornamenti dinamici *)

    Module[{img, rotata, matrice, grafico},  (* Definisce un blocco con variabili locali per immagine originale, ruotata, matrice di trasformazione e grafico *)

      img = ExampleData[{"TestImage", "House"}];  
      (* Carica una delle immagini di esempio fornite da Wolfram, in questo caso "House" *)

      rotata = ImageRotate[img, angolo Degree, Background -> White];  
      (* Ruota l'immagine secondo l'angolo specificato in gradi. 'Degree' converte in radianti. Lo sfondo bianco riempie le aree vuote risultanti *)

      matrice = Round[   (* Arrotonda la matrice ai 4 decimali per una visualizzazione più pulita *)
        N[{              (* N forza la valutazione numerica dei valori trigonometrici *)
          {Cos[angolo Degree], -Sin[angolo Degree]},
          {Sin[angolo Degree],  Cos[angolo Degree]}
        }],
        0.0001
      ];                    (* La matrice è quella standard per rotazioni antiorarie nel piano *)

      grafico = Plot[       (* Crea un grafico della funzione seno da 0 a 360 gradi *)
        Sin[x Degree],      (* x Degree converte x (espresso in gradi) in radianti *)
        {x, 0, 360},        (* Range dell’ascissa: 0–360 gradi *)
        PlotStyle -> Red,   (* Colore rosso per la curva *)
        Epilog -> {Red, PointSize[Large], Point[{angolo, Sin[angolo Degree]}]},  
        (* Aggiunge un punto rosso grande nel punto corrispondente all’angolo attuale sulla curva *)
        AxesLabel -> {"Angolo (gradi)", "sin(angolo)"},  (* Etichette sugli assi *)
        PlotRange -> {{0, 360}, {-1.1, 1.1}},  (* Limiti del grafico *)
        ImageSize -> 300  (* Dimensione in pixel del grafico *)
      ];

      Grid[{              (* Grid costruisce una griglia; qui è una riga con due colonne *)
        {
          rotata,         (* Colonna sinistra: mostra l'immagine ruotata *)

          Column[{  (* Colonna destra con istruzioni, matrice e grafico *)
            Panel[  (* Panel racchiude le istruzioni in un riquadro con sfondo *)
              Column[{  (* Column impila verticalmente le righe di testo *)
                Style["ISTRUZIONI:", Bold, 20, Darker[Blue]],  (* Titolo delle istruzioni con stile *)
                Style["1. Scegli l'asse di riflessione", 15],
                Style["2. X = Specchio verticale (sinistra/destra)", 15],
                Style["3. Y = Specchio orizzontale (sopra/sotto)", 15],
                Style["4. La matrice mostra la trasformazione", 15]
              }, Alignment -> Left],  (* Allinea a sinistra il testo nella colonna *)
              Background -> Lighter[Gray, 0.9]  (* Sfondo grigio chiaro per il pannello *)
            ],
            MatrixForm[matrice],  (* Visualizza la matrice di rotazione in formato leggibile *)
            grafico  (* Mostra il grafico del seno con punto mobile *)
          }, Spacings -> 2]  (* Spaziatura verticale tra gli elementi della colonna *)
        }
      }, Spacings -> {2, 2}]  (* Spaziatura tra le due colonne della griglia *)
    ],

    {{angolo, 0,  (* Controllo associato alla variabile 'angolo', inizializzato a 0 gradi *)
      Column[{  (* Etichette descrittive dello slider *)
        "ANGOLO DI ROTAZIONE", 
        "(0 gradi = originale, 90 gradi = ruota a destra)", 
        "(180 gradi = sottosopra, 360 gradi = giro completo)"
      }]},
     0, 360, 1,  (* Range da 0 a 360, passo 1 grado *)
     Appearance -> "Labeled"  (* Mostra il valore numerico accanto allo slider *)
    },

    Delimiter,  (* Inserisce una linea di separazione visiva tra i controlli *)

    Panel[  (* Crea un riquadro che contiene i pulsanti per angoli preimpostati *)
      Row[{  (* Row impila orizzontalmente gli elementi *)
        Style["ANGOLI RAPIDI:", Bold, 12, Darker[Blue]], Spacer[10],
        Button["0 gradi", angolo = 0, Tooltip -> "Riporta all'originale"],
        Button["30 gradi", angolo = 30, Tooltip -> "Rotazione 30 gradi destra"],
        Button["45 gradi", angolo = 45, Tooltip -> "Diagonale principale"],
        Button["60 gradi", angolo = 60, Tooltip -> "Rotazione ampia destra"],
        Button["90 gradi", angolo = 90, Tooltip -> "Rotazione completa destra"],
        Button["180 gradi", angolo = 180, Tooltip -> "Immagine capovolta"],
        Button["270 gradi", angolo = 270, Tooltip -> "Rotazione sinistra"],
        Button["360 gradi", angolo = 360, Tooltip -> "Giro completo"]
      }, Spacer[5]],  (* Spaziatura tra i bottoni *)
      Background -> Lighter[Yellow, 0.8]  (* Sfondo giallo chiaro per visibilità *)
    ]
  ]
]

(* Funzione per la riflessione dell'immagine *)
riflessione[] := Module[{},  (* Module serve a isolare le variabili locali e strutturare l'interfaccia in modo indipendente *)

  Manipulate[  (* Manipulate genera automaticamente un’interfaccia utente interattiva basata sul valore della variabile 'asse' *)

    Module[{img, riflessa, matrice},  (* Definizione delle variabili locali: immagine originale, versione riflessa e matrice della trasformazione *)

      img = ExampleData[{"TestImage", "House"}];  
      (* Carica un'immagine standard di test, in questo caso una casa, utilizzata come esempio *)

      {riflessa, matrice} = If[asse == "X",  (* Costrutto If valuta la condizione specificata e restituisce uno dei due blocchi a seconda del valore di 'asse' *)

        (* Se asse è "X", si esegue una riflessione verticale (rispetto all'asse X, quindi sopra/sotto) *)
        {ImageReflect[img, Top], {{1, 0}, {0, -1}}},

        (* Altrimenti, riflessione orizzontale (rispetto all'asse Y, cioè sinistra/destra) *)
        {ImageReflect[img, Left], {{-1, 0}, {0, 1}}}
      ];  
      (* Viene restituita una coppia: l'immagine riflessa e la matrice di trasformazione associata *)

      Grid[{  (* Grid organizza il layout come una griglia. Qui si usa una riga con due colonne *)
        {
          riflessa,  (* Prima colonna: visualizza l'immagine dopo la riflessione *)

          Column[{  (* Seconda colonna: elementi descrittivi e analitici *)
            Panel[  (* Panel crea un contenitore incorniciato con sfondo personalizzato *)
              Column[{  (* Column impila verticalmente gli elementi testuali *)
                Style["RIFLESSIONE", Bold, 20, Darker[Blue]],  (* Titolo con stile formattato *)
                Style["Seleziona l'asse di simmetria:", 15],  (* Istruzioni  per l'utente *)
                "(X = Ribalta verticalmente)",
                "(Y = Ribalta orizzontalmente)"
              }],
              Background -> Lighter[Gray, 0.9]  (* Sfondo grigio chiaro per migliorare la leggibilità *)
            ],
            Spacer[10],  (* Inserisce uno spazio verticale tra il pannello e gli elementi successivi *)

            Style["Matrice della Riflessione", Bold],  (* Intestazione descrittiva per la matrice *)
            MatrixForm[matrice]  (* Visualizza la matrice della trasformazione in modo leggibile *)
          }]
        }
      }, Spacings -> 2]  (* Spaziatura tra gli elementi della griglia *)
    ],

    {{asse, "X",  (* Controllo interattivo: variabile inizializzata a \"X\" *)
      Column[{  (* Testo descrittivo accanto al menu *)
        "SELEZIONA ASSE:", 
        "(X = Ribalta sinistra/destra)", 
        "(Y = Ribalta sopra/sotto)"
      }]
    }, {"X", "Y"}}  (* Valori possibili per la variabile 'asse': \"X\" o \"Y\" *)
  ]
]

(* Funzione per il ridimensionamento dell'immagine *)
scala[] := Module[{},  (* Module crea un contenitore con ambito locale. Anche se qui non si inizializzano variabili, serve a contenere la Manipulate *)

  Manipulate[  (* Manipulate genera un'interfaccia utente interattiva: al variare di 'sx' e 'sy', tutto viene aggiornato automaticamente *)

    Module[{img, scalata, matrice, det, unitSquare, transformedSquare, warning, plotRange},
      (* Dichiarazione di variabili locali usate nella trasformazione e nella visualizzazione *)

      img = ExampleData[{"TestImage", "House"}];  
      (* Carica una delle immagini di esempio disponibili in Mathematica *)

      scalata = ImageResize[img, Scaled[{sx, sy}]];  
      (* Ridimensiona l'immagine in base ai due fattori di scala sx e sy. 
         La funzione Scaled prende un vettore con proporzioni rispetto all’originale *)

      matrice = {{sx, 0}, {0, sy}};  
      (* Matrice di scala che descrive una trasformazione diagonale. sx agisce su X, sy su Y *)

      det = sx * sy;  
      (* Determinante della matrice di scala: misura il fattore di ingrandimento dell'area *)

      unitSquare = Polygon[{{0, 0}, {1, 0}, {1, 1}, {0, 1}}];  
      (* Costruisce un quadrato unitario con vertici nei punti standard del piano cartesiano *)

      transformedSquare = GeometricTransformation[unitSquare, ScalingTransform[{sx, sy}]];  
      (* Applica la trasformazione di scala al quadrato unitario per mostrarne visivamente l'effetto *)

      plotRange = {{-0.5, Max[1.5, sx + 0.5]}, {-0.5, Max[1.5, sy + 0.5]}};  
      (* Definisce i limiti del grafico in modo dinamico, per adattarsi a sx/sy *)

      warning = Which[  (* Costrutto che valuta condizioni multiple e restituisce messaggi visivi *)
        det == 0, Style["ATTENZIONE: Immagine appiattita!", Red, Bold],
        det < 0.1, Style["Attenzione: Distorsione estrema!", Orange, Bold],
        True, ""
      ];

      Grid[{{  (* Grid crea una riga con due colonne principali: immagine e descrizione *)
        scalata,  (* Colonna sinistra: mostra l'immagine ridimensionata *)

        Column[{  (* Colonna destra con info testuali e visuali *)
          Panel[Column[{  (* Panel evidenzia le istruzioni, racchiuse in una Column *)
            Style["ISTRUZIONI:", Bold, 20, Darker[Blue]], (* Titolo con stile *)
            Style["1. Regola i fattori di scala X e Y", 15], 
            Style["2. 1 = dimensione originale", 15],
            Style["3. <1 = rimpicciolisci", 15],
            Style["4. >1 = ingrandisci", 15],
            Style["5. La matrice mostra la trasformazione", 15]
          }], Background -> Lighter[Gray, 0.9]],

          Spacer[10],  (* Spazio verticale per separare il pannello dal resto *)

          Style["Matrice di Scala", Bold],  
          MatrixForm[matrice],  (* Mostra la matrice in modo leggibile *)

          Style["Fattore di Ingrandimento (Determinante): " <> ToString[det], Bold, Darker[Green]],  
          warning,  (* Mostra eventuali messaggi di avviso *)

          Graphics[{  (* Mostra il quadrato originale e quello trasformato *)
            {EdgeForm[Black], LightBlue, unitSquare},  (* Quadrato originale blu con bordo nero *)
            {EdgeForm[{Thick, Red}], Opacity[0.5], Red, transformedSquare},  (* Quadrato trasformato rosso semi-trasparente *)

            Text[Style["1", 12], {0.5, -0.1}],  (* Etichette asse X originali *)
            Text[Style["1", 12], {-0.1, 0.5}],  (* Etichette asse Y originali *)

            Text[Style[ToString[sx], 12, Red], {sx/2, -0.1}],  (* Valore della nuova base X *)
            Text[Style[ToString[sy], 12, Red], {-0.1, sy/2}],  (* Valore della nuova base Y *)

            Gray, Dashed, Line[{{0, sy}, {sx, sy}}], Line[{{sx, 0}, {sx, sy}}],  
            (* Linee guida diagonali nel quadrato trasformato *)

            Axes -> True,  (* Mostra gli assi cartesiani *)
            PlotLabel -> Style["Trasformazione Geometrica", 14],  
            ImageSize -> 300, PlotRange -> plotRange  (* Imposta dimensione e limiti grafico *)
          }]
        }, Alignment -> Center]  (* Centra il contenuto della colonna *)
      }}, Spacings -> 3]  (* Spaziatura tra immagine e colonna descrittiva *)
    ],

    {{sx, 1, "Scala Orizzontale (X)"}, 0.0, 1.5, 0.1,  
     (* Slider per controllare il fattore di scala orizzontale: va da 0.0 a 1.5 con passo 0.1 *)
     Appearance -> "Labeled", ImageSize -> Small  (* Mostra il valore accanto allo slider *)
    },

    {{sy, 1, "Scala Verticale (Y)"}, 0.0, 1.5, 0.1,  
     (* Slider per controllare il fattore di scala verticale *)
     Appearance -> "Labeled", ImageSize -> Small
    },

    Delimiter,  (* Linea di separazione visiva *)

    Panel[Row[{  (* Pannello con bottoni di preset rapidi *)
      Style["PRESET:", Bold, 12, Darker[Blue]], Spacer[10],
      Button["1:1", {sx = 1, sy = 1}, Tooltip -> "Ripristina dimensioni originali"],
      Button["1.5:1", {sx = 1.5, sy = 1}, Tooltip -> "50% piu' largo"],
      Button["1:1.5", {sx = 1, sy = 1.5}, Tooltip -> "50% piu' alto"],
      Button["0.5:1", {sx = 0.5, sy = 1}, Tooltip -> "Meta' larghezza"],
      Button["1:0.5", {sx = 1, sy = 0.5}, Tooltip -> "Meta' altezza"]
    }], Background -> Lighter[Yellow, 0.8]]  (* Sfondo per distinguere visivamente la sezione preset *)
  ]
]


(* Interfaccia utente combinata per tutte le trasformazioni *)
bUI[] := Column[{  (* Column organizza verticalmente gli elementi elencati: titolo + 3 interfacce *)

  Style["Rotazione", Bold, 14],  (* Titolo per la sezione della rotazione, formattato in grassetto e font size 14 *)
  rotazione[],                   (* Richiama la funzione che genera l'interfaccia per la rotazione dell'immagine *)

  Style["Riflessione", Bold, 14],  (* Titolo per la sezione della riflessione *)
  riflessione[],                   (* Richiama la funzione che genera l'interfaccia per la riflessione dell'immagine *)

  Style["Scala", Bold, 14],        (* Titolo per la sezione del ridimensionamento *)
  scala[]                          (* Richiama la funzione che genera l'interfaccia per la scala dell'immagine *)

}]


(* ============================== SEZIONE C ============================== *)

ClearAll[cUI]  
(* Pulisce ogni definizione precedente della funzione cUI, utile per evitare conflitti o risultati obsoleti *)

cUI[] :=  (* Definisce la funzione cUI senza parametri *)
 Deploy @  (* Deploy impedisce modifiche accidentali all’interfaccia grafica da parte dell’utente *)
 Module[

  {
    (* Variabili locali usate nel modulo -------------------------------------- *)
    imageDisplaySize  = 300,   (* Dimensione in pixel per la visualizzazione dell'immagine principale *)
    neighborhoodDisplaySize = 250  (* Dimensione per la visualizzazione del vicinato dei pixel *)
  },

  (* Layout principale dell’interfaccia, strutturato verticalmente ----------- *)
  Column[{

    (* ======= 1. Intestazione dell'esercizio ================================ *)
    Style["Esempio interattivo 3: Sfocatura con Kernel (Box Blur)", Bold, 14],  
    (* Titolo con stile in grassetto e font size 14 *)

    Spacer[5],  (* Piccolo spazio verticale di separazione *)

    Text @ Column[{  (* Blocco descrittivo con spiegazioni su come usare l'interfaccia *)
      "Come funziona:",  (* Introduzione alle istruzioni *)
      " - Muovi lo slider per cambiare la dimensione del kernel (3, 5, 7, 9).",  
      " - Clicca sull'immagine originale per scegliere il pixel centrale (non serve trascinare).",  
      " - L'immagine sfocata a destra si aggiorna automaticamente.",  
      " - Il pannello in basso mostra il vicinato e il valore calcolato."
    }],

    Spacer[10],  (* Altro spazio verticale per separare le sezioni *)

    (* ======= 2. Area Interattiva: Slider + Immagini + Output =============== *)
    DynamicModule[{  (* DynamicModule crea uno scope locale e mantiene stato tra aggiornamenti *)
      kernelSize = 3,  (* Valore iniziale per la dimensione del kernel *)
      locatorPosition = {50, 50},  (* Posizione iniziale del puntatore rosso nell’immagine *)
      img = ExampleData[{"TestImage", "House"}]  (* Carica un'immagine di esempio integrata in Mathematica *)
    },

      Column[{  (* Colonna principale per organizzare gli elementi in verticale *)

        (* === 2a. Slider per la dimensione del kernel ======================= *)
        Slider[Dynamic[kernelSize], {3, 9, 2}, Appearance -> "Labeled", ImageSize -> Full],
        (* Slider che permette solo valori dispari (3,5,7,9) con etichetta visiva *)

        Spacer[5],  (* Spazio verticale *)

        (* === 2b. Parte dinamica: convoluzione e interfaccia grafica ======== *)
        DynamicModule[{ imageDimensions = ImageDimensions[img] },
        (* Cattura le dimensioni dell’immagine una sola volta all’avvio *)

          Dynamic[  (* Blocca che si aggiorna automaticamente se kernelSize o locatorPosition cambiano *)
            Module[{
              (* Variabili locali interne al blocco dinamico ---------------- *)
              kSize, kernel, locX, locY, imageData,
              neighborhood, convolvedValue, padding, blurredImg,
              originalImgWithRect
            }, (* Dichiarazione delle variabili locali per la convoluzione e visualizzazione *)

              (* ========== Trasformazione dell'immagine ===================== *)

              (* Pre-calcoli della trasformazione -------------------------- *)
              kSize = kernelSize;  (* Copia del valore corrente del kernel *)
              kernel = ConstantArray[1 / kSize^2, {kSize, kSize}];  
              (* Crea una matrice uniforme: tutti i valori uguali, somma = 1 *)

              locX = Round[locatorPosition[[1]]];  (* Converte la coordinata X cliccata in indice *)
              locY = Round[imageDimensions[[2]] - locatorPosition[[2]] + 1];  
              (* Converte Y, invertendo l’asse (grafico -> matrice) *)

              imageData = ImageData[img];  (* Estrae la matrice RGB dei pixel *)
              padding = Floor[kSize / 2];  (* Raggio del kernel, serve per determinare il vicinato *)

              blurredImg = ImageResize[ImageConvolve[img, kernel], imageDisplaySize];  
              (* Applica la convoluzione e ridimensiona il risultato *)

              originalImgWithRect = Rasterize[  (* Visualizza il rettangolo sul pixel scelto *)
                Show[ (* Mostra l’immagine originale con il rettangolo rosso *)
                  img, 
                  Graphics[{ (* Grafica per il rettangolo rosso attorno al pixel scelto *)
                    Red, Thickness[0.01], (* Colore e spessore del bordo *)
                    (* Rectangle[ {x1, y1}, {x2, y2} ] disegna un rettangolo con i due angoli opposti *)
                    (* Le coordinate sono espresse in pixel, quindi non serve convertire *) 
                    Rectangle[ 
                      {locatorPosition[[1]] - kSize/2, locatorPosition[[2]] - kSize/2},  (* Calcola il vertice in basso a sinistra del rettangolo centrato sul pixel scelto *)
                      {locatorPosition[[1]] + kSize/2, locatorPosition[[2]] + kSize/2}  (* Calcola il vertice in alto a destra del rettangolo centrato sul pixel scelto *)  
                    ]
                  }]
                ],
                RasterSize -> imageDisplaySize  (* Specifica le dimensioni finali *)
              ];

              (* Estrazione del vicinato attorno al pixel scelto ------------ *)
              neighborhood = Table[
                imageData[[  (* Applica Clip per evitare di uscire dai bordi *)
                  Clip[locY + i - padding, {1, imageDimensions[[2]]}],  (* Calcola la coordinata Y limitata entro i bordi immagine, evitando indici fuori scala *)
                  Clip[locX + j - padding, {1, imageDimensions[[1]]}]   (* Calcola la coordinata Y limitata entro i bordi immagine, evitando indici fuori scala *)
                ]],
                {i, 1, kSize}, {j, 1, kSize}
              ];

              convolvedValue = Total[Flatten[neighborhood * kernel]];  
              (* Moltiplica elemento per elemento e somma: valore del pixel sfocato *)

              (* ========== Layout visivo dei risultati ===================== *)
              Column[{

                (* === Immagini principali e kernel ======================== *)
                Row[{

                  Column[{  (* Colonna: immagine originale *)
                    Style["Immagine originale", Bold],
                    LocatorPane[
                      Dynamic[locatorPosition],  (* Permette di cliccare sull’immagine *)
                      Image[originalImgWithRect, ImageSize -> imageDisplaySize],
                      LocatorShape -> Graphics[{Circle[{0, 0}, 5]}]  (* Indicatore rosso *)
                    ]
                  }],

                  Spacer[20],  (* Spazio tra le immagini *)

                  Column[{  (* Colonna: immagine sfocata *)
                    Style["Immagine sfocata", Bold],  (* Intestazione in grassetto per la sezione che mostra l'immagine convoluta *)
                    Image[blurredImg, ImageSize -> imageDisplaySize]  (* Mostra l'immagine sfocata ottenuta tramite convoluzione con kernel *)
                  }],

                  Spacer[20],  (* Spazio tra le colonne *)

                  Column[{  (* Colonna: visualizza il kernel *)
                    Style["Kernel " <> ToString[kSize] <> " x " <> ToString[kSize], Bold],
                    MatrixForm[kernel]  (* Mostra la matrice in formato leggibile *)
                  }]

                }, Alignment -> Top],  (* Allinea verticalmente in alto le tre colonne *)

                Spacer[10],
                Style[StringRepeat["-", 60], Gray],  (* Linea divisoria grigia *)
                Spacer[5],

                (* === Dettagli locali: visualizzazione del vicinato ========= *)
                Style["Dettagli locali", Bold], (* Intestazione in grassetto per la sezione che mostra il vicinato *)
                Row[{
                  Style["Neighborhood: ", Bold], (* Intestazione per la matrice del vicinato *)
                  Image[ 
                    ImageResize[Image[neighborhood], neighborhoodDisplaySize],  (* Crea un’immagine dal vicinato e la ridimensiona alla dimensione desiderata *)
                    ImageSize -> neighborhoodDisplaySize  (* Imposta la dimensione finale dell’immagine del vicinato nella GUI *)

                  ]
                }]
              }]
            ]
          ]
        ]
      }]
    ]
  }]
];



aUIButton[] :=  (* Definisce la funzione UIButton senza parametri: crea un'interfaccia iniziale con bottone *)
 Deploy @  (* Impedisce all’utente di modificare l’interfaccia generata, rendendola solo visualizzabile *)
 DynamicModule[{content = None},  (* Inizializza la variabile locale 'content', vuota fino al primo click *)
   Column[{  (* Organizza verticalmente il pulsante e il contenuto caricato *)
   
     Framed[  (* Inserisce il pulsante in una cornice decorativa *)
       Deploy @ Button[  (* Crea un pulsante che al click assegna aUI[] alla variabile content *)
         Style["Avvia esempio interattivo", 16, Bold, Darker @ Blue],  (* Testo del pulsante con stile visivo *)
         content = aUI[],  (* Azione eseguita al click: carica e assegna l'interfaccia interattiva aUI[] *)
         ImageSize   -> {280, 55},  (* Dimensione del pulsante: larghezza 280px, altezza 55px *)
         Appearance  -> "Frameless"  (* Rimuove il bordo standard del pulsante per un look personalizzato *)
       ],
       Background     -> LightYellow,  (* Colore di sfondo della cornice del pulsante *)
       FrameStyle     -> Directive[Thick, Gray],  (* Bordo grigio spesso attorno al pulsante *)
       RoundingRadius -> 10,  (* Angoli arrotondati per la cornice *)
       FrameMargins   -> 10  (* Margine interno tra cornice e contenuto *)
     ],
     
     Spacer[20],  (* Spazio verticale tra il pulsante e il contenuto caricato *)
     
     Dynamic[ If[content === None, "", content] ]  (* Mostra aUI[] solo dopo il click: se 'content' è vuoto, non mostra nulla *)
   }]
 ];


bUIButton[] :=  (* Definisce la funzione bUIButton senza argomenti: crea l’interfaccia con pulsante per avviare bUI[] *)
 Deploy @  (* Impedisce modifiche da parte dell’utente all’interfaccia grafica generata *)
 DynamicModule[{content = None},  (* Crea una variabile locale 'content' che inizialmente è vuota *)
   Column[{  (* Dispone verticalmente pulsante e contenuto *)

     Framed[  (* Crea una cornice attorno al pulsante per evidenziarlo graficamente *)
       Deploy @ Button[  (* Genera un pulsante che all’attivazione esegue bUI[] e lo assegna a 'content' *)
         Style["Avvia esempio interattivo", 16, Bold, Darker @ Blue],  (* Stile grafico del testo del pulsante *)
         content = bUI[],  (* Azione eseguita al click: genera e memorizza l’interfaccia bUI[] *)
         ImageSize   -> {280, 55},  (* Imposta le dimensioni del pulsante *)
         Appearance  -> "Frameless"  (* Elimina la cornice standard del pulsante per un aspetto personalizzato *)
       ],
       Background     -> LightYellow,  (* Colore di sfondo della cornice del pulsante *)
       FrameStyle     -> Directive[Thick, Gray],  (* Stile della cornice: grigia e spessa *)
       RoundingRadius -> 10,  (* Angoli arrotondati per un aspetto più moderno *)
       FrameMargins   -> 10  (* Spazio interno tra bordo e contenuto della cornice *)
     ],

     Spacer[20],  (* Aggiunge spazio verticale tra pulsante e contenuto *)

     Dynamic[ If[content === None, "", content] ]  (* Mostra bUI[] solo dopo il click sul pulsante, altrimenti resta vuoto *)
   }]
 ];


cUIButton[] :=  (* Definisce la funzione cUIButton che genera l'interfaccia con pulsante per attivare cUI[] *)
 Deploy @  (* Impedisce all'utente di modificare l'interfaccia generata rendendola statica *)
 DynamicModule[{content = None},  (* Inizializza la variabile locale 'content' che conterrà cUI[] dopo il click *)
   Column[{  (* Dispone verticalmente il pulsante e il contenuto caricato *)

     Framed[  (* Incornicia il pulsante con stile grafico definito *)
       Deploy @ Button[  (* Crea un pulsante che al click assegna cUI[] alla variabile 'content' *)
         Style["Avvia esempio interattivo", 16, Bold, Darker @ Blue],  (* Testo del pulsante con dimensione, colore e grassetto *)
         content = cUI[],  (* Azione al click: assegna a 'content' l'interfaccia interattiva generata da cUI[] *)
         ImageSize   -> {280, 55},  (* Imposta larghezza e altezza del pulsante *)
         Appearance  -> "Frameless"  (* Rimuove i bordi standard del pulsante per uno stile personalizzato *)
       ],
       Background     -> LightYellow,  (* Imposta lo sfondo giallo chiaro alla cornice del pulsante *)
       FrameStyle     -> Directive[Thick, Gray],  (* Bordo grigio spesso per evidenziare il pulsante *)
       RoundingRadius -> 10,  (* Arrotonda gli angoli della cornice per un aspetto più morbido *)
       FrameMargins   -> 10  (* Aggiunge margine interno tra bordo e pulsante *)
     ],

     Spacer[20],  (* Inserisce uno spazio verticale tra il pulsante e il contenuto *)

     Dynamic[ If[content === None, "", content] ]  (* Visualizza cUI[] solo dopo il click; altrimenti non mostra nulla *)
   }]
 ];
 


esUIButton[] :=  (* Definisce la funzione esUIButton che genera l'interfaccia con pulsante e gestione seed *)
 Deploy@  (* Rende l'interfaccia non modificabile interattivamente dall'utente *)

  DynamicModule[{content = None},  (* Modulo dinamico con variabile locale 'content' inizialmente nulla *)
   Column[{  (* Disposizione verticale degli elementi: pulsante + contenuto *)

     Framed[  (* Inserisce una cornice attorno al pulsante *)
      Button[  (* Crea un pulsante che avvia l'interfaccia esercizio *)

       Style["Avvia esercizio interattivo", 16, Bold, Darker@Blue],  (* Stile del testo del pulsante: grande, grassetto, blu scuro *)

       Module[{seed},  (* Blocco eseguito al click: inizializza la variabile locale 'seed' *)

        seed = DialogInput[  (* Apre un dialogo modale per inserire il seed *)
            DynamicModule[{s = RandomInteger[{1, 9999}]},  (* Inizializza il campo con un numero casuale tra 1 e 9999 *)

            Panel[  (* Crea un pannello grafico contenente gli elementi del dialogo *)
              Column[{  (* Disposizione verticale dei componenti del pannello *)

                Style["Personalizzazione esercizio con Seed", 18, Bold, Darker@Gray],  (* Titolo in grigio scuro e grassetto *)

                Style[  (* Testo descrittivo sull’uso del seed *)
                "Inserisci un numero intero che fungerà da 'seed': questo valore determinerà la generazione casuale dell'esercizio, rendendolo ripetibile e controllabile.",
                12, GrayLevel[0.3], LineSpacing -> 1.5],  (* Stile del testo: piccolo, grigio chiaro, con interlinea *)

                Item[  (* Campo di input centrato *)
                InputField[Dynamic[s], Number, FieldSize -> 12],  (* Input numerico legato dinamicamente alla variabile s *)
                Alignment -> Center  (* Centra il campo nella riga *)
                ],

                Spacer[15],  (* Spazio verticale tra input e pulsanti *)

                Row[{  (* Riga con i pulsanti Annulla e Invio *)

                  Button["Annulla",  (* Pulsante per annullare l'inserimento del seed *)
                  DialogReturn[None],  (* Chiude il dialogo restituendo None *)
                  ImageSize -> {130, 40},  (* Dimensioni del pulsante *)
                  Appearance -> {"Cancel", "DialogBox"},  (* Aspetto standard da dialogo di sistema *)
                  BaseStyle -> {12}  (* Font size del testo nel pulsante *)
                  ],

                  Spacer[20],  (* Spazio orizzontale tra i due pulsanti *)

                  Button["Invio",  (* Pulsante per confermare il valore del seed *)
                  DialogReturn[s],  (* Chiude il dialogo restituendo il valore attuale di s *)
                  ImageSize -> {130, 40},  (* Dimensioni del pulsante *)
                  Appearance -> {"Default", "DialogBox"},  (* Aspetto del pulsante principale *)
                  BaseStyle -> {Bold, 12}  (* Stile grassetto e font size del testo *)
                  ],

                }, Alignment -> Center]  (* Centra i pulsanti nella riga *)
              },
              Spacings -> 2  (* Imposta la spaziatura verticale tra gli elementi della Column *)
              ],
              Background -> White,  (* Imposta sfondo bianco del pannello *)
              FrameMargins -> 20,  (* Margine interno attorno al contenuto del pannello *)
              AppearanceElements -> {"CloseBox"},  (* Aggiunge il pulsante di chiusura nella finestra di dialogo *)
              ImageSize -> 400  (* Imposta la dimensione fissa del pannello in pixel *)
            ]
            ]
          ];  (* Fine del DialogInput: il valore restituito viene assegnato a 'seed' *)

        Which[  (* Controlla il valore ottenuto dal dialogo *)

         seed === None,  (* Se l’utente ha cliccato Annulla *)
          2+2 == 4,  (* Esegue operazione neutra: non cambia nulla *)

         ! IntegerQ[seed],  (* Se il valore ottenuto non è un intero *)
          MessageDialog["Seed non valido. Inserisci un intero."],  (* Mostra un messaggio di errore *)

         True,  (* In tutti gli altri casi *)
          content = esUI[seed]  (* Genera l'interfaccia esUI[] con il seed ottenuto *)
        ]
       ],  (* Fine del blocco Module eseguito al click del pulsante *)

       ImageSize    -> {280, 55},  (* Imposta larghezza e altezza del pulsante principale *)
       Appearance   -> "Frameless",  (* Rimuove la cornice standard del pulsante *)
       Method       -> "Queued"  (* Specifica che l'azione deve essere eseguita in coda: evita blocchi dell’interfaccia *)
      ] // Deploy,  (* Protegge anche il pulsante da modifiche dirette dell’utente *)

      Background     -> LightYellow,  (* Sfondo giallo chiaro della cornice del pulsante *)
      FrameStyle     -> Directive[Thick, Gray],  (* Bordo grigio spesso *)
      RoundingRadius -> 10,  (* Angoli arrotondati della cornice *)
      FrameMargins   -> 10  (* Margine interno tra bordo e contenuto *)
     ],

     Spacer[20],  (* Spazio verticale tra il pulsante e l’interfaccia interattiva *)

     Dynamic[If[content === None, "", content]]  (* Mostra il contenuto solo dopo la generazione dell’interfaccia esUI[] *)
    }]
  ]


(* ============================== SEZIONE ESERCIZIO ============================== *)

(* Troncamento a 4 decimali *)
Tronca4[x_] := N[Floor[x*10^4]/10.^4]

(* UI dell’esercizio, prende direttamente il seed intero *)
esUI[seed_Integer] := Grid[{
  {es[seed], Spacer[50], SenCosCalcUI[]}
},
Alignment -> {Top, Top}
]


(* Interfaccia utente orizzontale, senza grafico *)
SenCosCalcUI[] :=
 DynamicModule[{theta = 0, input = "0", errMsg = "", sinVal = "", cosVal = "", calculated = False},
  Panel[
   Column[{
     Style["Calcolatore Seno/Coseno", 24, FontFamily -> "Arial", Bold],
     Spacer[20],
     Grid[{
       {
        Style["Angolo in gradi", 16],
        InputField[
          Dynamic[input],  Number,
         FieldSize -> 8,
         FrameMargins -> 5,
         Background -> LightGray,
         ContinuousAction -> False,
         ImageSize -> 100]
       },
       {
        Button[
          Style["Calcola", Bold, 12, Black],
          Module[{val = Quiet@Check[ToExpression[input], $Failed]},
            If[NumericQ[val],
              theta = val;
              errMsg = "";
              sinVal = ToString[NumberForm[N[Sin[theta Degree]], {5, 4}]];
              cosVal = ToString[NumberForm[N[Cos[theta Degree]], {5, 4}]];
              calculated = True;,
              errMsg = "Inserisci un numero valido!";
              sinVal = cosVal = "";
              calculated = False;
            ];
          ],
          Appearance -> {"DialogBox"},
          ImageSize -> {130, 25},
          BaseStyle -> {FontFamily -> "Helvetica"}
        ]
       }
      }, Spacings -> {2, 3}],
     Spacer[20],
     Dynamic[
      Which[
       errMsg =!= "", Style[errMsg, 14, Bold, FontColor -> Red],
       !calculated, "",
       True,
       Grid[{
         {Style["Seno:", 16], Style[sinVal, 16, FontColor -> Darker[Green]]},
         {Style["Coseno:", 16], Style[cosVal, 16, FontColor -> Darker[Orange]]}
       }, Spacings -> {2, 2}, Alignment -> Left]
      ]
     ]
    }, Spacings -> 2],
   FrameMargins -> 20,
   RoundingRadius -> 10,
   FrameStyle -> Directive[GrayLevel[0.8], Thick]
  ]
 ]

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
                  Style["< Precedente", Bold, 12, Gray],
                  If[index > 1,
                    index--;
                    userMatrix = ConstantArray[0, {2, 2}];
                    resultText = "";
                    userImage = img
                  ],
                  Appearance -> {"DialogBox"},
                  ImageSize -> {110, 25},
                  BaseStyle -> {FontFamily -> "Helvetica"}
                ],

                (* Pulsante: mostra la matrice corretta dell'esercizio corrente *)
                Button[
                  Style["Suggerimento", Bold, 12, Black],
                  CreateDialog[
                    Panel[
                      Column[{
                        Style["Matrice della trasformazione corrente", Bold, 14, Darker@Gray],
                        Spacer[10],
                        Framed[
                          Style[MatrixForm[transformations[[index, 2]]], 14, Black],
                          FrameStyle -> LightGray,
                          Background -> GrayLevel[0.97],
                          RoundingRadius -> 5,
                          FrameMargins -> 10
                        ],
                        Spacer[15],
                        DefaultButton[]
                      }, Spacings -> 1.5],
                      BaseStyle -> {FontFamily -> "Helvetica", FontSize -> 12}
                    ],
                    WindowTitle -> "Suggerimento",
                    WindowSize -> {300, 300},
                    Background -> White
                  ],
                  Appearance -> {"DialogBox"},
                  ImageSize -> {130, 25},
                  BaseStyle -> {FontFamily -> "Helvetica"}
                ],

                (* Pulsante: passa all'esercizio successivo *)
                Button[
                  Style["Successivo >", Bold, 12, Gray],
                  If[
                    index < 5,
                    index++;
                    userMatrix = ConstantArray[0, {2, 2}];
                    resultText = "";
                    userImage = img
                  ],
                  Appearance -> {"DialogBox"},
                  ImageSize -> {110, 25},
                  BaseStyle -> {FontFamily -> "Helvetica"}
                ],
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
            InputField[Dynamic[userMatrix[[1, 1]]], Number, FieldSize -> 6],
            InputField[Dynamic[userMatrix[[1, 2]]], Number, FieldSize -> 6]
          },
          {
            InputField[Dynamic[userMatrix[[2, 1]]], Number, FieldSize -> 6],
            InputField[Dynamic[userMatrix[[2, 2]]], Number, FieldSize -> 6]
          }
        }, Spacings -> {1, 1}],

        Spacer[5],

        (* Verifica e output *)
        DynamicModule[{},
          Column[{

            (* Pulsante "Verifica" che controlla se la matrice inserita è corretta *)
            Button[
              Style["Verifica", Bold, 12, Black],
              Module[
                {
                  isCorrect,
                  matrixFun
                },
                isCorrect = userMatrix === transformations[[index, 2]];
                resultText = If[isCorrect, "Corretto!", "Sbagliato!"];
                matrixFun = Function[p, center + userMatrix . (p - center)];
                userImage = ImageTransformation[
                  img, matrixFun, DataRange -> Full, Resampling -> "Linear"
                ];
              ],
              Appearance -> {"DialogBox"},
              ImageSize -> {400, 35},
              BaseStyle -> {FontFamily -> "Helvetica"}
            ]


            Spacer[10],

            (* Mostra dinamicamente il risultato e la trasformazione utente *)
            Dynamic[
              If[resultText =!= "",
                Column[{
                  Spacer[10],
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
                TrackedSymbols :> {resultText, userImage}
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