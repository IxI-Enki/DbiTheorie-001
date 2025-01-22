-- Materialized View
-- Materialized Views sind eigentlich Tabellen, die die Daten der angegebenen Query enthalten.
-- Sie haben den Vorteil, dass anders als bei einem View die hinterlegte Query nicht bei jeder Abfrage
-- erneut ausgeführt werden muss, dafür benötigten Sie Speicherplatz.
-- Das Ergebnis der Query wird also gewissermaßen "gecached".

-- Normaler View:
CREATE VIEW highsal_emps_nonmat AS
SELECT e.*, d.dname FROM emp e JOIN dept d ON (e.deptno=d.deptno) WHERE e.sal > 3000;

-- Explain Select auf Query -> Query des Views wird intern abgearbeitet
SELECT * FROM highsal_emps_nonmat;

-- Materialized View:
CREATE MATERIALIZED VIEW highsal_emps 
--REFRESH ON COMMIT
AS
SELECT * FROM emp e JOIN dept d ON (e.deptno=d.deptno) WHERE e.sal > 3000;

-- Select auf Materialized View -> Wie Zugriff auf normale, flache Tabelle
SELECT * FROM highsal_emps;

-- Bei einem Materialized View muss man sich jedoch entscheiden, wann die
-- Query ausgeführt werden soll (= der Cache neu aufgebaut wird).
-- Per Default muss dies manuell erfolgen (bei Oracle über folgende PLSQL-Prozedur):
BEGIN
dbms_mview.refresh('highsal_emps');
END;

-- es ist aber auch z.B. REFRESH ON COMMIT möglich, dabei wird der Cache nach dem Commit
-- bei Änderungn an einer der in der Query beteiligten Tabellen neu aufgebaut (kann relativ teuer werden).
-- Weiters ist auch ein zeitgesteuertes Update möglich (z.B. jede Stunde).

SELECT * FROM emp;
UPDATE emp SET sal=2450 where empno=7782;
SELECT * FROM highsal_emps;


--- PLSQL

-- Notwendig um Debug-Ausgabe im SQLDeveloper angezeigt zu bekommen
SET SERVEROUTPUT ON;

-- Anonymer Block
-- Variablen werden im DECLARE-Teil deklariert
DECLARE
    mytime NUMBER(4) := 2024;
BEGIN
    dbms_output.put_line('Hallo Welt ' || mytime); -- Ausgabe
END;

-- Stored Function, mehrere Parameter, ein Rückgabewert:
CREATE OR REPLACE FUNCTION greeter(year NUMBER) RETURN VARCHAR IS
BEGIN
    dbms_output.put_line('Hallo Welt ' || year);
    IF year <= 2022 THEN
        RETURN 'YOU LIVE IN THE PAST';
    ELSIF year = 2023 THEN
        RETURN 'Letztes Jahr';
    ELSE
        RETURN 'Gegenwart oder Zukunft';
    END IF;
END;

-- kann entweder aus anonymen Block ausgeführt werden.
-- Achtung, Rückgabewert muss zugewiesen werden(!)
DECLARE
 greet_result VARCHAR(32);
BEGIN
    greet_result := greeter(2022);
    dbms_output.put_line(greet_result);
END;

-- Oder auch direkte Verwendung im Select-Teil möglich (nur bei Funktionen, nicht für Prozeduren möglich)
SELECT greeter(sal) FROM emp;

-- Stored Procedure: kein Rückgabewert, dafür mehrere OUT-Parameter möglich
-- Datenbank-Änderungen nur in Prozeduren, nicht in Funktionen erlaubt
-- Beispiel: gehaltserhöhung für eine Abteilung, deren Name übergeben wird um den Betrag salraise,
-- Rückgabe: Summe der gehaltserhöhungen.
CREATE OR REPLACE PROCEDURE salraise_dname(dname_param IN VARCHAR, salraise IN NUMBER, costs OUT NUMBER) IS
BEGIN
    UPDATE emp SET sal=sal+salraise WHERE deptno = (SELECT deptno FROM dept WHERE dname=dname_param);
    SELECT (COUNT(*) * salraise) INTO costs FROM emp WHERE deptno = (SELECT deptno FROM dept WHERE dname=dname_param);
END;

-- Aufruf Prozedur
DECLARE
 salraise_result NUMBER;
BEGIN
    salraise_dname('RESEARCH', 100, salraise_result);
    dbms_output.put_line(salraise_result);
END;











CREATE MATERIALIZED VIEW low_sal_emps
REFRESH ON COMMIT
AS
SELECT * FROM emp WHERE sal < 2500;


select * from low_sal_emps;

begin
dbms_mview.refresh('low_sal_emps');
end;


 