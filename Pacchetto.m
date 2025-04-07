(* Content-type: application/vnd.wolfram.mathematica *)

(*** Wolfram Notebook File ***)
(* http://www.wolfram.com/nb *)

(* CreatedBy='Wolfram 14.2' *)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       154,          7]
NotebookDataLength[      5484,        150]
NotebookOptionsPosition[      4969,        132]
NotebookOutlinePosition[      5398,        149]
CellTagsIndexPosition[      5355,        146]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell[BoxData[{
 RowBox[{
  RowBox[{
   RowBox[{"BeginPackage", "[", "\"\<Pacchetto`\>\"", "]"}], ";"}], "\n", 
  "\[IndentingNewLine]"}], "\n", 
 RowBox[{
  RowBox[{
   RowBox[{"startUI", "[", "]"}], ":=", 
   RowBox[{"Module", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"grigliaEsempio", ",", "matriceEsempio"}], "}"}], ",", 
     "\[IndentingNewLine]", "\[IndentingNewLine]", 
     RowBox[{"(*", 
      RowBox[{"Matrice", " ", 
       RowBox[{"finta", ":", "scacchiera"}]}], "*)"}], "\[IndentingNewLine]", 
     "\[IndentingNewLine]", 
     RowBox[{
      RowBox[{"matriceEsempio", "=", 
       RowBox[{"Table", "[", 
        RowBox[{
         RowBox[{"If", "[", 
          RowBox[{
           RowBox[{"EvenQ", "[", 
            RowBox[{"i", "+", "j"}], "]"}], ",", "1", ",", "0"}], "]"}], ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", "5"}], "}"}], ",", 
         RowBox[{"{", 
          RowBox[{"j", ",", "5"}], "}"}]}], "]"}]}], ";", 
      "\[IndentingNewLine]", "\[IndentingNewLine]", 
      RowBox[{"grigliaEsempio", "=", 
       RowBox[{"ArrayPlot", "[", 
        RowBox[{"matriceEsempio", ",", 
         RowBox[{"ColorRules", "->", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"1", "->", "White"}], ",", 
            RowBox[{"0", "->", "Black"}]}], "}"}]}], ",", 
         RowBox[{"Frame", "->", "True"}], ",", 
         RowBox[{"Mesh", "->", "True"}], ",", "\[IndentingNewLine]", 
         RowBox[{
         "PlotLabel", 
          "->", "\"\<Visualizzazione rasterizzata (bianco = 1, nero = \
0)\>\""}], ",", 
         RowBox[{"ImageSize", "->", "Medium"}]}], "]"}]}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"Column", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Style", "[", 
           
           RowBox[{"\"\<Cos'\[EGrave] un'immagine raster\>\"", ",", "Bold", ",",
             "18"}], "]"}], ",", 
          RowBox[{"Style", "[", 
           
           RowBox[{"\"\<Un'immagine raster \[EGrave] una griglia di celle \
(pixel), ciascuna con un valore che rappresenta il colore o l'intensit\
\[AGrave] luminosa.\\nNel caso delle immagini in scala di grigi, ogni cella \
ha un valore da 0 (nero) a 1 (bianco).\>\"", ",", "14"}], "]"}], ",", 
          RowBox[{"Style", "[", 
           
           RowBox[{"\"\<Esempio semplificato: scacchiera 5\[Times]5\>\"", ",",
             "Italic", ",", "14"}], "]"}], ",", 
          RowBox[{"Row", "[", 
           RowBox[{"{", 
            RowBox[{"grigliaEsempio", ",", 
             RowBox[{"Spacer", "[", "30", "]"}], ",", 
             RowBox[{"Column", "[", 
              RowBox[{"{", 
               RowBox[{
                RowBox[{"Style", "[", 
                 
                 RowBox[{"\"\<Matrice corrispondente\>\"", ",", "Italic", ",",
                   "12"}], "]"}], ",", 
                RowBox[{"MatrixForm", "[", "matriceEsempio", "]"}]}], "}"}], 
              "]"}]}], "}"}], "]"}], ",", 
          RowBox[{"Spacer", "[", "20", "]"}], ",", 
          RowBox[{"Style", "[", 
           
           RowBox[{"\"\<Questa rappresentazione mostra come i valori numerici \
possono essere 'tradotti' in immagine.\>\"", ",", "12", ",", "Gray"}], 
           "]"}]}], "}"}], ",", 
        RowBox[{"Spacings", "->", "2"}]}], "]"}]}]}], "]"}]}], 
  "\[IndentingNewLine]", "\[IndentingNewLine]", "\n", "\n"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"End", "[", "]"}], ";"}], "\n", 
 RowBox[{
  RowBox[{"EndPackage", "[", "]"}], ";"}], "\n"}], "Input",
 CellChangeTimes->{{3.953001340070751*^9, 3.9530013581803093`*^9}, {
  3.953001646695284*^9, 3.95300164696319*^9}, {3.953001690748682*^9, 
  3.953001695282116*^9}, {3.9530018831316986`*^9, 3.9530018835088463`*^9}, {
  3.9530019238621655`*^9, 3.953001926222967*^9}, {3.953002144866806*^9, 
  3.9530021604997997`*^9}, {3.9530022029789753`*^9, 
  3.953002203162651*^9}},ExpressionUUID->"f07c2437-3d1c-de45-a06f-\
ee596d92b620"],

Cell[BoxData[
 TemplateBox[{
  "EndPackage", "noctx", "\"No previous context defined.\"", 2, 73, 6, 
   29619570738990459721, "Local"},
  "MessageTemplate",
  BaseStyle->"MSG"]], "Message",
 CellChangeTimes->{{3.953001696990761*^9, 3.953001701034668*^9}, 
   3.9530018865571747`*^9, {3.953001928316147*^9, 3.9530019536387444`*^9}},
 CellLabel->
  "During evaluation of \
In[70]:=",ExpressionUUID->"fe87ba41-2685-fc4d-9b6c-a253d4e16155"]
}, Open  ]]
},
WindowSize->{949, 497},
WindowMargins->{{0, Automatic}, {Automatic, 0}},
Magnification:>1. Inherited,
FrontEndVersion->"14.2 for Microsoft Windows (64-bit) (December 26, 2024)",
StyleDefinitions->"Default.nb",
ExpressionUUID->"bdc8f0b0-8ac2-b440-8f09-0847eeb58141"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[576, 22, 3938, 95, 522, "Input",ExpressionUUID->"f07c2437-3d1c-de45-a06f-ee596d92b620"],
Cell[4517, 119, 436, 10, 26, "Message",ExpressionUUID->"fe87ba41-2685-fc4d-9b6c-a253d4e16155"]
}, Open  ]]
}
]
*)

