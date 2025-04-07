**Introduzione al progetto**

Questo percorso didattico ha l'obiettivo di introdurre i concetti fondamentali della manipolazione di immagini digitali attraverso l'utilizzo delle matrici. Le immagini, nella loro essenza computazionale, non sono altro che insiemi ordinati di numeri organizzati in griglie: le matrici. Comprendere questa struttura è il primo passo per poter poi operare trasformazioni, analisi e modifiche sui dati visivi in modo ragionato e consapevole.

Il progetto è strutturato in tre parti principali:

- **Parte A**: introduce il concetto di immagine raster, spiegando come le immagini vengano rappresentate tramite griglie di pixel. Viene affrontata la differenza tra immagini in scala di grigi e RGB, con esempi visuali per consolidare la comprensione.

- **Parte B**: esplora le trasformazioni lineari applicabili a immagini viste come matrici. Vengono spiegate operazioni come rotazione, scaling, riflessione e deformazione, mettendo in evidenza anche il ruolo matematico del determinante.

- **Parte C**: approfondisce il concetto di convoluzione, una tecnica chiave per il filtraggio e la trasformazione delle immagini. Viene spiegato cosa sono i kernel e come agiscono sui pixel per generare effetti visivi.

A completamento del percorso, è presente una **sezione di esercizi** progettata per stimolare la riflessione e il ragionamento visivo, permettendo all'utente di interagire con immagini ed effetti senza scrivere codice, ma solo attraverso interfacce intuitive.

---

**Canvas Parte A: Fondamenti di immagini raster**

**1. Cos'è un'immagine raster**
Un'immagine raster è una rappresentazione visiva composta da una griglia rettangolare di elementi chiamati pixel. Ogni pixel è una cella della griglia che contiene informazioni visive, come l'intensità luminosa o il colore. L'intera immagine è quindi una matrice di valori numerici, dove ogni valore corrisponde a un pixel. Le immagini raster sono usate comunemente nei computer e nei dispositivi digitali per rappresentare fotografie e grafiche. Le dimensioni della matrice (altezza x larghezza) definiscono la risoluzione dell'immagine.

**2. Differenza tra immagini in scala di grigi e RGB**
- **Scala di grigi:** ogni pixel è rappresentato da un solo valore numerico, che indica la sua intensità luminosa. Tipicamente questi valori vanno da 0 (nero) a 1 (bianco), oppure da 0 a 255 in rappresentazioni intere. Questa modalità è utilizzata per immagini monocromatiche.

- **RGB:** ogni pixel è descritto da un vettore di tre valori, che rappresentano l'intensità dei tre colori fondamentali: Rosso (Red), Verde (Green), e Blu (Blue). Combinando questi tre valori si ottiene il colore finale del pixel. Anche in questo caso, i valori possono variare da 0 a 1 o da 0 a 255.

**3. Visualizzazione delle immagini con intensità e colore**
Le immagini in scala di grigi possono essere viste come una semplice matrice di numeri: ogni numero rappresenta quanto chiaro o scuro è un determinato punto. Le immagini a colori, invece, sono costituite da tre matrici sovrapposte (una per ogni colore) che lavorano insieme per produrre la percezione visiva del colore.

Per aiutare la comprensione, si possono utilizzare esempi visivi come una scacchiera (bianco e nero) per simulare una matrice di pixel. In questo modo diventa evidente come ogni cella corrisponde a un numero e come la variazione dei numeri modifica l'aspetto dell'immagine.


**Canvas Parte B: Trasformazioni Lineari su Immagini**

**1. Introduzione alle trasformazioni lineari**
Le trasformazioni lineari permettono di modificare la posizione e l'aspetto dei punti all'interno di una matrice. Ogni trasformazione può essere rappresentata da una matrice 2x2 applicata alle coordinate dei punti dell'immagine. Le trasformazioni lineari comprendono rotazioni, riflessioni, dilatazioni (scaling) e deformazioni (shearing).

**2. Matrice identità e trasformazioni principali**
- La **matrice identità** è una matrice speciale che, quando applicata, non modifica nulla: lascia l'immagine invariata.
- Altre matrici possono modificare l'immagine in vari modi:
  - **Scaling**: ingrandisce o riduce l'immagine.
  - **Rotazione**: ruota l'immagine attorno a un punto.
  - **Riflessione**: crea una copia speculare.
  - **Shearing**: distorce l'immagine spingendo i punti in una direzione.

**3. Introduzione al determinante**
Il determinante di una matrice di trasformazione è un numero che descrive alcune proprietà geometriche della trasformazione:
- Se il determinante è positivo, la trasformazione preserva l'orientamento dell'immagine.
- Se è negativo, l'immagine viene riflessa.
- Se il determinante è zero, la trasformazione riduce l'immagine a una dimensione inferiore, perdendo informazioni (es. collasso su una linea).

**4. Attività didattiche suggerite**
- Rappresentare visivamente una griglia e mostrare l'effetto di ciascuna trasformazione.
- Confrontare una matrice trasformata con la sua versione originale.
- Collegare i concetti astratti (come il determinante) a effetti visivi concreti.


**Canvas Parte C: Convoluzioni e Filtri**

**1. Cos'è una convoluzione**
La convoluzione è un processo matematico che si applica a una matrice (in questo caso l'immagine) mediante un'altra matrice più piccola, chiamata **kernel** o **filtro**. Si usa per modificare o estrarre informazioni da un'immagine, come rendere sfocati i bordi o evidenziarli.

**2. Kernel comuni**
- **Sfocatura (Blur):** distribuisce l'intensità dei pixel vicini, rendendo l'immagine più morbida.
- **Rilevamento dei bordi:** evidenzia le transizioni nette tra aree di colore o intensità.
- **Nitidezza (Sharpen):** aumenta il contrasto tra pixel vicini per rendere l'immagine più definita.

**3. Didattica interattiva**
- Mostrare passo per passo come un filtro si sposta sull'immagine e ne modifica i valori.
- Visualizzare la matrice del kernel e l'effetto prodotto.
- Usare esempi semplificati per facilitare la comprensione del meccanismo.

**4. Rappresentazione matriciale**
Ogni convoluzione può essere vista come il risultato di una moltiplicazione tra porzioni dell'immagine e il kernel. Sommando i risultati si ottiene un nuovo valore per ciascun pixel. Questo procedimento si ripete su tutta l'immagine per produrre l'effetto desiderato.


**Sezione Test - Esercizi didattici**

**Obiettivo:** Sviluppare la comprensione pratica delle immagini come matrici e dei principali effetti delle trasformazioni lineari e convoluzioni.

**Tipologia 1: Riconoscimento dell'effetto**
- Mostrare un'immagine modificata.
- Chiedere all'utente di identificare quale tipo di trasformazione o filtro è stato applicato.

**Tipologia 2: Reverse Engineering**
- Fornire una coppia di immagini (originale e modificata).
- Chiedere all'utente di dedurre quale kernel, filtro o trasformazione è stato applicato.
- Variante: fornire più opzioni visive tra cui scegliere.

**Tipologia 3: Applicazione logica**
- Mostrare una parte della matrice immagine e il risultato parziale di una convoluzione.
- Chiedere all'utente di completare la matrice del kernel, basandosi sui risultati.

**Nota didattica finale:**
Tutte le attività devono essere guidate da un'interfaccia interattiva e visiva, in cui l'utente può osservare e riflettere, senza necessità di scrivere codice. La varietà degli esercizi può essere aumentata generando casi diversi a ogni avvio del notebook, utilizzando metodi casuali controllati per la riproducibilità.