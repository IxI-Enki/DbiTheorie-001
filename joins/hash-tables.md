# Hash Tables

  - #### Hash-Tabellen ( *Hash-Maps* ):  
      > - speichern **Schlüssel-Wert-Paare**,
      > - sind darauf optimiert schnellen Zugriff auf die Werte basierend auf ihren Schlüsseln zu ermöglichen. 

    ---

- ### Eigenschaften:

  - #### Schneller Zugriff:
    - Hash-Tabellen bieten im Durchschnitt eine **konstante Zeitkomplexität O(1)** für Einfügen, Löschen und Suchen von Elementen.  
      > Dies gilt jedoch ***nur bei einer guten Verteilung der Hash-Werte*** und einer ausreichenden Größe der Tabelle.

  - #### Hash-Funktion:
    - Jeder **Schlüssel** wird durch eine **Hash-Funktion** in einen **Index** umgewandelt, der als Position in der Tabelle dient. 
    - Die **Qualität der Hash-Funktion** ist entscheidend für die
      **Performance**: Sie sollte konsistent und möglichst gleichmäßig verteilen.

  - #### Kollisionen:
    - Wenn zwei **verschiedene Schlüssel auf denselben Index** hash-en (Kollision), 
    müssen **diese Schlüssel** auf irgendeine Weise **verwaltet** werden.

  - #### Lastfaktor:
    - Der Lastfaktor (**Anzahl der Elemente / Größe der Tabelle**) beeinflusst die Leistung. 
      > Ein **hoher Lastfaktor** kann zu mehr **Kollisionen** führen, was die Zugriffszeit erhöht.

  - #### Dynamische Größenanpassung:
    - Viele Hash-Tabellen implementieren eine Methode zur Größenanpassung (resizing), 
      um den Lastfaktor zu kontrollieren
      > indem sie die Tabelle vergrößern (und alle Elemente neu hashen), wenn sie zu voll wird.

    ---

- ### Funktionsweise:
  
  - #### Einfügen (Insert):
    Ein **Schlüssel** wird **gehasht**, um einen **Index** zu erhalten.
    Der **Wert** wird dann an dieser Stelle **gespeichert**. 
    > Bei einer Kollision wird das Element entweder an die gleiche Stelle in einer verketteten Liste (chaining) oder in eine andere freie Position verschoben (offene Adressierung).
    
  - #### Suchen (Search):
    Der **Schlüssel** wird **gehasht**, um den **Index** zu **finden**, wo der Wert gespeichert sein sollte.
    Wenn es keine Kollisionen gibt, ist der **Wert** direkt **zugänglich**. 
    > Bei Kollisionen wird die Liste am Index durchsucht oder bei offener Adressierung wird nach dem nächsten freien Platz gesucht.

  - #### Löschen (Delete):
    Ähnlich wie beim Suchen wird der **Index des Schlüssels** gefunden.  
    Das **Element** wird dann **entfernt**.  
    > Bei verketteten Listen könnte man Platzhalter (Tombstones) hinterlassen, um die Struktur für zukünftige Suchen zu erhalten.

  - #### Kollisionsbehandlung:
    - **Chaining**: Jedes Element in der Hash-Tabelle ist der Kopf einer verketteten Liste.  
      > Wenn eine Kollision auftritt, wird das neue Element einfach an die Liste angehängt.  

    - **Offene Adressierung**: Wenn eine Position besetzt ist, wird nach einer anderen freien Position gesucht
      > zB durch lineares Sondieren, quadratisches Sondieren oder doppeltes Hashing.

  - #### Resizing:
    Wenn der Lastfaktor zu hoch wird, wird die Tabelle vergrößert (meist verdoppelt), und alle Elemente müssen neu gehasht und platziert werden.

  ---

- > *Hash-Tabellen sind **extrem nützlich** in vielen Anwendungen, wo **schnelle Zugriffe** auf Daten erforderlich sind.* 
  
- > *Ihre **Effizienz hängt** stark von der Qualität der **Hash-Funktion** und der **Kollisionsstrategie** ab.*

---