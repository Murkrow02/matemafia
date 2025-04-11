BeginPackage["ScacchieraInterattiva`"]

aUI::usage = 
  "ScacchieraInterattiva[] lancia un'interfaccia interattiva in cui l'utente può modificare una matrice 8×8 con valori in [0, 255]. \
La cella cliccata permette l'inserimento di un nuovo valore (se valido) e la parte inferiore mostra l'immagine corrispondente."

Begin["`Private`"]

aUI[] := DynamicModule[{matrice},
  (* Inizializza la matrice con un valore medio, ad esempio 127 *)
  matrice = ConstantArray[127, {8, 8}];
  
  Column[{
    Style["Modifica la matrice cliccando sulle celle:", Bold, 14],
    Dynamic@
      Grid[
        Table[
          With[{i = i, j = j},
            Button[
              Dynamic[matrice[[i, j]]],
              Module[{nuovoValore},
                nuovoValore = Quiet[
                  Input["Inserisci un valore intero per la cella (" <> ToString[i] <> ", " <> ToString[j] <> "):", 
                    matrice[[i, j]]]
                ];
                (* Controlla se il valore inserito è un intero e rientra nel range [0,255] *)
                If[IntegerQ[nuovoValore] && 0 <= nuovoValore <= 255,
                  matrice[[i, j]] = nuovoValore
                ]
              ],
              ImageSize -> {40, 40},
              (* Imposta lo sfondo in scala di grigi *)
              Background -> Dynamic[GrayLevel[matrice[[i, j]]/255]],
              (* Un bordo per enfatizzare la cella *)
              FrameMargins -> 2,
              FrameStyle -> Gray
            ]
          ],
          {i, 8}, {j, 8}
        ],
        Alignment -> Center,
        Spacings -> {2, 2}
      ],
    Spacer[15],
    Style["Immagine generata dalla matrice:", Bold, 14],
    Dynamic[
      (* Usa Image con il formato "Byte" che interpreta i valori da 0 a 255 *)
      Image[matrice, "Byte", ImageSize -> 300]
    ]
  },
  Alignment -> Center,
  Spacings -> 10]
]

End[]

EndPackage[]

