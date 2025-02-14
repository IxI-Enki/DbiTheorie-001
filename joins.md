- # Logische und physische Optimierung
  - ### Logische Optimierung
    > Jeder Ausdruck kann in viele verschiedene, semantisch äquivalente Ausdrücke umgeschrieben werden.

  - ### Physische Optimierung
    > Für jede relationale Operation gibt es viele verschiedene Implementierungen.
    - #### Zugriff auf Tabellen
        > Scan, verschiedene Indizes, sortierter Zugriff, …
    - #### Joins
        > Nested loop, sort-merge, hash, …
  - Abhängigkeit beider Probleme!

<!--  δ --->

- ## Logische Optimierung
    > Grundsätze der logischen Optimierung

  - Selektionen so weit wie möglich im Baum nach unten schieben.
  - Selektionen mit AND können aufgeteilt und separat verschoben werden.
  
  - Projektionen so weit wie möglich im Baum nach unten schieben,
    > bzw. neue Projektionen können eingefügt werden.
    
  - Duplikateliminierung kann manchmal entfernt werden oder verschoben werden.
  - Kreuzprodukte mit geeigneten Selektionen zu einem Join zusammenfassen.

---
- ## Kosten von Operationen
  - ### Projektion $\Large\color{lime}{π}$ 
      - Keine Kosten falls mit anderem Operator kombiniert
  - ### Selektion $\Large\color{yellow}{σ}$ 
      - Ohne Index: Gesamte Relation von Festplatte lesen
      - Mit Baum-Index: Teil des Index von Platte lesen (Baumtiefe) und gesuchte Seite von Platte lesen
      - Bei Pipelining: (Fast) keine Kosten
  - ### Join $\Large\color{orange}{⨝}$ 
      - Je nach Joinalgorithmus
      - Nested Loops, Hash-Join, Sort-Merge Join
    ---
- ## Wesentliches Kostenmerkmal: Anzahl der Tupel im Input
  > Insbesondere: Passt die Relation in den Hauptspeicher?
  - #### Selektion, Projektion, Sortierung, Join
    ---
  - #### Output ist Input des nächsten Operators.
    > Deshalb: Ein Kostenmodel schätzt u.a. für jede Operation die Anzahl der Ausgabetupel.
    - „Selektivität“ in Bezug auf Inputgröße
    - #Ausgabetupel = #Eingabetupel x Selektivität
      > Auch „Selektivitätsfaktor“ (selectivity factor, sf)
    ---
  - ### Selektivität
    Selektivität schätzt Anzahl der qualifizierenden Tupel relativ zur Gesamtanzahl der Tupel in der Relation.
    - Projektion:
      > sf = |R|/|R| = 1
    - Selektion:
      > sf = |σC(R)| / |R|
    - Join:
      > sf = |R ⋈ S| / |R x S| = |R ⋈ S| / (|R| · |S|)
