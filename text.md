@ -0,0 +1,230 @@

SetOptions[$FrontEnd, IgnoreSpellCheck -> True]

# Introduzione

Benvenuti in questo percorso didattico, pensato per accompagnarvi alla scoperta di come le immagini digitali possano essere interpretate e manipolate attraverso il concetto di **matrice**. Se avete gia' utilizzato le matrici in ambito matematico, troverete molti punti di contatto: un'immagine al computer altro non e' che una griglia di numeri, dove ogni valore corrisponde a un **pixel** (o, nel caso di immagini a colori, a un insieme di valori di canale).

L'idea di **"immagine come matrice"** e' sorprendentemente potente, in quanto ci permette di:

- **Applicare trasformazioni lineari** come rotazioni, riflessioni e deformazioni, esattamente come si fa con i vettori.
- **Modificare le caratteristiche visive** dell'immagine (luminosita', contrasto, colore) intervenendo sui valori numerici della matrice.
- **Creare e comprendere filtri** come sfocatura, nitidezza o rilevamento bordi, utilizzando operazioni di convoluzione tra matrici.

In altre parole, capire come un computer "vede" un'immagine ci aiuta a utilizzare strumenti di grafica e fotografia in maniera piu' consapevole. Questo percorso e' diviso in tre parti:

1. **Fondamenti di immagini raster**  
   (Cos'e' un'immagine raster? Qual e' la differenza tra scala di grigi e RGB?)
2. **Trasformazioni lineari su immagini**  
   (Come ruotare, riflettere, ridimensionare una griglia di pixel?)
3. **Convoluzioni e filtri**  
   (Perché i filtri possono essere visti come piccole matrici che "camminano" sull'immagine?)

---

# Parte A: Fondamenti di Immagini Raster

## 1. Cos'e' un'immagine raster

Le immagini digitali piu' comuni – come fotografie, screenshot o illustrazioni – sono quasi sempre basate su un modello **raster**. Questo significa che l'immagine e' composta da una griglia rettangolare di **pixel**. Ogni pixel e' una cella della griglia che contiene uno o piu' valori numerici:

- **Se l'immagine e' in bianco e nero (scala di grigi)**, ogni pixel e' un singolo valore che esprime la luminosita'.
- **Se l'immagine e' a colori (RGB)**, ogni pixel contiene piu' valori, uno per ciascun canale di colore (Rosso, Verde e Blu).

In termini matematici, potete pensare a un'immagine come a una **matrice** (o, in caso di immagini a colori, a una "matrice di matrici") le cui dimensioni corrispondono alla **risoluzione** dell'immagine. Ad esempio, un'immagine di 800 × 600 pixel puo' essere vista come una tabella di 600 righe e 800 colonne; ogni cella della tabella corrisponde a un singolo pixel.

### Esempio intuitivo
Immaginate una **scacchiera**: ogni casella e' nera o bianca. Se rappresentiamo il nero con il valore 0 e il bianco con il valore 1, otteniamo una matrice di 0 e 1 che costruisce lo schema della scacchiera. Questa e', a tutti gli effetti, un'immagine raster semplificata in scala di grigi!

---

## 2. Differenza tra immagini in scala di grigi e immagini RGB

### 2.1 Immagini in scala di grigi

In una **scala di grigi**, ogni pixel e' descritto da un singolo numero. Spesso questi valori vanno da 0 a 255 (nel caso di un canale a 8 bit), dove:
- **0** rappresenta il nero (assenza di luminosita'),
- **255** rappresenta il bianco (massima luminosita'),
- i valori intermedi corrispondono a diverse sfumature di grigio.

Questa rappresentazione e' molto semplice e intuitiva: piu' alto e' il valore, piu' "chiaro" appare il pixel. In forma normalizzata, si puo' usare un intervallo da 0 a 1 con lo stesso significato di intensita'.

### 2.2 Immagini a colori (RGB)

Le immagini a colori comunemente usate nei computer seguono il modello **RGB**. In questo caso, ogni pixel e' un piccolo **vettore** di tre valori: *(R, G, B)*, uno per il canale **Rosso**, uno per il **Verde** e uno per il **Blu**. Ciascun canale puo' essere un numero che varia, ad esempio, tra 0 e 255:

- **(0, 0, 0)** → Nero (assenza di colore).
- **(255, 255, 255)** → Bianco (massima intensita' di tutti i colori).
- **(255, 0, 0)** → Rosso puro.
- **(0, 255, 0)** → Verde puro.
- **(0, 0, 255)** → Blu puro.

Combinando questi tre canali in proporzioni diverse, possiamo ottenere qualsiasi colore dello spettro visibile (entro i limiti di cio' che il monitor puo' riprodurre).

> *Curiosita'*: esistono altri formati di colore (come CMYK per la stampa, o modelli come HSV e Lab), ma l'RGB resta il piu' diffuso in ambito digitale.

---

## 3. Visualizzazione delle immagini con intensita' e colore

### 3.1 Come si passa dalla matrice all'immagine?

Quando aprite un'immagine al computer, un software legge la **matrice dei pixel** e traduce i valori numerici in colori visualizzati sullo schermo. Per un'immagine in scala di grigi, se un pixel ha valore 50 (su un intervallo 0-255), appare come un punto di grigio scuro; se vale 200, appare grigio chiaro, e così via.

Per un'immagine a colori, il software legge i tre valori *(R, G, B)* di ogni pixel e produce il colore corrispondente. Piu' e' alta la componente R rispetto a G e B, piu' il colore tende al rosso; se invece sono uguali, il colore si trova in qualche punto vicino al grigio o al bianco (se i valori sono alti).

### 3.2 Esempio pratico (mini-scacchiera)

Immaginate una **mini-scacchiera** di 4 × 4 pixel, dove le caselle bianche valgono 1 e quelle nere valgono 0. Possiamo scrivere la matrice così:

**mettere immagine scacchiera** 


Visualizzando questa matrice come un'immagine in scala di grigi (con 1 = bianco e 0 = nero), otterrete un pattern a scacchi di 4 × 4. Se fosse a colori, avreste una matrice per il canale rosso, una per il canale verde e una per quello blu.

---

## Conclusioni Parte A

- Un'immagine raster e' una **griglia di pixel**, e ogni pixel e' un valore (o un insieme di valori) che rappresenta un colore o un livello di grigio.
- Capire questa struttura e' fondamentale per poter poi **applicare trasformazioni** e **filtrare** le immagini usando operazioni matematiche.
- Anche per chi ha gia' familiarita' con l'algebra lineare, vedere un'immagine come una matrice apre un mondo di possibilita', poiché le stesse regole che valgono per i numeri e i vettori si applicano anche al "tessuto" dell'immagine.

Nelle prossime sezioni vedremo come utilizzare le proprieta' delle **matrici di trasformazione** per modificare la geometria di un'immagine (Parte B) e come impiegare le **convoluzioni** per applicare filtri ed effetti (Parte C).

---


# Parte B: Trasformazioni Lineari su Immagini

Dopo aver visto come le immagini digitali possano essere interpretate come matrici di valori, entriamo ora nel vivo di una delle applicazioni piu' interessanti di questa prospettiva: **le trasformazioni lineari**. Queste operazioni – che in algebra lineare si applicano a vettori e matrici – possono essere utilizzate anche per modificare la **geometria di un'immagine**.

Le trasformazioni lineari includono operazioni come **rotazione**, **riflessione**, **ridimensionamento** e **deformazione**. Ogni volta che ruotate una foto di 90° sul vostro smartphone o che specchiate un'immagine per ottenere un effetto "flip", state di fatto agendo come un piccolo "matematico" che applica una matrice di trasformazione!

---

## 1. Concetto di Trasformazione Lineare

In algebra lineare, una **trasformazione lineare** T su uno spazio vettoriale e' una funzione che prende in input un vettore (x) e lo mappa in un altro vettore (y), rispettando due proprieta' fondamentali:

1. **Additivita'**: T(x + z) = T(x) + T(z).  
2. **Omonogeneita'**: T(a·x) = a·T(x).

Se consideriamo un'immagine come un insieme (griglia) di coordinate (x, y) per i pixel, allora una matrice di trasformazione (ad esempio 2×2 in caso bidimensionale) puo' essere applicata a ciascun punto dell'immagine per trasformarlo in una nuova posizione nello spazio.

**In pratica**: la trasformazione lineare definisce **come** i punti (e quindi i pixel) dell'immagine si spostano, ruotano, ingrandiscono o si riflettono.

---

## 2. Rotazione

### 2.1 Formula di rotazione

Una delle trasformazioni lineari piu' comuni e' la **rotazione**. In 2D, la rotazione di un angolo (theta) intorno all'origine puo' essere espressa dalla matrice:

# Parte B: Trasformazioni Lineari su Immagini

Dopo aver visto come le immagini digitali possano essere interpretate come matrici di valori, entriamo ora nel vivo di una delle applicazioni piu' interessanti di questa prospettiva: **le trasformazioni lineari**. Queste operazioni – che in algebra lineare si applicano a vettori e matrici – possono essere utilizzate anche per modificare la **geometria di un'immagine**.

Le trasformazioni lineari includono operazioni come **rotazione**, **riflessione**, **ridimensionamento** e **deformazione**. Ogni volta che ruotate una foto di 90° sul vostro smartphone o che specchiate un'immagine per ottenere un effetto "flip", state di fatto agendo come un piccolo "matematico" che applica una matrice di trasformazione!

---

## 1. Concetto di Trasformazione Lineare

In algebra lineare, una **trasformazione lineare** T su uno spazio vettoriale e' una funzione che prende in input un vettore (x) e lo mappa in un altro vettore (y), rispettando due proprieta' fondamentali:

1. **Additivita'**: T(x + z) = T(x) + T(z).  
2. **Omonogeneita'**: T(a·x) = a·T(x).

Se consideriamo un'immagine come un insieme (griglia) di coordinate (x, y) per i pixel, allora una matrice di trasformazione (ad esempio 2×2 in caso bidimensionale) puo' essere applicata a ciascun punto dell'immagine per trasformarlo in una nuova posizione nello spazio.

**In pratica**: la trasformazione lineare definisce **come** i punti (e quindi i pixel) dell'immagine si spostano, ruotano, ingrandiscono o si riflettono.

---

## 2. Rotazione

### 2.1 Formula di rotazione

Una delle trasformazioni lineari piu' comuni e' la **rotazione**. In 2D, la rotazione di un angolo (theta) intorno all'origine puo' essere espressa dalla matrice:

[ cos(theta) -sin(theta) ] [ sin(theta) cos(theta) ]


Applicare questa matrice a un punto (x, y) significa ruotarlo di *theta* (in gradi o radianti) intorno all'origine.

### 2.2 Rotazione di un'immagine

Quando vogliamo **ruotare un'immagine intera**, dobbiamo considerare due aspetti:

1. **Applicazione della matrice ai pixel**: per ogni pixel, calcoliamo la sua nuova posizione dopo la rotazione.
2. **Gestione dello spazio vuoto**: ruotando, parte dell'immagine potrebbe "uscire" fuori dall'area visibile, oppure si potrebbe creare spazio vuoto ai bordi. I software di grafica risolvono queste situazioni "tagliando" l'immagine (crop) o aggiungendo bordi extra (padding).

> *Nota*: La rotazione intorno all'origine non coincide sempre con quella intorno al centro dell'immagine (come accade di solito nei programmi di fotoritocco). In quel caso, si effettua una "traslazione" del centro sull'origine prima di ruotare, e poi si riporta l'immagine nella posizione originale.

---

## 3. Riflessone (Specchiatura)

### 3.1 Definizione

La **riflessione** (o "specchiatura") e' una trasformazione lineare che ribalta i punti rispetto a un asse. Ad esempio, riflettere rispetto all'asse x corrisponde alla matrice:

[ 1 0 ] [ 0 -1 ]


Mentre riflettere rispetto all'asse y corrisponde a:


### 3.2 Effetto sull'immagine

- **Riflesso orizzontale**: e' come guardare l'immagine in uno specchio posto di lato.
- **Riflesso verticale**: e' come se lo specchio fosse sopra o sotto l'immagine.

Queste operazioni sono ampiamente utilizzate nei software di grafica come funzione "Flip Horizontal" o "Flip Vertical".

---

## 4. Ridimensionamento e Deformazioni

### 4.1 Scalatura (Scaling)

Un altro esempio classico e' la **scalatura**, che ingrandisce o riduce un'immagine. La matrice di scalatura lungo gli assi x e y puo' essere:

[ sx 0 ] [ 0 sy ]


Dove `sx` e `sy` sono i fattori di scala sui due assi. Se `sx` > 1, l'immagine si allarga orizzontalmente; se `sy` > 1, si estende verticalmente.

### 4.2 Deformazioni (Shear)

Le **deformazioni a forbice** (o *shear* in inglese) sono ottenute da matrici che "piegano" l'immagine lungo uno degli assi. Ad esempio, uno shear in direzione x puo' essere descritto da:

[ 1 k ] [ 0 1 ]

Dove k e' il coefficiente di shear. Questo effetto "inclina" l'immagine, mantenendo un asse allineato e l'altro inclinato.

---

## 5. Il ruolo del Determinante

Nel caso bidimensionale, il **determinante** di una matrice di trasformazione (2×2) ci dice come varia l'area (e, in termini di immagine, quanto viene ingrandita o ridotta la porzione visiva):

- Determinante > 1: la trasformazione ingrandisce l'immagine (area aumentata).
- Determinante = 1: la trasformazione conserva l'area (come nel caso di una pura rotazione o riflessione).
- Determinante < 1: la trasformazione riduce l'immagine (area diminuita).
- Determinante = 0: la trasformazione "schiaccia" tutto su una linea o un punto.

> *Nota*: quando si ruota o si riflette un'immagine, il determinante e' ±1, il che indica che l'operazione non modifica l'area, ma si limita a riorganizzare i pixel nello spazio (rotazione) o a invertirne l'ordine (riflessione).

---

## Conclusioni Parte B

- Le trasformazioni lineari su immagini sono governate da **matrici** che spostano i pixel in nuove posizioni.
- **Rotazioni**, **riflessioni**, **scalature** e **deformazioni** sono tutte variazioni sul tema della trasformazione lineare.
- Il **determinante** della matrice di trasformazione fornisce una misura di come varia l'area (o la "dimensione") dell'immagine.
- Comprendere questi concetti di base e' essenziale per capire come i software di grafica gestiscano operazioni di "trasformazione", permettendoci di effettuare modifiche precise e consapevoli alle nostre immagini.

---