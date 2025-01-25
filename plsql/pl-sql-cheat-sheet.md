### Grundlagen von PL/SQL
### Architektur von PL/SQL
- #### Blockstruktur: *PL/SQL besteht aus Blöcken, die aus drei Teilen bestehen*:
  - **Declarative Part**: *Hier werden Variablen, Konstanten und Cursor deklariert*.
  - **Executable Part**: *Hier wird der eigentliche Code ausgeführt*.
  - **Exception Handling Part**: *Optional, für Fehlerbehandlung*.

## Variablen
- **Deklaration**: `VARIABLE_NAME datatype [:= value];`
  - Beispiele:
    ```sql
    DECLARE
        v_number NUMBER := 10;
        v_name VARCHAR2(50) := 'John';
    BEGIN
        -- Code hier
    END;
    ```

## Zuweisungen
- **Zuweisen von Werten**: `variable := value`;
  - Beispiel:
    ```sql
    v_number := 20;
    ```

## Kontrollstrukturen
- **`IF`/`THEN`/`ELSE`**:

   ```sql
  IF condition THEN
      -- Statements
  ELSIF another_condition THEN
      -- Statements
  ELSE
      -- Statements
  END IF;
  ```

<br>

---
## Schleifen:
  - ### Simple `LOOP`: 
    ```sql
    LOOP
        -- Statements
        EXIT WHEN condition;
    END LOOP;
    ```

  - ### `FOR` Loop: 
    ```sql
    FOR i IN 1..10 LOOP
        -- Statements
    END LOOP;
    ```

  - ### `WHILE` Loop:
    ```sql
    WHILE condition LOOP
        -- Statements
    END LOOP;
    ```

<br>

---
## Anonyme Blöcke

- **Definition**: Ein anonymer Block ist ein PL/SQL-Block, der nicht benannt ist und direkt ausgeführt wird.
  ```sql
  BEGIN
      -- Statements hier
  END;
  ```

## Stored `FUNCTIONS`
- **Eigenschaften**: Funktionen, die in der Datenbank gespeichert und von SQL oder PL/SQL aufgerufen werden können.

- **Erstellen**:  
 
  ```sql
  CREATE FUNCTION function_name (param1 datatype, ...)
  RETURN datatype IS
  BEGIN
      -- Statements
      RETURN return_value;
  END;
  ```

- **Aufruf**: `SELECT function_name(param1, ...) FROM dual;`

## Stored `PROCEDURES`  
- **Eigenschaften**: Ähnlich wie Funktionen, aber geben keinen Wert zurück, sondern führen Operationen durch.  
  
- **Erstellen**:  
  ```sql
  CREATE PROCEDURE procedure_name (param1 datatype, ...)
  IS
  BEGIN
      -- Statements
  END;
  ```
- **Aufruf**: `EXECUTE procedure_name(param1, ...);`

<br>

---
## Datenbankzugriff
### Lesen einer Zeile mittels `SELECT` ... `INTO`
- ### In skalare Variablen:
  ```sql
  DECLARE
      v_emp_id NUMBER;
      v_emp_name VARCHAR2(50);
  BEGIN
      SELECT employee_id, last_name INTO v_emp_id, v_emp_name
      FROM employees WHERE employee_id = 100;
  END;
  ```

- ### Mit `%TYPE` und `%ROWTYPE`:
  - `%TYPE`: Behält den **Datentyp der Spalte** bei:
    ```sql
    v_emp_id employees.employee_id%TYPE;
    ```

  - `%ROWTYPE`: Für eine ganze **Zeile als Record**:
    ```sql
    v_emp_row employees%ROWTYPE;
    SELECT * INTO v_emp_row FROM employees WHERE employee_id = 100;
    ```
<br>

---
## Iterieren über Ergebnislisten mittels Cursor
### Manuelles `OPEN`/`FETCH`/`CLOSE`
  ```sql
  DECLARE
      CURSOR emp_cursor IS
          SELECT employee_id, last_name FROM employees;
      v_emp_id NUMBER;
      v_emp_name VARCHAR2(50);
  BEGIN
      OPEN emp_cursor;
      LOOP
          FETCH emp_cursor INTO v_emp_id, v_emp_name;
          EXIT WHEN emp_cursor%NOTFOUND;
          -- Code hier
      END LOOP;
      CLOSE emp_cursor;
  END;
  ```

<br>

---
## `CURSOR-FOR` Schleife
  ```sql
  DECLARE
      CURSOR emp_cursor IS
          SELECT employee_id, last_name FROM employees;
  BEGIN
      FOR emp_rec IN emp_cursor LOOP
          -- Code hier mit emp_rec.employee_id und emp_rec.last_name
      END LOOP;
  END;
  ```
  
  <br>
  
---
## Trigger
### DML Trigger
- **Statement-Level Trigger**: Führt ein Mal pro SQL-Anweisung aus.
- **Row-Level Trigger**: Führt für jede betroffene Zeile aus.
- *Erstellen eines Triggers*:

  ```sql
  CREATE OR REPLACE TRIGGER trigger_name
  BEFORE/AFTER INSERT/UPDATE/DELETE ON table_name
  FOR EACH ROW
  BEGIN
      IF :NEW.column_name IS NOT NULL THEN
          -- Logik hier
      END IF;
  END;
  ```
  - `:OLD` und `:NEW` sind spezielle Pseudorecords, die auf alte und neue Werte zugreifen.
