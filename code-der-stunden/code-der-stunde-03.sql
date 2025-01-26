-- Beispielabfrage für Optimierungsbeispiel
select * from matches m 
    join players p on (m.playerno=p.playerno) 
    join teams t on (t.teamno=m.teamno) 
    WHERE p.name='Parmenter' AND m.lost > 0;
    
-- Trigger erlauben, auf gewisse Ereignisse zu reagieren (und ev. auch einzugreifen).
-- siehe Folien.

-- CREATE [OR REPLACE] TRIGGER triggername
-- {BEFORE|AFTER|INSTEAD OF}
-- {INSERT|UPDATE|DELETE [OF col_name1[,col_name2,...]]}
-- [OR {INSERT|UPDATE|DELETE [OF col_name1[,col_name2,...]]}…]
-- ON tab_name
-- [REFERENCES [OLD [AS] old_refname] [NEW AS new_refname]]
-- [FOR EACH ROW [WHEN bedingung]]


CREATE OR REPLACE TRIGGER emp_sal_check BEFORE UPDATE OR INSERT 
 OR DELETE
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


-- DROP TRIGGER EMPLOG;

-- Test
set serveroutput on;

update emp set sal =1000 where ename='KING';

insert into emp (empno, ename, sal) values (1234, 'test', 5000);

DELETE   FROM emp WHERE emp.ename = 'test';



select * from emp;