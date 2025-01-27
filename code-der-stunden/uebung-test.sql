
DROP SEQUENCE PK_ITEMS;
--
CREATE SEQUENCE PK_ITEMS 
  START WITH 1
  INCREMENT BY 1
  NOCYCLE
  ;

---------------------------------------------------------- 

DROP TABLE ITEMS CASCADE CONSTRAINT;
--
CREATE TABLE Items
( 
  id   NUMBER , 
  name varchar(60),
  
  CONSTRAINT PK_items PRIMARY KEY(id)
);
--------------------------
ALTER TABLE Items ADD CONSTRAINT unique_items UNIQUE(name);
--
ALTER TABLE ITEMS ADD value NUMBER; 
--
ALTER TABLE ITEMS ADD CONSTRAINT valid_value check (value is NOT NULL and value >= 0); 

---------------------------------------------------------- 

CREATE or REPLACE 
    TRIGGER PK_inkrement_ITEMS 
      BEFORE INSERT 
    ON ITEMS 
      FOR EACH ROW
  
  BEGIN
        SELECT pk_ITEMS.nextval into :NEW.id from dual;
  END;
  /

---------------------------------------------------------- 

CREATE OR REPLACE 
    TRIGGER ITEM_SORTIMENT_LOG 
      BEFORE UPDATE 
      OR INSERT
    ON ITEMS 
      FOR EACH ROW

  DECLARE
    CURSOR ALL_ITEMS IS SELECT * FROM ITEMS;
    ADDED BOOLEAN := TRUE;

  BEGIN 
      FOR TEMP_ROW IN ALL_ITEMS LOOP
      
        IF :NEW.ID = TEMP_ROW.ID OR :NEW.value < 0 THEN
          DBMS_OUTPUT.PUT_LINE
            ( 'New Item: ' || :New.Name || ' [Id: ' || :New.Id || '] Can´t Be Added.' );  
      
          ADDED := FALSE;
          EXIT;
        END IF;
      
      END LOOP;

      IF ADDED = TRUE THEN
        DBMS_OUTPUT.PUT_LINE
          ( 'New Item: ' || :New.Name || ' [Id: ' || :New.Id || '] Was Added.' );
      
      END IF;
  END; 
  /

--------------------------

drop TABLE inventory ;
CREATE TABLE inventory (
  invent_id NUMBER
  ,amount    NUMBER
  ,CONSTRAINT fk_items_id FOREIGN KEY ( invent_id )
    REFERENCES items ( id )
);

-- SELECT * FROM inventory;

---------------------------------------------------------- 

CREATE OR REPLACE 
    PROCEDURE add_item( iname IN VARCHAR , ivalue IN NUMBER )
AS
  BEGIN
        INSERT into  ITEMS ( name,  VALUE) VALUES ( iname, ivalue);
  END;
  /
--------------------------
CREATE OR REPLACE 
    PROCEDURE remove_item(item_id in NUMBER)
AS
  BEGIN
        DELETE FROM ITEMS WHERE id = item_id;
  END;
  /

---------------------------------------------------------- 

CREATE OR REPLACE 
    FUNCTION GET_ITEM_ID( INAME VARCHAR2)
    RETURN NUMBER
IS
  RES NUMBER := 0;
BEGIN 
    SELECT ID INTO RES FROM ITEMS WHERE NAME = INAME;
   RETURN RES;
END;
/

CREATE OR REPLACE 
    PROCEDURE add_to_inventory( iname IN VARCHAR , iamount IN NUMBER )
IS
  id NUMBER := GET_ITEM_ID(iname);
  BEGIN
        INSERT into INVENTORY (invent_id,amount) VALUES ( id, iamount);
        DBMS_OUTPUT.PUT_LINE(iamount|| ' of the Item: ' || iname || ' added to Inventory');
  END;
  /


---------------------------------------------------------- 
---------------------------------------------------------- 
SELECT * FROM ITEMS;
SELECT * FROM INVENTORY;
---------------------------------------------------------- 
--
-- INSERT into ITEMS VALUES(1, 'Master-sword', 7777.77 );
-- INSERT into ITEMS VALUES(2, 'Wooden-sword', 10 );
-- INSERT into ITEMS (name, value) VALUES( 'Steel-sword' , 420 );
-- 
-- INSERT into ITEMS VALUES(4, 'minus-sword' , -420 );
--
---------------------------------------------------------- 
---------------------------------------------------------- 


BEGIN
 ADD_ITEM( 'Wooden-sword', 10 );
 ADD_ITEM('Steel-sword' , 420 );
 ADD_ITEM('Master-sword', 7777.77 );

 REMOVE_ITEM(2);

 ADD_ITEM('Steel-sword' , 420 );
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(GET_ITEM_ID('Wooden-sword'));
end;
/
---------------------------------------------------------- 
BEGIN
  ADD_TO_INVENTORY('Wooden-sword', 2);
  ADD_TO_INVENTORY('Master-sword', 1);
END;
/
---------------------------------------------------------- 
SELECT it.id, i.AMOUNT, it.NAME, it.VALUE FROM INVENTORY i JOIN ITEMS it ON(it.ID = i.INVENT_ID);
---------------------------------------------------------- 

create or replace trigger stackable_items_trigger
before INSERT 
on INVENTORY
DECLARE
  newid NUMBER := null;
BEGIN
  if :NEW.id is NOT NULL then
    DBMS_OUTPUT.PUT_LINE(:New.id);

 end if;
  
end;
/

SET SERVEROUTPUT ON;
drop TRIGGER STACKABLE_ITEMS_TRIGGER;

BEGIN
  ADD_TO_INVENTORY('Wooden-sword', 2);
END;
/


UPDATE INVENTORY set amount = (amount+1) where (1= invent_id) ;

SELECT it.id, i.AMOUNT, it.NAME, it.VALUE FROM INVENTORY i JOIN ITEMS it ON(it.ID = i.INVENT_ID);

DESCRIBE INVENTORY;

---------------------------------------------------------- 
 
 create or replace PROCEDURE clear_inventory 
 is
   cursor ts is select * from inventory; 
 begin
  for t in ts LOOP
    DELETE from INVENTORY where invent_id = t.invent_id;
  end loop;
      DBMS_OUTPUT.PUT_LINE('Inventory emptied');
 end;
 /

BEGIN
  CLEAR_INVENTORY();
end;
/

---------------------------------------------------------- 

drop MATERIALIZED view items_in_inventory;
create MATERIALIZED view items_in_inventory REFRESH on COMMIT AS
  SELECT sum(i.AMOUNT) as "anzahl", t.NAME as "bezeichnung" from INVENTORY i join items t on(i.INVENT_ID = t.ID) group by t.NAME;

SELECT * from ITEMS_in_inventory;


drop MATERIALIZED view ALL_items_in_inventory;
create MATERIALIZED view ALL_items_in_inventory REFRESH on COMMIT AS
  SELECT sum(i.AMOUNT) from INVENTORY i join items t on(i.INVENT_ID = t.ID);

SELECT * from ALL_ITEMS_in_inventory;

---------------------------------------------------------- 

BEGIN
  ADD_TO_INVENTORY('Master-sword', 1);
--  ADD_TO_INVENTORY('Wooden-sword', 2);
--  ADD_TO_INVENTORY('Wooden-sword', 4);
--  ADD_TO_INVENTORY('Wooden-sword', 4);
END;
/
COMMIT;
select * from VALUE_IN_INVENTORY;

---------------------------------------------------------- 

-- SELECT sum(i.AMOUNT * t.value) from INVENTORY i join items t on (t.id = i.INVENT_ID) ;
create MATERIALIZED view value_in_inventory REFRESH on COMMIT as 
  SELECT sum(i.AMOUNT * t.value) from INVENTORY i join items t on (t.id = i.INVENT_ID) ;

select * from VALUE_IN_INVENTORY;

---------------------------------------------------------- 

create or replace FUNCTION AVG_VALUE_OF_ONE_item_in_inventory 
RETURN NUMBER 
IS
val_items NUMBER := 0;
sum_items NUMBER := 0;
BEGIN
  select * into val_items from VALUE_IN_INVENTORY;
  select * into sum_items from ALL_ITEMS_IN_INVENTORY;

  return val_items / sum_items;
  END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE(ROUND(AVG_VALUE_OF_ONE_item_in_inventory,3));
END;
/

---------------------------------------------------------- 

