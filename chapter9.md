Valós alkalmazás értékelése
===========================

Ugyan az elkészített minta alkalmazás és a folytonos integrációt támogató keretrendszer elkészült, és működik ahogy kell, de vannak dolgok, amiket nem teljesen úgy valósítottam meg ahogy az elmélet elvárná, illetve vannak olyan területek ahol tovább lehetne fejleszteni az alkalmazást.

###Tervezésbeli eltérések

A Diplomaterv során megvalósított alkalmazás és folytonos integrációt támogató keretrendszer megalkotása nem teljesen a mikroszolgáltatások elvei szerint lettek megvalósítva, mégpedig azért, mert a tökéletes megoldás túl sok időt emésztett volna fel, és tartalmazott volna olyan elemeket is, amik feleslegesek lettek volna a bemutatáshoz.
Az első eltérést már leírtam, a minta alkalmazás tervezése közben, mivel az adatbázis nem egy különálló szolgáltatás kellett volna, hogy legyen, de nagyságrendekkel több idő lett volna megoldani, hogy minden szolgáltatás a saját adatbázisát kezelje. Egy másik eltérés, hogy a mikroszolgáltatásokhoz kellene tartozni egy központi kezelő felületnek, mivel a teljes alkalmazás kezelése nehézkes, viszont a Diplomaterv szempontjából irreleváns. Erre a célra használható egyébként a Kubernetes nevezetű alkalmazás, ami ugyan még gyerekcipőben jár, de egy teljes körű alkalmazás konténer kezelő rendszer, így minden kívánalmat lefed, ami a mikroszolgáltatásokhoz kell. A Diplomaterv elkészítésénél inkább a fejlesztési folyamat bemutatása volt a célpont, mintsem egy kész eszköz bemutatása, így ez sem került be a félév anyagába.

###Továbbfejlesztési javaslatok, valós alkalmazásban használandó elemek

Az elkészített struktúra használható ipari környezetben is, mivel a szétválasztás adatbázisokat kezelő részét kivéve egy jó szétválasztás, és nincs is ennél aprólékosabb, illetve a hozzá tartozó folytonos integrációt támogató környezet is képes kezelni bármilyen komplex alkalmazást.

Ha adott a külső elérésű Jenkins szerver, és rendelkezésre áll egy verziókezelő program, akkor a Diplomaterv során elkészített infrastruktúra használható a folytonos szállításhoz, és egy gyors visszajelzést ad a fejlesztők felé, minden egyes apró változtatáshoz. Amivel ki kell bővíteni az itt elkészült anyagot, az unit tesztek egy halmaza a buildelendő alkalmazáshoz, funkció tesztek készítése a komplex alkalmazás teszteléséhez, és stabilitás teszteléshez alapos stressz teszt. Ha ezek megvannak, egy valós alkalmazás is megbízhatóan fog működni tetszőleges környezetben.

Mivel a mikroszolgáltatások kis méretűek, és gyorsan, egyszerűen skálázhatók, megfelelőenek tűnhet a Docker konténerek használata, de mint már korábban mutattam, vannak limitációi, és nem túl megbízható a használata. Ahhoz, hogy ezt kiküszöböljük erődorrásokra van szükség, mivel kis méretű virtuális gépekben punt ugyan ilyen jól kialakítható a rendszer, csupán meg kell oldani, hogy a Docker konténerekhez hasonló sebességgel lehessen elindítani a szolgáltatásokat.
Ezzel a változtatással több előnyt is nyerhetünk, mivel így skálázhatók lesznek az erőforrások a szolgáltatás alatt is és nem csak szolgáltatás duplikációt használhatunk, illetve kiaknázva a virtualizáló eszközt amit használunk, minotorozást, és pontos erőforrás megfigyelést is nyerhetünk.
Mivel nekem nem volt elegendő erőforrásom ennyi virtuális gépet fenntartani, és nem volt lehetőségem valamilyen fizetős cloud szolgáltatást felhasználva kipróbálni ezt a módszert, így ezt csak ajánlani tudom.

Valós alkalmazás fejlesztésénél célszerűbb előre elkészíteni a folytonos integrációt támogató keretrendszert, mivel azzal sokkal könnyebb lesz már a kezdeti fejlesztés is, és kisebb gondot okoz a későbbi változtatás. Amire érdemes odafigyelni, az a szolgáltatások teljesen külön kezelése addig a pontig, amíg nem az integrált környezetet akarjuk tesztelni, mert egy mikroszolgáltatás alapú alkalmazásnak minden kis eleme külön termék, és így külön életciklusa van.

Ami a minta alkalmazást illeti, érdemes lehet a webes megjelenítést a Rest-es kiszolgáló részévé tenni, mivel a Rest kommunikáció képes kiszolgálni a böngészőből jövő HTTP kérést, de én nem ezt alkalmaztam, mert könnyebben megvalósítható egy olyan oldal, aminek egy központi kiszolgálója van.
