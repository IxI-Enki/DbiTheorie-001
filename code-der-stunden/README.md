<!--  ▶ ► ▻ ▸ ▹  -->

- ### ▷ Normaler View

  ```sql
  CREATE VIEW highsal_emps_nonmat 
    AS SELECT 
      e.* , 
      d.dname 
      FROM emp e JOIN dept d ON ( e.deptno = d.deptno ) 
        WHERE e.sal > 3000;
  ```

  - ##### Erklärung des **`Select`** auf **`View`**:
    > *Query des Views wird intern abgearbeitet*
    > ```sql
    > SELECT * FROM highsal_emps_nonmat;
    > ```

-------------------------------------------------------------------------------
<!--────────────────────────────────────────────────────────────────────────-->

- ### ▷ Materialized View

  > - Materialized Views sind eigentlich **Tabellen**, die **die Daten** der angegebenen **Query enthalten**.  
  > - Sie haben den **Vorteil**, dass anders als bei einem View die hinterlegte **Query nicht** bei jeder > Abfrage **erneut ausgeführt** werden muss, dafür **benötigten** Sie **Speicherplatz**.  
  > - Das **Ergebnis** der Query wird also gewissermaßen "**gecached**".  

  ---
  ```sql
  CREATE MATERIALIZED VIEW highsal_emps 
    -- REFRESH ON COMMIT
    AS 
    SELECT * 
      FROM emp e JOIN dept d ON (e.deptno=d.deptno) 
        WHERE e.sal > 3000;
  ```

  - ##### Erklärung des **`Select`** auf **`Materialized View`**:
      > *Zugriff wie auf normale, flache Tabelle*:
      > ```sql
      > SELECT * FROM highsal_emps;
      > ```
      
  - Bei einem Materialized View muss man sich jedoch entscheiden, wann die Query ausgeführt werden soll. 
      > *( der **Cache neu aufgebaut** wird )*  

    - Per Default muss dies manuell erfolgen.  
      > *bei **Oracle über** folgende **PLSQL-Prozedur**:*
      > ```sql
      > BEGIN
      >     dbms_mview.refresh( 'highsal_emps' );
      > END;
      > ```

      - Es ist zB. auch `REFRESH ON COMMIT` möglich.   
        > *dabei wird der Cache nach dem Commit bei Änderungn an einer der in der Query beteiligten Tabellen neu aufgebaut.*  
        ( **kann relativ teuer werden** )
      - Weiters ist auch ein zeitgesteuertes Update möglich.  
        > ( *zB. jede Stunde* )
      
<!--
      ```sql
      SELECT * FROM emp;
        UPDATE emp 
          SET sal=2450 
            WHERE empno=7782;

      SELECT * FROM highsal_emps;
      ```
-->
    ---

    *Weiteres Beispiel*:  

    ```sql
    CREATE 
      MATERIALIZED VIEW low_sal_emps
        REFRESH ON COMMIT
    AS
      SELECT * FROM emp WHERE sal < 2500;
   
    SELECT * FROM low_sal_emps;
   
    BEGIN
        dbms_mview.refresh( 'low_sal_emps' );
    END;
    ```

-------------------------------------------------------------------------------
<!--========================================================================-->

<div pagebreak="always"></div>

- # PLSQL

  > ```sql
  > SET SERVEROUTPUT ON;
  > ```
  > Notwendig um Debug-Ausgabe im SQLDeveloper anzuzeigen

  - ## Anonymer Block

    - ###### **Variablen** werden im `DECLARE`-Teil deklariert
      ```sql
      DECLARE
        mytime NUMBER( 4 ) := 2024;
      BEGIN
          dbms_output.put_line( 'Hallo Welt ' || mytime ); -- Ausgabe
      END;
      ```
  ---
  - ## Stored Function

    - ###### **mehrere** Parameter, **ein** Rückgabewert:
      ```sql
      CREATE or REPLACE 
        FUNCTION greeter( year NUMBER ) 
          RETURN VARCHAR 
        IS
        BEGIN
            dbms_output.put_line( 'Hallo Welt ' || year );
        
            IF year <= 2022 THEN
              RETURN 'Vergangenheit';
            
            ELSIF year = 2023 THEN
              RETURN 'Letztes Jahr';
            
            ELSE
              RETURN 'Gegenwart oder Zukunft';

            END IF;            
        END;
      ```

    - Kann entweder aus **anonymen Block** ausgeführt werden.
        > - *Achtung, Rückgabewert muss zugewiesen werden*( **!** )

      ```sql
      DECLARE
        greet_result VARCHAR( 32 );
      BEGIN
          greet_result := greeter( 2022 );
          dbms_output.put_line( greet_result );
      END;
      ```
    - Oder auch **direkte** Verwendung im **`Select`-Teil** möglich 
      > ***nur*** *bei* ***Funktionen***,  
      > ***nicht*** *für* ***Prozeduren*** *möglich*

      ```sql
      SELECT greeter( sal ) FROM emp;
      ```

  ---
  - ## Stored Procedure: 
    - ###### **kein** Rückgabewert, dafür **mehrere** `OUT`-Parameter
    - ###### **Datenbank-Änderungen** nur in **Prozeduren**, *nicht in Funktionen* erlaubt

      *Beispiel* **`Procedure`**:  
        > *Gehaltserhöhung für eine Abteilung, deren Name übergeben wird um den Betrag salraise, die Summe der Gehaltserhöhungen soll zurück gegeben werden:*
      ```sql
      CREATE OR REPLACE 
        PROCEDURE salraise_dname
        ( dname_param IN  VARCHAR , 
          salraise    IN  NUMBER , 
          costs       OUT NUMBER ) 
        IS
        BEGIN
            UPDATE emp 
               SET sal = sal + salraise 
                 WHERE deptno = ( SELECT deptno 
                                    FROM dept 
                                      WHERE dname=dname_param );
            SELECT ( COUNT(*) * salraise ) 
              INTO costs 
                FROM emp 
                  WHERE deptno = ( SELECT deptno 
                                     FROM dept 
                                       WHERE dname=dname_param );
          END;
      ```
      *Aufruf*:
      ```sql
      DECLARE
        salraise_result NUMBER;
      BEGIN
          salraise_dname( 'RESEARCH' , 100 , salraise_result );
          dbms_output.put_line( salraise_result );
      END;
      ```
-------------------------------------------------------------------------------
<!--========================================================================-->

- ### PLSQL - Wiederholung

  > ```sql
  > SET SERVEROUTPUT ON;
  > ```

  - #### Anonymer Block
    ```sql
    BEGIN
        dbms_output.put_line('hello world');
    END;
    ```

  - #### Stored `Function`
    ```sql
    CREATE OR REPLACE 
      FUNCTION HELLO_WORLD_NO_FUN( no NUMBER ) 
        RETURN VARCHAR 
      IS
      BEGIN
          RETURN 'Hello World No. ' || no;
      END;
    ```

  - #### Aufruf einer Stored Function über einen Anonymen Block
    ```sql
    DECLARE
      res VARCHAR( 32 );
    BEGIN
        res := HELLO_WORLD_NO_FUN( 10 );
        dbms_output.put_line( res );
    END;
    ```
    > Functions/Procedures können sich natürlich auch gegenseitig aufrufen
    ---

  - ##### Großer Vorteil von Functions: 
    > **Können in einem `Select` verwendet werden**, 
    > und entweder mit fixen **Argumenten** aufgerufen werden 
    > oder **Zeilenweise** die Daten einer Abfrage verarbeiten.
  - ##### Im Gegenzug haben Functions verglichen mit Prozeduren folgende Einschränkungen: 
    > nur **ein Rückgabewert**, 
    > **nur `IN`**-Parameter, 
    > dürfen **keine** **`DML/DDL`**-Statements enthalten.
  
  	```sql
  	SELECT HELLO_WORLD_NO_FUN( 10 ); -- fixe Argumente
  
  	SELECT 
  	  ename ,
  	  empno ,
  	  HELLO_WORLD_NO_FUN( empno ) FROM emp; -- Zeilenweiser Aufruf
  	```

---


- ### `LOOP`*s*

  ```sql
  DECLARE
    cnt NUMBER := 10;
  BEGIN
      
   -- Endlosschleife mit EXIT (="break"):
      LOOP
        ------
          dbms_output.put_line('hallo ' || cnt);
          cnt := cnt - 1;
  
          -- IF cnt <= 0 THEN
          --   EXIT; --> EXIT Bedingung muss über IF realisiert werden
          -- END IF;
          EXIT WHEN cnt <= 0; --> EXIT wird aktiv, wenn Bedingung wahr ist
        ------
      END LOOP;
     -----------------------------------
      
   -- WHILE Schleife:
      cnt := 10;
  
      WHILE cnt > 0 LOOP
        ------  
          dbms_output.put_line( 'hallo ' || cnt );
          cnt := cnt - 1;
        ------
      END LOOP;
     -----------------------------------        
  
   -- Zählschleife:
      FOR i IN 1..10 LOOP
        ------
          dbms_output.put_line( 'hallo ' || i );
        ------
      END LOOP;
      -----------------------------------
  END;
  ```

---

- ### `Record`
  - DB-Abfrae mit **`INTO`** erwartet genau **1 Ergebniszeile**, 
    > 0 oder n Zeilen führen zu Abbruch mit Fehler
  - Dabei können **einzelne Spalten** in einzelne **Variablen** geladen werden,  
    oder **mehrere Spalten** in sogenannte "**Records**".
    > Ein *Record* entspricht einer *Struktur in C*
  ---
  ```sql
  DECLARE
    cursal  NUMBER;        -- Variable mit fixem Datentyp
    curcomm emp.comm%TYPE; -- Variable mit TYP aus der DB - in dem Fall Datentyp der Spalte comm von Tabelle emp
    curemp  emp%ROWTYPE;   -- Record, welcher einer Zeile der Tabelle emp entspricht (ROWTYPE)
  BEGIN
      -- Laden von mehreren Einzelspalten in einzelne Variablen:
      SELECT sal, comm INTO cursal, curcomm FROM emp WHERE empno=7839;#

      -- Laden einer ganzen Zeile in einen record:
      SELECT * INTO curemp FROM emp WHERE empno=78391; 
      
      -- Elemente eines Records können mit "." dereferenziert werden:
      dbms_output.put_line(curemp.empno); 
  END;
  ```

---

- ### `CURSOR`
  - `Cursor` müssen verwendet werden wenn von einer **Abfarge mehrere Zeilen verarbeitet** werden. 
  - `Cursor` haben den **Vorteil**, dass **Ergebnisse Zeile-für-Zeile geladen** werden,  
    daher können auch **sehr große Ergebnisse effizient verarbeitet** werden.
    > und müssen **nicht** zuerst **vollständig in den Speiche geladen** werden

  ```sql
  DECLARE
      -- Ein Cursor wird wie eine Variable deklariert, 
      --  die die auszuführende Abfrage enthält:
      CURSOR empcur IS SELECT * FROM emp; 
      -- Da die Spaltenwerte des Cursors nicht direkt ausgelesen werden, 
      --  benötigen wir noch eine Variable, 
      --  die die Werte der aktuellen Zeile aufnehmen kann:
      temp_emp emp%ROWTYPE; 
  BEGIN
      -- OPEN "öffnet" den Cursor, die DB-Abfrage wird ausgeführt:
      OPEN empcur; 

       -- Anschließend werden die Daten Zeile für Zeile vom Cursor in die Variable 
       -- gefetched und können anschließend verarbeitet werden:
      LOOP
        -- Laden der aktuellen Spaltenwerte in Variable, 
        FETCH empcur INTO temp_emp; -- Cursor geht dabei automatisch in die nächste Ergebniszeile

        -- Ob ein gültiges Ergebnis geholt werden konnte, 
        --  steht in den Attributen FOUND und NOTFOUND. 

        -- War der Cursor zB bereits bei der letzten Ergebniszeile und wird nun FETCH angewiesen, 
        --  die nächste (nicht existierende) Zeile zu laden,
        --  so wird das FETCH nicht durchgeführ und stattdessen das Attribut NOTFOUND gesetzt:
        EXIT WHEN empcur%NOTFOUND;  

        -- Analog dazu gibt es FOUND, hier nicht unbedingt notwendig 
        --  Schleife wäre durch EXIT WHEN bereits abgebrochen worden.
        IF empcur%FOUND THEN
            dbms_output.put_line('nächstes Ergebnis:');
            dbms_output.put_line(temp_emp.ename);
        END IF;
      END LOOP;
  
   -- ein geöffneter Cursor muss wieder geschlossen werden:
   CLOSE empcur;
  END;
  ```
  ---
  
  - #### Kurzform: **`Cursor`**-**`For`**-**`LOOP`**
    > Erledigt alles automatisch, dafür weniger flexibel
    ```sql
    DECLARE
        CURSOR empcur IS SELECT * FROM emp WHERE sal BETWEEN 1000 AND 3000;
    BEGIN
        
        -- .. Record-Variable mit Spalten der Abfrage, OPEN & CLOSE, FETCH und EXIT WHEN ..  
        FOR temp_emp IN empcur LOOP
          dbms_output.put_line(temp_emp.ename);
        END LOOP;

    END;
    ```

-------------------------------------------------------------------------------
<!--========================================================================-->


### Beispielabfrage für Optimierungsbeispiel
  
  ```SQL
  select * from matches m 
    join players p on (m.playerno=p.playerno) 
    join teams t on (t.teamno=m.teamno) 
    WHERE p.name='Parmenter' AND m.lost > 0;
  ```

  - Trigger erlauben, auf gewisse Ereignisse zu reagieren (und ev. auch einzugreifen).
    >  siehe Folien.

    - Syntax:
      > CREATE [OR REPLACE] TRIGGER triggername
      > {BEFORE|AFTER|INSTEAD OF}
      > {INSERT|UPDATE|DELETE [OF col_name1[,col_name2,...]]}
      > [OR {INSERT|UPDATE|DELETE [OF col_name1[,col_name2,...]]}…]
      > ON tab_name
      > [REFERENCES [OLD [AS] old_refname] [NEW AS new_refname]]
      > [FOR EACH ROW [WHEN bedingung]]

```SQL
CREATE OR REPLACE TRIGGER emp_sal_check BEFORE UPDATE OR INSERT OR DELETE
ON EMP FOR EACH ROW
DECLARE
BEGIN
    dbms_output.put_line('Sal was:' || :OLD.sal || ' and is now: ' || :NEW.sal);
    
    -- Über :OLD und :NEW kann auf die Spaltenwerte der geänderten Zeile zugegriffen werden
    -- :NEW new bei UPDATE/INSERT
    -- :OLD nur bei UPDATE/DELETE
    IF :NEW.sal < :OLD.sal THEN
        :NEW.sal := :OLD.sal;
    END IF;
END;

DROP TRIGGER EMPLOG;

-- Test
set serveroutput on;

  update emp set sal =1000 where ename='KING';

  insert into emp (empno, ename, sal) values (1234, 'test', 5000);
  
  select * from emp;
```
