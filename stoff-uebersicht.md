*JOINs siehe (verlinktes Videos)
> - Eigenschaften / Funktionsweise von Hash-Tabellen
> - Physische JOIN Implementierungen (Nested Loop, Hash, Sort-Merge, Nested Loop + Index):
>    - Komplexitätsklassen (Achtung: Im Video angegebenes 2*n*log(n) bei Sort-Merge JOIN nur wenn Daten unsortiert, sonst O(n))
>    - Funktionsweise anhand eines kleinen Beispiels (siehe "Weitere Übungsbeispiele inkl. Lösungen").
>    - Einsatzbereich - welcher JOIN für welche Abfrage / bzw. Situation (ala Query gegeben, welcher JOIN wäre optimal inkl Begründung)

> * Logische Optimierung (siehe Folien + verlinkte Videos)
> - Überführen einer SQL-Abfrage in deren kannonische Übersetzung (=Abfragebaum unoptimiert)
> - Optimieren der Abfrage anhand der Äquvalenzregeln (Folien: "Logische Optimierung")
- Abschätzen der Größe der Zwischenergebnisse im unpotimierten / optimierten Fall

* Materialized Views
- Eigenschaften und Verwendung
- Manueller Refresh mittels PL/SQL

* PL/SQL (siehe Folien):
- Grundlagen (Kapitel "Architektur von PL/SQL", Blockstruktur, Variablen, Zuweisungen, Kontrollstrukturen if/then(/else), Schleifen)
- Anonyme Blöcke, Stored Functions, Stored Procedures (Eigenschaften, Verwendung, Aufruf, ...)
- Datenbankzugriff: Lesen einer Zeile mittels SELECT ... INTO, in skalare Variablen (NUMBER, %TYPE) sowie Records (%ROWTYPE)
- Iterieren über Ergebnislisten mittels Cursor (sowohl manuell OPEN/FETCH/CLOSE als auch mit CURSOR-FOR Schleife)
- Trigger: DML Trigger auf Statement- und Zeilen-Ebene, Zugriff / Ändern von Spalten-Werten mit :OLD/:NEW
