
SetOptions[$FrontEnd, IgnoreSpellCheck -> True]

# Introduzione

Benvenuti! In questo percorso scopriremo come le immagini digitali possono essere interpretate e trasformate usando le **matrici**.

Un'immagine al computer e' una griglia di numeri: ogni numero rappresenta un **pixel**. Per immagini in bianco e nero, ogni pixel e' un solo numero. Per immagini a colori, ogni pixel ha piu' numeri (per esempio rosso, verde e blu).

Capire questa struttura ci permette di:

- ruotare e riflettere immagini con la matematica delle matrici
- cambiare luminosita' e contrasto modificando i numeri
- usare **filtri** per sfocare o trovare i bordi con semplici operazioni

Vedremo tutto questo in tre parti:

1. **Cos'e' un'immagine raster**  
2. **Come usare le trasformazioni lineari**  
3. **Come funzionano i filtri e le convoluzioni**

---

# Parte A: Cos'e' un'immagine raster

## 1. L'idea di base

Le immagini digitali piu' comuni sono raster: cioe' griglie di **pixel**.

Ogni pixel e' un numero (grigio) o un gruppo di numeri (colori).

- Grigio: un solo numero da 0 (nero) a 255 (bianco)
- Colore: tre numeri, uno per ogni colore base (rosso, verde, blu)

Un'immagine di 800x600 pixel e' una tabella di 800 colonne e 600 righe.

### Esempio semplice

Immagina una scacchiera: se bianco = 1 e nero = 0, ottieni una matrice di 0 e 1. E' una mini immagine in scala di grigi!

---

## 2. Grigio vs Colore

### Scala di grigi

Ogni pixel ha un valore da 0 a 255. Zero e' nero, 255 e' bianco, in mezzo ci sono tutte le sfumature.

### RGB

Ogni pixel ha 3 numeri: (R, G, B)

- (255, 0, 0) = rosso
- (0, 255, 0) = verde
- (0, 0, 255) = blu
- (255, 255, 255) = bianco
- (0, 0, 0) = nero

Combinando questi tre valori si crea qualsiasi colore.

---

# Parte B: Trasformazioni lineari

## 1. Cos'e' una trasformazione lineare

Una trasformazione lineare prende un punto e lo sposta in modo "ordinato", secondo regole fisse (rotazioni, riflessioni, ecc.).

Si usa una **matrice 2x2** per dire come cambiano le coordinate di ogni pixel.

---

## 2. Rotazioni

Per ruotare un punto di un angolo t, si usa questa matrice:

[ cos(t)  -sin(t) ]  
[ sin(t)   cos(t) ]

Questa cambia le coordinate del punto per ottenere l'effetto di rotazione.

Ruotare un'immagine intera richiede anche di considerare il centro e lo spazio vuoto che si crea.

---

## 3. Riflessi

Specchiare un'immagine e' come rifletterla rispetto a un asse.

- Asse x: [ 1  0 ]  
          [ 0 -1 ]
- Asse y: [ -1  0 ]  
          [  0  1 ]

---

## 4. Scalature e deformazioni

### Scalatura

Matrice:

[ sx  0 ]  
[ 0  sy ]

Serve per ingrandire (sx > 1) o ridurre (sx < 1) un'immagine.

### Shear

Deforma l'immagine "piegandola". Ad esempio:

[ 1  k ]  
[ 0  1 ]

---

## 5. Determinante

Il **determinante** della matrice dice quanto cambia l'area:

- >1 = ingrandimento
- =1 = area invariata
- <1 = rimpicciolimento
- =0 = tutto schiacciato in una riga o punto

---

# Parte C: Filtri e convoluzioni

## 1. Cos'e' una convoluzione

Una **convoluzione** applica un filtro (piccola matrice) su ogni pixel e sui suoi vicini.

Il risultato e' una nuova immagine modificata.

---

## 2. Cos'e' un kernel

E' una piccola matrice come questa (esempio di sfocatura):

[ 1/9  1/9  1/9 ]  
[ 1/9  1/9  1/9 ]  
[ 1/9  1/9  1/9 ]

Ogni valore del kernel viene moltiplicato per i pixel vicini, e poi si fa la somma.

---

## 3. Come funziona

1. Posiziona il kernel sul pixel
2. Moltiplica e somma i valori
3. Metti il risultato nel nuovo pixel
4. Sposta il kernel e ripeti

---

## 4. Esempi

### Sfocatura (Blur)

[ 1/9 1/9 1/9 ]  
[ 1/9 1/9 1/9 ]  
[ 1/9 1/9 1/9 ]

### Nitidezza (Sharpen)

[  0 -1  0 ]  
[ -1  5 -1 ]  
[  0 -1  0 ]

### Rilevamento bordi

[ -1 -1 -1 ]  
[ -1  8 -1 ]  
[ -1 -1 -1 ]

---

## 5. Perche' e' utile

Con la convoluzione possiamo:

- Sfocare o rendere nitide le immagini
- Trovare i bordi
- Modificare la luce e il contrasto

---

# Conclusione

Capire le immagini come **matrici** ci permette di:

- modificare la loro geometria (rotazioni, riflessi, ecc.)
- applicare effetti e filtri (sfocature, bordi)
- usare la matematica per controllare e creare immagini

Ora che sai come funziona, puoi guardare le immagini con occhi piu' "matematici"!
