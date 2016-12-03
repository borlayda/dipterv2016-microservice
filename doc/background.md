Háttérismeretek
===============

Mikroszolgáltatások
-------------------

A mikroszolgáltatás[@microservices] [@micro-arch] [@microservices-light] egy olyan architektúrális modellezési mód, amikor a tervezett rendszert/alkalmazást kisebb funkciókra bontjuk, és önálló szolgáltatásokként, önálló erőforrásokkal, valamilyen jól definiált interfészen keresztül tesszük elérhetővé.

Ezt az architektúrális mintát az teszi erőssé, hogy nem függenek egymástól a különálló komponensek, és csak egy kommunikációs interfészt ismerve is karbantartható a rendszer. Egy szoftver fejlesztési projektben előnyös lehet, hogy az egyes csapatok fókuszálhatnak a saját szolgáltatásukra, és nincs szükség a folyamatos kompatibilitás tesztelésére.

Egy mikroszolgáltatást használó architektúra kiépítéséhez sokféle funkcionális elkülönítési módot használnak, amivel a szolgáltatásokat kialakíthatjuk. Egy ilyen elválasztásí módszer a rendszer specifikációjában lévő főnevek vagy igék kiválasztása, és az így kapot halmaz felbontása. Egy felbontás akkor minősül ideálisnak, ha nem tudjuk tovább bontani az adott funkciót. A valóságban soha nem lesz az ideálisnak megfelelő felbontás, mivel erőforrás pazalró, és túlzottan elosztott rendszert kapnánk.

###Szolgáltatás elválasztás tervezése\label{splitting}

A tervezési folyamatnál a következő szempontokat szokták figyelembe venni:

* Szolgáltatások felsorolása valamilyen szempont szerint
    - Lehetséges műveletek felsorolása (igék amik a rendszerrel kapcsolatosak)
    - Lehetséges erőforrások vagy entitások felsorolása (főnevek alapján szétválasztás)
    - Lehetséges use-case-ek szétválasztása (felhasználási módszerek elválasztása)
* A felbontott rendszert hogyan kapcsoljuk össze
    - Pipeline-ként egy hosszú folyamatot összeépítve és az információt áramoltatva
    - Elosztottan, igény szerint meghívva az egyes szolgáltatásokat
    - Egyes funkciókat összekapcsolva nagyobb szolgáltatások kialakítása (kötegelés)
* Külső elérés megszervezése
    - Egy központi szolgáltatáson keresztül, ami a többivel kommunikál, és csak ennyi a feladata
    - Add-hoc minden szolgáltatás külön hívható

Ezekkel a lépéssekkel meg lehet alapozni, hogy az általunk készítendő rendszer hogyan is lesz kialakítva, és milyen paraméterek mentén lesz felvágva. A választást segíti a témában elterjedt fogalom, a scaling cube[@scale-cube], ami azt mutatja, hogy az architektúrális terveket milyen szempontok mentén lehet felosztani.

![Scaling Cube](img/ScaleCude.jpg)

Ahogy a képen is látható a meghatározó felbontási fogalmak, az adat menti felbontás, a tetszőleges fogalom menti felbontás, illetve a klónozás.

####Adat menti felbontás

Az adat menti felbontás annyit tesz, hogy a szolgáltatásokat annak megfelelően bontjuk fel, hogy milyen erőforrással dolgoznak, vagy konkrétan egy adattal kapcsolatos összes funkciót egy helyen készítünk el.

Példa: Erőforrás szerinti felbontás ha külön található szolgáltatás, amivel az adatbázis műveleteket hajtjuk végre, és külön van olyan is, ami csak a HTTP kéréseket szolgálja ki. Az egy adatra épülő módszernél pedig alapul vehetünk egy olyan példát, ahol mondjuk egy szolgáltatás az összes adminisztrátori funkciót látja el, míg más szolgáltatások a más-más kategóriába eső felhasználók műveleteit hajtják végre.

Mivel a mikroszolgáltatások elve a hardvert is megosztja nem csak a szoftvert, ezért az erőforrás szerinti szétválasztás kissé értelmetlennek tűnhet, azonban a különböző platformok különbüző erőforrásait megéri külön szolgáltatásként kezelni. Ha egy mikroszolgáltatást tartunk arra, hogy az adatbázis kéréseket kiszolgálja, akkor az adatbázis nem oszlik meg a szolgáltatások között. Ennek ellenére pazarló lehet minden szolgáltatásnak saját adatbézist fenntartani.

####Fogalmi felbontás

A tetszőleges fogalom menti felbontás annyit tesz hogy elosztott rendszert hozunk létre tetszőleges funkcionalitás szerint. Erre épít a mikroszolgáltatás architektúra is, mivel a lényege pont az egyes funkciók atomi felbontása.

Példa: Adott egy könyvtár nyilvántartó rendszere, és ezt akarjuk fogalmanként szétvágni. Külön-külön lehet szolgáltatást csinálni a keresésnek, indexelésnek, foglalásnak, kivett könyvek nyilvántartásának, böngészésre, könyvek adatainak tárolására, és kiolvasására, és ehhez hasonló funkciókra. Ezekkel a szétválasztásokkal a könyvtár működését kis részekre bontottuk, és ezek egy-egy kis szolgáltatásként könnyen elérhetők.

####Klónozás

A harmadik módszer arra tér ki, hogy hogyan lehet egy architektúrát felosztani, hogy skálázható legyen. Itt a klónozhatóság, avagy az egymás melletti kiszolgálás motivál. Ez a mikroszolgáltatásoknál kell, hogy teljesüljön, mivel adott esetben egy terheléselosztó alatt tudnunk kell definiálni több példányt is egy szolgáltatásból. Azért szükséges a skálázhatóság a mikroszolgáltatások esetén, mivel kevés hardver mellett is hatékonyan kialakítható az architektúra, de könnyen lehet szűk keresztmetszetet létrehozni, amit skálázással könnyen megkerülhetünk.

###Architektúrális mintákhoz való viszonya

Mint korábban láthattuk vannak bizonyos telepítési módszerek, amik mentén szokás a mikroszolgáltatásokat felépíteni. Van aki az architektúrális tervezési minták közé sorolja a mikroszolgáltatás architektúrát, de nem könnyű meghatározni, hogy hogyan is alkot önnáló mintát. Nagyon sok lehetőség van a mikroszolgáltatásokban, és leginkább más architektúrákkal együtt használva lehet hatékonyan és jól használni.

Nézzünk meg három felhasználható architektúrális mintát:

####Pipes and Filters

A Pipes and filter architektúrális minta[@pipes-pattern] lényege, hogy a funkciókra bontott architektúrát az elérni kívánt végeredmény érdekében különböző módokon összekötjük. Ebben a módszerben az adat folyamatosan áramlik az egyes alkotó elemek között, és lépésről lépésre alakul ki a végeredmény. Elég olcsón kivitelezhető architektúrális minta, mivel csupán sorba kell kötni hozzá az egyes szolgáltatásokat, azonban nehezen lehet optimalizálni, és könnyen lehet, hogy olyan részek lesznek a feldolgozás közben, amik hátráltatják a teljes folyamatot.

####Publisher/Subscriber

Egy másik, elosztott rendszerekhez kitallált minta a publisher/subscriber[@pub-subscribed], amely azon alapszik, hogy egy szolgáltatásnak szüksége van valamilyen adatra vagy funkcióra, és ezért feliratkozik egy másik szolgáltatásra. Ennek az lesz az eredménye, hogy bizonyos szolgáltatások, bizonyos más szolgáltatásokhoz fognak kötődni, és annak megfelelően fognak egymással kommunikálni, hogy milyen feladatot kell végrehajtaniuk.

####Esemény alapú architektúra

Az esemény alapú architektúrákat[@event-driven-pattern] könnyen kalakíthatjuk, ha egy mikroszolgáltatásokból álló rendszerben olyan alkalmazásokat és komponenseket fejlesztünk ahol eseményeken keresztül kommunikálnak az egyes elemek. Ezzel a nézettel olyan struktúrát lehet összeépíteni, ahol a kis egységek szükség szerint kommunikálnak, és a kommunikáció egy jól definiált interfészen keresztül történik.

###Eltérések a szolgáltatás orientált architektúrától

A mikroszolgáltatások a szolgáltatás orientált architektúrális minta finomítása, mivel elsősorban szeparált egységeket, önműködő szolgáltatásokat hoz létre, amik életképesek önmagukban is, és amennyire lehet oszthatatlanok. A szolgáltatás orientált esetben viszont a meglévő szolgáltatásainkat kapcsoljuk össze, ami akár egy helyen is futhat és egyáltalán nem az atomicitás a lényege.

###Példák mikroszolgáltatásokat használó alkalmazásokra

Amazon - minden Amazon-nal kommunikáló eszköz illetve az egyes funkciók implementációja is szolgáltatásokra van szedve, és ezeket hívják az egyes funkciók (vm indítás, törlés, mozgatás, stb.)

eBay - Különböző műveletek szerint van felbonva a funkcionalitás, és ennek megfelelően külön szolgáltatásként érhető el a fizetés, megrendelés, szállítási információk, stb.

NetFlix - A nagy terhelést elkerülendő bizonyos streaming szolgáltatásokat átalakítottak, hogy a mikroszolgáltatás architektúra szerint működjön.

Archivematica[@archivematica] - Egy Fájlkezelő rendszer, amiben mikroszolgáltatásoknak megfelelően alakították ki a plugin-ként használható funkciókat.
