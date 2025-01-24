## Logische und physische Optimierung
- Logische Optimierung
  - Jeder Ausdruck kann in viele verschiedene, semantisch äquivalente Ausdrücke umgeschrieben werden.
  - Wähle den (hoffentlich) besten Ausdruck (=Plan, =QEP)

- Physische Optimierung
  - Für jede relationale Operation gibt es viele verschiedene Implementierungen.
  - Zugriff auf Tabellen
    > Scan, verschiedene Indizes, sortierter Zugriff, …
  - Joins
    > Nested loop, sort-merge, hash, …
  - Wähle für jede Operation die (hoffentlich) beste Implementierung
- Abhängigkeit beider Probleme!


### Logische Optimierung
- Grundsätze der logischen Optimierung
  - Selektionen so weit wie möglich im Baum nach unten
schieben.
  - Selektionen mit AND können aufgeteilt und separat verschoben
werden.
  - Projektionen so weit wie möglich im Baum nach unten
schieben,
    > bzw. neue Projektionen können eingefügt werden.
  - Duplikateliminierung kann manchmal entfernt werden oder
verschoben werden.
  - Kreuzprodukte mit geeigneten Selektionen zu einem Join
zusammenfassen.

### Kosten von Operationen
- Projektion:
  - Keine Kosten falls mit anderem Operator kombiniert
- Selektion
  - Ohne Index: Gesamte Relation von Festplatte lesen
  - Mit Baum-Index: Teil des Index von Platte lesen (Baumtiefe)
und gesuchte Seite von Platte lesen
  - Bei Pipelining: (Fast) keine Kosten
- Join
  - Je nach Joinalgorithmus
  - Nested Loops, Hash-Join, Sort-Merge Join

- Wesentliches Kostenmerkmal: Anzahl der Tupel im Input
  - Insbesondere: Passt die Relation in den Hauptspeicher?
  - Selektion, Projektion, Sortierung, Join
- Output ist Input des nächsten Operators.
- Deshalb: Ein Kostenmodel schätzt u.a. für jede Operation die
Anzahl der Ausgabetupel.
  - „Selektivität“ in Bezug auf Inputgröße
  - #Ausgabetupel = #Eingabetupel x Selektivität
  - Auch „Selektivitätsfaktor“ (selectivity factor, sf)

### Selektivität
- Selektivität schätzt Anzahl der qualifizierenden Tupel relativ zur
Gesamtanzahl der Tupel in der Relation.
- Projektion:
  > sf = |R|/|R| = 1
- Selektion:
  > sf = |σC(R)| / |R|
- Join:
  > sf = |R ⋈ S| / |R x S| = |R ⋈ S| / (|R| · |S|)


------------

- *Beispiel:*
  > Gegeben sei die folgende SQL-Anfrage:
  > ```SQL
  > SELECT DISTINCT 
  >   a.PersNr , 
  >   a.Name
  > FROM 
  >   Assistenten a , 
  >   Studenten s , 
  >   pruefen p
  > WHERE 
  >       s.MatrNr = p.MatrNr
  >   AND a.Boss   = p.PersNr
  >   AND s.Name   = 'Jonas';
  > ```