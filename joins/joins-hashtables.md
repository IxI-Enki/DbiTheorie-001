
# <p align="center"> `JOIN` </p>

## Introduction

- There are many different types of **physical `JOIN`** operators in SQL Server:  
  - $\color{orange}{Nested\ Loops\ Join}$ 
  - $\color{yellow}{Nested\ Loop\ Join\ with\ Index}$ 
  - $\color{greenyellow}{Hash\ Match\ Join}$
  - $\color{lightgreen}{Merge\ Join}$

  > *Depending on **data volume** and the **available indexes**, different types of physical join operators are used.*    

    ---

- *There are different types of* **logical `JOIN`** opperators:
  >   - *Inner Join* 
  >   - *Outer Join (Left, Right, Full)* 
  >   - *Cross Join* 
  >
  > <img src="img/logical-joins.png" alt="logical joins" width=90%>
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

  - ### Complexity: $\color{orange}\Large{O}\large{(\ n * m\ )}$  
      > Where `n` is the number of rows in the outer table and `m` is the number of rows in the inner table. In the worst case, this leads to $\color{orange}{quadratic\ time\ complexity}$.

  ---

- ## 2<sub>)</sub> $\color{yellow}{Nested\ Loop\ Join\ with\ Index}$ 
  
  - Similar to Nested Loop Join,  
    > But an **index on the join column** of the inner table is used to quickly find matching rows.

  - ### Complexity: 
    > - **Outer** loop: $\color{yellow}\large{O}\small{(n)}$
    > - Each **lookup via index**:  $\color{yellow}\large{O}\small{(log\ m)}$ *(if using a balanced tree index)* 
    > - **Overall complexity** of: $\color{yellow}\Large{O}\large{(n * log\ m)}$

  ---
- ## 3<sub>)</sub> $\color{greenyellow}{Hash\ Match\ Join}$
  
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

  - ### Complexity: 
      > - **Building** an hash table: $\color{greenyellow}\large{O}\small{(n)}$
      > - **Probing** for results: $\color{greenyellow}\large{O}\small{(1)}$
      > - **Average** complexity of $\color{greenyellow}\LARGE{O}\large{(n + m)}$ 
        ( but this can decay to O(n*m), for very large sets )

      ---

    - ##### Optimising:
      > *In the case of a data warehouse,  
      > hash joins are fine but not for transactional systems.* 
      
      - ***Mainly**, you need to look at **modifying** the **indexes** or include **new indexes**.* 
  
      - *In addition, you may look at the options of **rewriting** the **queries**.*

  ---

- ## 4<sub>)</sub> $\color{lightgreen}{Merge\ Join}$

  - #### *Is the* $\color{forestgreen}{most\ efficient}$ *`JOIN`* 
  
    > - The Merge Join operator **uses sorted data** inputs
    > - It can use **any** two **large datasets**.

      ---

  - ### Complexity: 
      > - **Sorting** each table: $\color{lightgreen}\large{O}\small{(n\ log\ n)}$ *(if not already sorted)*
      > - **Merging** is $\color{lightgreen}\Large{O}\large{(n)}$
      >  
  ---


