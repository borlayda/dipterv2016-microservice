Minta alkalmazás
================

![Microservices](img/microservices.png)

Alkalmazás leírás:
-----------------

Az alkalmazás, amin ketesztül a mikroszolgáltatások működését bemutatom, egy könyvesbolt webárúháza lesz, ami rendelkezik egy webes felülettel. A felhasználó be tud jelentkezni a felületre, és tud könyveket vásárolni magának a webes nyilvántartásból.

Szolgáltatások:
--------------

A szolgáltatások meghatározásánál elsőnek azt vettem alapul, hogy milyen feladatokat kell teljesítenie a rendszernek, majd az erőforrásokat vettem alapul.

A könyvesbolthoz tartozóan a következő tevékenységeket határoztam meg:

* **Bejelentkezés**: Felhasználó felületen történő authentikálása.
* **Böngészés**: Felhasználó láthatja mi van a raktáron.
* **Vásárlás**: Felhasználó valamit a saját nevére ír, megvásárol.

A könyveket egy adatbázisban tárolom a megrendelésekkel együtt, és egy proxy-t is készítettem, hogy könnyen skálázható legyen bármely funkció.

* **Adabtbázis**: Tartalmazza a tárolt könyveket, autentikációs adatokat, és vezeti a vásárlások naplóját.
* **Proxy**: Minden szolgáltatást elérhetővé tesz egy közös interfészen keresztül, és skálázhatóvá teszi a szolgáltatásokat.

Ezekből a feladatokból a következő szolgáltatásokat lehet elkészíteni:

* **Felület kiszolgálása**: Egy web kiszolgáló alkalmazása, amin keresztül elvégezhetők a különböző műveletek, mint a bejeletkezés, vagy vásárlás. Ez a felület magába foglalja a böngészést lehetővé tevő szolgáltatást is, mivel szorosan ehhez a funkcióhoz tartozik. Egy másik megvalósítás lehetne, hogy a különböző vetületekhez tartozó információt egy-egy szolgáltatás adja vissza, azonban ez túl nagy komplexitást eredményezne, így az elöbbi megoldásnál maradtam.
* **Authentikációs szolgáltatás**: A bejelentkezni szándékozó felhasználó adatait ellenőrzi, és hibás bejelentkezés esetén hibát dob. Az adatbázissal kommunikál, és ellenőrzi, hogy a felhasználónak van-e bejegyzése az adatbázisban.
* **Vásárlási szolgáltatás**: A böngészés közben kiválasztott könyveket lefoglalja a raktári készletből. Csökkenti az adatbázisban a készlet tartalmát, és létrehoz egy új bejegyzést a vásárlások adattáblájában, ami tartalmazza a vásálás adatait. Ha túl sokat akar venni a felhasználó, vagy nem létező könyvből akar vásárolni, akkor hibajelzést küldök.
* **Adatbázis szolgáltatás**: Ez a szolgáltatás tartalmazza a raktár tartalmát, a vásárlási naplót, és a bejelentkezési adatokat. Mivel a legtöbb adatbázis kezelő távolról elérhető, és fürtözési lehetőségeket is nyújt, ezért ehhez a szolgáltatáshoz nem szükséges mögöttes logika. Az interfésze az adatbázist kezelő eszköz interfésze (pl.: MySQL szerver, és SQL nyelvű interfész.).
* **Terhelés elosztó szolgáltatás**: Ez a szolgálatatás a skálázhatóságot segíti, és egy egységes interfész kialakításában segít. Tartalmaz egy proxy kiszolgálót, és egy konfigurációs fájlt, amit az infrastruktúra változásával bővítünk (pl.: HAProxy, és a hozzá tartozó konfigurációs fájl). Nehéz kérdés lehet egy új szolgáltatás beiktatása, mivel a proxy szerver interfésze változna meg tőle, így ennek a szolgáltatásnak a többivel együtt kell változnia.

Értékelés
---------

Az alkalmazás kellően egyszerű, hogy rövid idő alatt implementálni lehessen, és alkalmas rá, hogy a fejlesztés során használt folytonos integrációra épülő feladatokat bemutassam rajta.

A tervben azért szerepelnek külön az adatbázis és a proxy szoláltatások, mivel túl bonyolulttá, és feleslegesen erőforrás igényessé tenné az alkalmazást, ha minden szolgáltatás saját adatbázissal rendelkezne és a saját skálázhatóságát is menedzselné. Van néhány bottleneck szolgáltatás, mint a web kiszolgáló, és az adatbázis szerver, viszont egy olyan változat, melyben ez nem áll fenn, nagyságrendekkel több idő lett volna elkészíteni, így a diplomaterv során ezzel nem foglalkoztam.
