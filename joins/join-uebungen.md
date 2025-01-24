- ## Hausaufgabe 3

  - **a**<sub>)</sub> Was ist ein Equi-Join?
  - **b**<sub>)</sub> Bei welchen Join-Prädikaten `(<, =, >)` kann man sinnvoll einen Hashjoin einsetzen?
  - **c**<sub>)</sub> Gegeben ist die Relation *`Profs = {PersNr, Name}`* und *`Raeume = {PersNr, RaumNr}`*.
  
    - **1.** Skizzieren Sie eine geschickte Möglichkeit, den Equi-Join *`Profs ⨝ Raeume`* durchzufuhren.

    - **2.** In welchem Fall wäre selbst ein Ausdruck wie
       *`Profs ⨝ <sub>Profs.Persnr < Raeume.PersNr</sub> Raeume`*
      effizient auswertbar?

  - **d**<sub>)</sub> Der Student Maier hat einen Algorithmus gefunden, 
    der den Ausdruck `A ⨉ B` in einer Laufzeit von `O( | A | )` materialisiert. 
    Was sagen Sie Herrn Maier?

    ---

  <details>
    <summary> click 4

    $\Large\color{lime}{\ ► \ Lösung\ :\ }$ 
    </summary>
 
  - **a**<sub>)</sub>
    *Ein Equi-Join hat eine Aquivalenz als Joinbedingung, etwa die Gleichheit zweier Attribute.*
  
  - **b**<sub>)</sub> 
    *Ein Hash Join bietet sich nur fur Equi-Joins an, 
    da lediglich ein Join-Partner mit gleichem Attributwert effizient auffindbar ist.* 
    > Das Finden eines Partners, dessen Attributwert beispielsweise kleiner sein soll kann mittels Hashing i.A. nicht effizient bearbeitet werden.

  - **c**<sub>)</sub> 

    - **1.**<sub>)</sub> 
      *Offenbar ist das Joinattribut gerade der Primärschlussel, 
      womit von der Existenz eines Indexes ausgegangen werden kann. 
      Somit bietet sich ein Index-basierter Join an, etwa dadurch, 
      dass die eine Relation Element fur Element abgearbeitet wird, 
      während Joinpartner aus der anderen Relation mittels des Indexes gefunden werden.*

    - **2.**<sub>)</sub> 
      *Falls der Index sortiert ist, dies wäre etwa bei einem B-Baum der Fall. 
      Dadurch liegen Joinpartner zumindest nacheinander im Index, anders als bei einer Implementierung des Indexes mittels Hash.*

  - **d.**<sub>)</sub> 
    *Dies ist mit Sicherheit nicht der Fall,* 
    > da ein Algorithmus keine bessere Komplexitätsklasse haben kann als sein Ergebnis wächst. 

    *Mit anderen Worten, $\color{white}{A\ ⨉\ B}$ hat eine Ergebnisgröße von $\color{white}{|A|\ ∗\ |B|}$ und dieses Ergebnis kann sicher nicht schneller als in $\color{white}\large{O}\small{(|A|\ ∗\ |B|)}$ materialisiert werden.*

  </details>

---

- ## Hausaufgabe 4
  - Gegeben sind die beiden Relationenausprägungen:
  
    <div align="center">

       | <img src="img/rel-r.png" alt="Relation" width=25%> |  <img src="img/rel-s.png" alt="Relation" width=25%> |
       | -------------------------------------------------: | :-------------------------------------------------- |

    </div>

  - **1.** Werten Sie den Join **R. ⨝ <sub>R.A = S.B</sub> S** mithilfe des Nested-Loop- sowie des Sort/Merge-Algorithmus aus.  
    
  - **2.** Machen Sie deutlich, in welcher Reihenfolge die Tupel der beiden Relationen verglichen werden und kennzeichnen Sie die Tupel, die in die Ergebnismenge übernommen werden.

  - **3.** Vervollständigen Sie hierzu die beiden folgenden Tabellen:
    <div align="center">

      | <img src="img/nest-loop-empty.png" alt="empty" width=90%> |  <img src="img/sort-merge-empty.png" alt="empty" width=90%> |
      | -------------------------------------------------: | :-------------------------------------------------- |

    </div>

    ---

  
  <details>
    <summary> click 4

    $\Large\color{lime}{\ ► \ Lösung\ :\ }$ 
    </summary>  

    <div align="center">

     | <img src="img/nest-loop-full.png" alt="full" width=100%> |  <img src="img/sort-merge-full.png" alt="full" width=100%> |
     | -------------------------------------------------: | :-------------------------------------------------- |
    </div>

  </details>

---
