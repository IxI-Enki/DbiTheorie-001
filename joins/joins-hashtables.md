
# <p align="center"> `JOIN` </p>

## Introduction

- There are three types of **physical `JOIN`** operators in SQL Server:  
  - $\color{orange}{Nested\ Loops\ Join}$ 
  - $\color{yellow}{Hash\ Match\ Join}$
  - $\color{yellowgreen}{Merge\ Join}$

  > *Depending on **data volume** and the **available indexes**, different types of physical join operators are used.*    

    ---

- *There are different types of* **logical `JOIN`** opperators:
  >   - *Inner Join* 
  >   - *Outer Join (Left, Right, Full)* 
  >   - *Cross Join* 
  >
  > <img src="img/logical-joins.png" alt="logical joins" width=70%>
  > 
---

- ## 1<sub>)</sub> $\color{orange}{Nested\ Loops\ Join}$ 

  *Nested Loops Join has a very simple mechanism*:  
    - The **Table** with a **smaller number** of records is **selected**  
    - It will **loop through** the **second table** until matches are found.  
    
      ---    

      > - $\color{red}{NOT}$ well $\color{red}{scalable}$ for **large tables** 
    
      > - $\color{forestgreen}{Mainly\ used}$ when there is a table with a **smaller number** of records and the **joining column** is $\color{forestgreen}{index}$ed in the second table

  ---
- ## 2<sub>)</sub> $\color{yellow}{Hash\ Match\ Join}$
  
  *The mechanism for hash match Join*:
  - **Create** a **hash table** 
  - Then match records 
  
    ---

    - ##### Hash Match Join is utilized $\color{forestgreen}{only}$ for  $\color{forestgreen}{Equi}$ `JOIN`.

    - Hash tables are **created in** the **memory**.  
      - Hash Match Join **uses tempdb** heavily.  
        > *Because most likely the memory will not be sufficient to hold all the data.*  
  
      - Hash Match Join is a **blocking join**: 
        > *Until the entire join is completed, users will not get the data output.*
  
      *These two properties make Hash Match join a slow operator to join tables in SQL Server.* 

      --- 

    - ##### Optimising:
      > *In the case of a data warehouse,  
      > hash joins are fine but not for transactional systems.* 
      
      - ***Mainly**, you need to look at **modifying** the **indexes** or include **new indexes**.* 
  
      - *In addition, you may look at the options of **rewriting** the **queries**.*


  ---
- ## 3<sub>)</sub> $\color{yellowgreen}{Merge\ Join}$

  ---


- ## 4<sub>)</sub> ...
