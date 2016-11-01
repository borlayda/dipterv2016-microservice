Kommunikációs módszerek
=======================

A szolgáltatások közötti kommunikáció nincs lekötve de jellemző a REST-es API, vagy a webservice-re jellemző XML alapú kommunikáció[@rest-soap].

##Technológiák

A kommunikáció megtervezéséhez egy jó leírást olvashatunk az Nginx egyik cikkében[@micro-communication]. Ez a cikk leírja, hogy fontos előre eltervezni, hogy a szolgáltatások egyszerre több másik szolgáltatással is kommunikálnak vagy sem, illetve szinkron vagy aszinkron módon akarunk-e kommunikálni. A cikk kifejti, hogy az egyes technológiák hogyan használhatók jól, és hogyan lehet várakoztatási sorral javítani a kiszolgáláson.

###REST (HTTP/JSON):

A  RESTful[@microservices-light] kommunikáció egy HTTP feletti kommunikációs fajta, aminek az alapja az erőforrások megjelölése egyedi azonosítókkal, és hálózaton keresztül műveletek végzése a HTTP funkciókat felhasználva. Ez a módszer napjainkban nagyon népszerű, mivel egyszerű kivitelezni, gyakorlatilag minden programozási nyelv támogatja, és nagyon egyszerűen építhetünk vele interfészeket. Az üzenetek törzsét a JSON tartalom adja, ami egy kulcs érték párokból álló adatstruktúra, és sok nyelv támogatja az objektumokkal való kommunikációt JSON adatokon keresztül (Sorosítással megoldható).
Mikroszolgáltatások esetén az aszinkron változat használata az előnyösebb[@rest-async], mivel ekkor több kérést is ki tudunk szolgálni egyszerre, és a szolgáltatásoknak nem kell várniuk a szinkron üzenetek kiszolgálására.

###SOAP (HTTP/XML):

A szolgáltatás alapú architektúrákban nagyon népszerű a SOAP[@soap], mivel tetszőleges interfészt definiálhatunk, és le lehet vele képezni objektumokat is. Kötött üzenetei vannak, amiket egy XML formátumu üzenet ír le. Ebben az esetben nem erőforrásokat jelölnek az URL-ek, hanem végpontokat, amik mögött implementálva van a funkcionalitás. Ennek a kommunikációs módszernek az az előnye, hogy jól bejáratot, széleskörben használt technológiáról van szó, amit jól lehet használni objektum orientált nyelvek közötti adatátvitelre. Hátránya, hogy nagyobb a sávszélesség igénye, és lassabb a REST-es megoldásnál.
Létezik szinkron és aszinkron megvalósítása is és mivel ez a kommunikációs fajta is HTTP felett történik, a REST-hez hasonló okokból az aszinkron változat a célszerűbb.

###Socket (TCP):

A socket[@socket] kapcsolat egy TCP feletti kapcsolat, ami egy folytonos kommunikációs csatornát jelent az egyes szolgáltatások között. Ez azért lehet előnyös, mert a folytonos kapcsolat fix útvonalat és fix kiszolgálást jelent, amivel gyors és egyszerű kommunkácót lehet végrehajtani. A három technológia közül ez a leggyorsabb és a legkisebb sávszélességet igénylő, azonban nincs definiálva az üzenetek formátuma (protokollt kell hozzá készíteni), és az aszinkron elv nem összeegyeztethető vele, így üzenetsorokat kell létrehozni a párhuzamos kiszolgáláshoz.
Indokolt esetben sok előnye lehet egy mikroszolgáltatásokra épülő struktúrában is, azonban általános esetben nem igazán használható kommunikációs eszköz.

##Interfészek

A korábban említett Nginx-es cikk kitért arra is, hogy az interfészek megalkotása milyen gondokkal járhat, és mi az előnye, hogyan lehet úgy megtervezni őket, hogy ne legyen sok gondunk velük.

Az interfészeket úgy kell megtervezni, hogy könnyen alkalmazhatók legyenek, képesek legyünk minden funkciót teljes mértékben használni, és később bővíthető legyen (visszafelé kompatibilis). Erre egy megoldás a RESTful technológiáknál a verziózott URL-ek használata, amivel implicit módon megmondhatjuk, hogy melyik verziójú interfészre van szükségünk éppen. Ha rosszul tervezzük meg az interfészek struktúráját, és nem készítjük fel a szolgáltatásokat egy lehetséges interfész változtatásra, akkor könnyen lehet, hogy nagy mennyiségű plusz munkát adunk a fejlesztőknek, akiknek minden hívást karban kell tartaniuk.
