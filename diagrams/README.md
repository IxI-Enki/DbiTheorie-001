<!-- -->
## Logische Optimierung - 'Anwenden der Transformationsregeln'

> #### SQL-Abfrage, die optimiert werden soll: 
>  
>```sql
>SELECT DISTINCT s.Semester
>  FROM
>    Studenten s,
>    hören h,
>    Vorlesungen v,
>    Professoren p
>  WHERE
>        p.Name = ´Sokrates´
>    and v.gelesenVon = p.PersNr
>    and v.VorlNr = h.VorlNr
>    and h.MatrNr = s.MatrNr
> ```


 
 |  1  |  2  |  3  |  
 |:---:|:---:|:---:|  
 | <img src="img/canonic-001.png" width=65%> |<img src="img/canonic-002.png" width=58%> | <img src="img/canonic-003.png" width=100%> |  
 |**4**|**5**|**6**|  
 | <img src="img/canonic-004.png" width=100%> | <img src="img/canonic-005.png" width=100%> |  |  
 
---

### **Erhaltene Ergebnisse im Vergleich:**

 |  **4** | **5** |  
 |:------:|:-----:|  
 | <img src="img/results-canon-004B.png" width=100%> | <img src="img/results-canon-005c.png" width=100%> |  
 

