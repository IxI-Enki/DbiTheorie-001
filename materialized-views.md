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