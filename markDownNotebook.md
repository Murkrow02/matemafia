
SetOptions[$FrontEnd, IgnoreSpellCheck -> True]

# Introduzione

Benvenuti! In questo percorso scopriremo come le immagini digitali possono essere interpretate e trasformate usando le **matrici**.

Un'immagine digitale e' una griglia di numeri: ogni numero rappresenta un **pixel**. Per immagini in bianco e nero, ogni pixel e' un solo numero. Per immagini a colori, ogni pixel ha piu' numeri (per esempio rosso, verde e blu).

Capire questa struttura ci permette di:

- ruotare e riflettere immagini con la matematica delle matrici
- cambiare luminosita' e contrasto modificando i numeri
- usare **filtri** per sfocare o trovare i bordi con operazioni matriciali

Vedremo tutto questo in tre parti:

1. **Cos'e' un'immagine raster**  
2. **Come usare le trasformazioni lineari**  
3. **Come funzionano i filtri e le convoluzioni**

---

# Parte A: Cos'e' un'immagine raster

## 1. L'idea di base

Le immagini digitali piu' comuni sono raster: cioe' griglie di **pixel**.

Ogni pixel e' un numero (Scala grigi) o un gruppo di numeri (Colori).

- Scala di grigi: un solo numero da 0 (nero) a 255 (bianco)
- Colore: tre numeri, uno per ogni colore base (rosso, verde, blu)

Un'immagine di 800x600 pixel e' una tabella di 800 colonne e 600 righe.

### Esempio semplice

METTERE una scacchiera: se bianco = 255 e nero = 0, ottieni una matrice di 0 e 255. E' una mini immagine in scala di grigi!

**TODO** generare 

---

## 2. Grigio vs Colore

### Scala di grigi

Ogni pixel ha un valore da 0 a 255. Zero e' nero, 255 e' bianco, in mezzo ci sono tutte le sfumature.

**TODO** mettere immagine del serpente scala di grigi

### RGB

Ogni pixel ha 3 numeri: (R, G, B)

**TODO** inserire matrice con i numeri e i canali e far vedere cosa succede se diventa colore

- (255, 0, 0) = rosso
- (0, 255, 0) = verde
- (0, 0, 255) = blu
- (255, 255, 255) = bianco
- (0, 0, 0) = nero

Combinando questi tre valori si crea qualsiasi colore.

**TODO** Rappresentazione di rgb

**TODO** 
esempio interattivo: nella scala di grigi provare a fare una matrice di bottoni che fa vedere una scacchiera con accendi e spegni. mentre per quanto riguarda rgb mettere slider che modificano l'intensità dei canali 

---

# Parte B: Trasformazioni lineari

### **Cos'e' una trasformazione lineare?**

Una **trasformazione lineare** e' un modo per **spostare, allungare, rimpicciolire o ruotare** oggetti nello spazio, **senza piegarli o deformarli in modo strano**. E' una trasformazione "ordinata", che **mantiene le proporzioni e le direzioni**.

Immagina di avere un disegno su un foglio:
- Se lo ruoti, lo ingrandisci, lo rimpicciolisci o lo sposti in modo preciso, stai facendo una **trasformazione lineare**.
- Se invece lo strappi o lo curvi, **non** e' piu' una trasformazione lineare.

---

### **E nelle immagini?**

Un'immagine digitale e' fatta di **punti (pixel)** in uno spazio. Se vuoi:
- **Ruotare** una foto
- **Ingrandirla o rimpicciolirla**
- **Spostarla** a destra o in alto
- **Specchiarla**

...stai **trasformando i punti** dell'immagine. Le trasformazioni lineari sono perfette per fare questo tipo di operazioni in modo preciso.


**TODO** Trovare immagini che facciamo vedere la trasformazione lineare
---

### **Perche' si usano le matrici?**

Le **matrici** sono come **istruzioni** che spiegano al computer **come muovere i punti**. Ogni tipo di trasformazione (ruota, ingrandisci, sposta...) ha la sua "matrice".

Quindi:
- Le immagini sono fatte di punti
- Le trasformazioni cambiano la posizione di quei punti
- Le matrici dicono al computer **come** farlo

---

### 1. **Rotazione**

#### Matrice:
{{Cos[θ], -Sin[θ]}, {Sin[θ], Cos[θ]}}

#### Spiegazione:
Questa matrice e' studiata per **ruotare ogni punto intorno all'origine (0,0)** di un angolo θ.  
- **Coseno e seno:** Il coseno indica quanto di una componente resta nella direzione originale, mentre il seno rappresenta la parte che viene “spostata” lungo la direzione perpendicolare.
- **Struttura della matrice:** Le colonne indicano la nuova direzione in cui gli assi X e Y vengono “trasformati”. Ad esempio, ruotando di 90° in senso antiorario, l'asse X assume la direzione originariamente occupata dall'asse Y, mentre l'asse Y viene invertito nella direzione negativa dell'asse X.
- **Effetto visivo:** Le forme (come un quadrato con una freccia interna) ruotano senza perdere le proporzioni e con angoli e distanze inalterati.  
Questa proprieta' di preservazione degli angoli e delle lunghezze rende la rotazione una trasformazione “rigida” o isometrica.


**TODO** Mettere immagine di un quadrato con una freccia verso l'alto e ovviamente mettere la matrice corrispondente
---

### 2. **Riflessione (Specchiatura)**

#### Esempio: Riflessione rispetto all'asse X  
{{1, 0}, {0, -1}}

#### Altre varianti:
- **Riflessione sull'asse Y:**  
    {{-1, 0}, {0, 1}}
- **Riflessione rispetto alla diagonale y = x:**  
    {{0, 1}, {1, 0}}

#### Spiegazione:
La matrice di riflessione opera **"ribaltando" i punti** rispetto a una linea fissa. Prendendo come esempio la riflessione sull'asse X, questa matrice:
- Mantiene invariata la componente X, mentre inverte la componente Y, traducendosi in una specchiatura verticale.
- La forma dell'immagine, come nel caso di una lettera “F” riflessa, non cambia in termini di dimensione o proporzioni, ma il verso (l'orientamento) risulta invertito.
- La riflessione, oltre a essere intuitiva come “immagine allo specchio”, implica un cambio nella parita' dello spazio: un oggetto destrorso diventa sinistrorso.



**TODO** Mettere lo specchiamento della lettera F

---

### 3. **Scalatura (Scaling)**

#### Matrice:
{{s_x, 0}, {0, s_y}}

#### Spiegazione:
La scalatura e' la trasformazione che **modifica le dimensioni** dell'immagine:
- s_x e s_y rappresentano i fattori di scala lungo gli assi X e Y. Se s_x = 2, ogni punto si sposta in modo che la distanza lungo l'asse X raddoppi; se s_y = 0.5, la distanza lungo l'asse Y si dimezza.
- **Scaling isotropo:** Quando s_x e s_y hanno lo stesso valore, l'immagine viene ingrandita o rimpicciolita in modo uniforme, mantenendo la stessa forma.
- **Scaling anisotropo:** Valori diversi per s_x e s_y alterano le proporzioni, allungando o schiacciando la figura in una direzione.
- **Determinante:** Il determinante, calcolato come s_x * s_y, indica **quanto varia l'area**: se il determinante e' 1 l'area rimane invariata; se maggiore di 1, l'immagine e' ingrandita; se minore di 1, e' rimpicciolita; se 0, la trasformazione collassa l'immagine su una linea, perdendo informazioni.
    
Visivamente, si puo' pensare ad un quadrato che diventa un rettangolo (se la scalatura e' anisotropica) oppure ingrandito senza deformazioni (scaling uniforme).


**TODO** Un quadrato che diventa un rettangolo perche non è stato fatto in maniera uniforme



---

### 4. **Deformazione (Shear)**

#### Matrice (Shear orizzontale):
{{1, k}, {0, 1}}

#### Variante (Shear verticale):
{{1, 0}, {k, 1}}

#### Spiegazione:
Lo shear, o “taglio”, **deforma l'immagine inclinando i punti**:
- In una matrice di shear orizzontale, il parametro k controlla la quantita' di spostamento orizzontale in funzione della posizione verticale. Cioe', ogni punto viene spinto orizzontalmente in misura proporzionale alla sua coordinata Y.
- Nel caso dello shear verticale, la coordinata X determina quanto il punto si sposta verticalmente.
- Questa trasformazione **non modifica la dimensione complessiva** lungo le direzioni primarie (ad esempio la “lunghezza” di ogni riga o colonna puo' rimanere costante), ma **cambia gli angoli interni**, trasformando per esempio un quadrato in un parallelogramma.
    
Lo shear e' particolarmente utile per simulare effetti prospettici o per creare particolari effetti grafici in cui l'immagine sembra “spostata” lateralmente senza essere ingrandita o ridotta.


**TODO** Far vedere un immagine con un effetto particolare


**TODO** Esercizi interattivi:

        Rotazione: Immagine, Matrice, L'angolo viene cambiato attraverso uno slider

        Riflessione: Immagine, Un bottone per ogni matrice in maniera hce fa vedere la riflessione su X,Y e diagonale.

        Scalatura: Immagine, Matrice di Sx e Sy, Due slider che permettono di modifcare sx sy

        Shear: Immagine, Mettere uno slider che modifica il K.


---



# Parte C: Filtri e convoluzioni

## Introduzione ai Kernel (o filtri convoluzionali)

Immagina un’immagine digitale come una griglia di numeri: ogni numero rappresenta l’intensità luminosa (nel caso in bianco e nero) o il colore di un pixel.  
Un kernel è una piccola matrice, spesso 3x3 o 5x5, che viene "fatta scorrere" sopra l'immagine per trasformarla localmente, un blocco di pixel alla volta.

Questo processo si chiama convoluzione. In pratica:
- Si prende un pezzettino dell’immagine (delle stesse dimensioni del kernel),
- Lo si moltiplica elemento per elemento con il kernel,
- Si somma tutto,
- E il risultato va nel pixel centrale dell’immagine di output.

È come dire: “Guardo attorno a un pixel, applico una formula che mescola i valori attorno a lui, e ottengo un nuovo pixel che riflette l’effetto desiderato”.  
Il bello è che cambiando i numeri nel kernel, cambiamo completamente il tipo di trasformazione.

Vediamo ora tre usi comuni dei kernel:

---

### 1. Sfocatura (Blur)

**Esempio di kernel:**

    1/9 *
    [ 1  1  1 ]
    [ 1  1  1 ]
    [ 1  1  1 ]

**Spiegazione:**
- Questo kernel fa la media dei pixel vicini.
- L’idea è semplice: per ogni pixel, guarda i suoi vicini e sostituiscilo con la media di tutti.
- Questo attenua i dettagli, ammorbidisce i contorni e produce un effetto di sfocatura uniforme.

Visivamente, è come se passassi un pennello sopra l’immagine: i dettagli si confondono, le forme diventano più morbide, e il rumore (variazioni brusche) viene ridotto.

---

### 2. Nitidezza (Sharpening)

**Esempio di kernel:**

    [  0  -1   0 ]
    [ -1   5  -1 ]
    [  0  -1   0 ]

**Spiegazione:**
- Questo kernel prende il valore del pixel centrale e lo rinforza, sottraendo parte delle informazioni dei pixel vicini.
- L’effetto è che i bordi e i dettagli vengono amplificati, rendendo l’immagine più “tagliente” e definita.
- È come se ogni pixel dicesse: “Io sono diverso dai miei vicini? Allora esalto questa differenza!”

Tecnicamente, si ottiene un’immagine più contrastata localmente: le transizioni nette diventano più evidenti, mentre le aree piatte restano inalterate.

---

### 3. Rilevamento bordi (Edge Detection)

**Esempio di kernel (Sobel orizzontale):**

    [ -1   0   1 ]
    [ -2   0   2 ]
    [ -1   0   1 ]

**Spiegazione:**
- Questo kernel è progettato per rilevare variazioni brusche di intensità in una direzione (in questo caso, orizzontale).
- Se la differenza di intensità tra i pixel sinistri e destri è alta, il valore finale sarà alto.
- I bordi non sono altro che zone dove l’immagine cambia bruscamente, e il kernel li esalta.

L’immagine risultante è quasi “astratta”: non si vedono più colori o superfici, ma solamente i contorni delle forme.  
Questo è fondamentale in applicazioni come la visione artificiale, dove interessa più la struttura che l’aspetto.

---

## Cosa ci insegnano i kernel?

- Ogni kernel è un modello locale: guarda una piccola zona e decide cosa fare con essa.
- Cambiando i valori nella matrice, cambia il tipo di filtro applicato.
- Il processo è semplice ma potentissimo, perché con piccoli blocchi e semplici operazioni si possono ottenere trasformazioni visive estremamente complesse.
- I kernel sono anche la base dei primi strati nelle reti neurali convoluzionali: imparano da soli questi filtri per riconoscere strutture, forme e pattern.

---
