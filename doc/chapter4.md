Kommunikációs módszerek
=======================

A szolgáltatások közötti kommunikáció nincs lekötve de jellemző a REST-es API, vagy a webservice-re jellemző XML alapú kommunikáció. Minden szolgáltatához tartozik egy önálló interfész, amin keresztül a többi szolgáltatás kommunikálhat vele, és minden funkcióját el lehet érni. Ennek az interfésznek olyannak kell lennie, hogy az implementáció szabadon változtatható legyen, és ne kelljen más szolgáltatásokat megváltoztatni, ha a saját szolgáltatásunkat változtatjuk. Ez segíti a több csapattal való munkát, és lehetővé teszi hogy teljesen függetlenül létezzenek a szolgáltatások.
