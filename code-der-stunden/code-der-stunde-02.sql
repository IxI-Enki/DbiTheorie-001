set serveroutput on;

-- PLSQL - Wiederholung

-- Anonymer Block
BEGIN
    dbms_output.put_line('hello world');
END;


-- Stored Function
CREATE OR REPLACE FUNCTION HELLO_WORLD_NO_FUN(no NUMBER) RETURN VARCHAR IS
BEGIN
    RETURN 'Hello World No. ' || no;
END;

-- Aufruf einer Stored Function über einen Anonymen Block
-- Functions/Procedures können sich natürlich auch gegenseitig aufrufen
DECLARE
    res VARCHAR(32);
BEGIN
    res := HELLO_WORLD_NO_FUN(10);
    dbms_output.put_line(res);
END;

-- Großer Vorteil von Functions - diese können in einem Select verwendet werden,
-- und entweder mit fixen Argumenten aufgerufen werden oder Zeilenweise die Daten einer Abfrage verarbeiten.
-- Im Gegenzug haben Functions verglichen mit Prozeduren folgende Einschränkungen: nur ein Rückgabewert, nur IN-Parameter, dürfen keine DML/DDL-Statements enthalten
SELECT HELLO_WORLD_NO_FUN(10); -- fixe Argumente
SELECT ename, ename, HELLO_WORLD_NO_FUN(empno) FROM emp; -- Zeilenweiser Aufruf

-- Schleifen
DECLARE
    cnt NUMBER := 10;
BEGIN
    -- flexibelste Schleifenform: Endlosschleife mit EXIT (="break")
    LOOP
        dbms_output.put_line('hallo ' || cnt);
        cnt := cnt - 1;
        
   -- EXIT ohne Bedingung -> Bedingung muss über IF realisiert werden
   --IF cnt <= 0 THEN
   --    EXIT;
   --END IF;
   -- exit when -> EXIT wird nur aktiv, wenn Bedingung wahr ist
   EXIT WHEN cnt <= 0;
    END LOOP;
    
  -- While
  cnt := 10;
  WHILE cnt > 0 LOOP
      dbms_output.put_line('hallo ' || cnt);
      cnt := cnt - 1;
  END LOOP;
    
  -- Zählschleife
  FOR i IN 1..10 LOOP
   dbms_output.put_line('hallo ' || i);
  END LOOP;
END;


-- DB-Abfrae mit INTO erwartet genau 1 Ergebniszeile, 0 oder n Zeilen führen zu Abbruch mit Fehler
-- Dabei können einzelne Spalten in einzelne Variablen geladen werden, oder mehrere Spalten in sogenannte "records".
-- Ein Record entspricht einer Struktur in C
DECLARE
    cursal NUMBER; -- Variable mit fixem Datentyp
    curcomm emp.comm%TYPE; --variable mit Typ aus der DB - in dem Fall Datentyp der Spalte comm von Tabelle emp
    curemp emp%ROWTYPE; -- record, welcher einer Zeile der Tabelle emp entspricht (ROWTYPE)
BEGIN
    SELECT sal, comm INTO cursal, curcomm FROM emp WHERE empno=7839; -- Laden von mehreren Einzelspalten in einzelne Variablen
    SELECT * INTO curemp FROM emp WHERE empno=78391; -- Laden einer ganzen Zeile in einen record
    dbms_output.put_line(curemp.empno); -- Elemente eines Records können mit "." dereferenziert werden
END;

-- CURSOR
-- Sollen von einer Abfarge mehrere Zeilen verarbeitet werden, so müssen Cursor verwendet werden
-- Cursor haben den Vorteil, dass Ergebnisse Zeile-für-Zeile geladen werden, daher können auch sehr große Ergebnisse effizient verarbeitet werden (und müssen nicht zuerst vollständig in den Speicher geladen werden)
DECLARE
    CURSOR empcur IS SELECT * FROM emp; -- Ein Cursor wird wie eine Variable deklariert, die die auszuführende Abfrage enthält
    temp_emp emp%ROWTYPE; -- Da die Spaltenwerte des Cursors nicht direkt ausgelesen werden, benötigen wir noch eine Variable, die die Werte der aktuellen zeile aufnehmen kann.
BEGIN
    OPEN empcur; -- OPEN "öffnet" den Cursor, die DB-Abfrage wird ausgeführt
    
 -- Anschließend werden die Daten Zeile für Zeile vom Cursor in die Variable gefetched und können anschließend verarbeitet werden.
 LOOP
  FETCH empcur INTO temp_emp; -- Laden der aktuellen Spaltenwerte in Variable, Cursor geht dabei automatisch in die nächste Ergebniszeile
  
  -- Ob ein gültiges Ergebnis geholt werden konnte, steht in den Attributen FOUND und NOTFOUND. 
  -- War der Cursor z.B. bereits bei der letzten Ergebniszeile und wird nun FETCH angewiesen, die nächste (nicht existierende) Zeile zu laden, so wird das FETCH nicht durchgeführ und stattdessen das Attribut NOTFOUND gesetzt
  EXIT WHEN empcur%NOTFOUND;  
  
  -- Analog dazu gibt es FOUND, hier nicht unbedingt notwendig -> Schleife wäre durch EXIT WHEN bereits abgebrochen worden.
  IF empcur%FOUND THEN
      dbms_output.put_line('nächstes Ergebnis:');
      dbms_output.put_line(temp_emp.ename);
  END IF;
 END LOOP;
 
 -- ein geöffneter Cursor muss wieder geschlossen werden
 CLOSE empcur;
END;


DECLARE
    CURSOR empcur IS SELECT * FROM emp WHERE sal BETWEEN 1000 AND 3000;
BEGIN
    -- Kurzform: Cursor-For Schleife
    -- Erledigt alles automatisch, dafür weniger flexibel
    -- Record-Variable mit Spalten der Abfrage, OPEN & CLOSE, FETCH und EXIT WHEN
    FOR temp_emp IN empcur LOOP
        dbms_output.put_line(temp_emp.ename);
    END LOOP;
END;



Schreiben Sie eine Stored Function names EMP_FAIRNESS_CHECK, 
welche zu große Gehaltssprünge in der EMP-Tabelle erkennt.
Wenn ein Mitarbeiter mehr als 1500€ mehr verdient als der nächst-bestverdienende Mitarbeiter, 
so soll der Funktion den Wert "unfair" zurückgeben, ansonsten "fair".
