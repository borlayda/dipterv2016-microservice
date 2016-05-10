Mikro szolgáltatások
====================

### Definíció
-------------

Nem találtam konkrét definicót, de a mikro szolgáltatás egy olyan architektúrális modellezési mód, amikor a tervezett rendszert/alkalmazást kisebb funkciókra bontjuk, és önálló szolgáltatásokként, önálló erőforrásokkal, valamilyen jól definiált interfészen keresztül tesszük elérhetővé.

### A technológiáról
--------------------

A mikro szolgáltatás architektúra kiépítéséhez sokféle szétválasztási módot használnak, amik közül van olyan amit a tervezési folyamat közben felmerülő főneveket, vagy igéket használják fel, de abban megegyeznek, hogy a funkcionlaitást bontják fel. Ezzekkel az [integrációval foglalkozó részben](Integrációs-minták) olvashatunk bővebben.

A mikro szolgáltatások tervezése során a következő szempontok szerint szokták megtervezni a rendszert:

* Milyen szolgáltatásokat tud nyújtani a rendszer
  * Lehetséges műveletek felsorolása (igék amik a rendszerrel kapcsolatosak)
  * Lehetséges erőforrások vagy entitások felsorolása (főnevek alapján szétválasztás)
  * Lehetséges use-case-ek szétválasztása (felhasználási módszerek elválasztása)
* A felbontott rendszert hogyan kapcsoljuk össze
  * Pipeline-ként egy hosszú folyamatot összeépítve és az információt áramoltatva
  * Elosztottan, igény szerint meghívva az egyes szolgáltatásokat
  * Egyes funkciókat összekapcsolva nagyobb szolgáltatások kialakítása (kötegelés)
* A kommunikáció a felhasználóval
  * Egy központi szolgáltatáson keresztül, ami a többivel kommunikál
  * Add-hoc minden szolgáltatás külön hívható

Ezekkel a lépéssekkel meg lehet alapozni, hogy az álltalunk készítendő rendszer hogyan is lesz kialakítva, és milyen paraméterek mentén lesz felvágva. A választást segíti a témában elterjedt fogalom, a scaling cude[\[1\]](http://microservices.io/articles/scalecube.html), ami azt mutatja, hogy az architektúrális terveket milyen szempontok mentén lehet felosztani.

![Scaling Cube](http://microservices.io/i/DecomposingApplications.021.jpg)

Ahogy a képen is látható a meghatározó felbontási fogalmak, az adat menti felbontás, a tetszőleges fogalom menti felbontás, illetve a klónozás.

Az adat menti felbontás annyit tesz, hogy a szolgáltatásokat annak megfelelően bontjuk fel, hogy az egyes szolgáltatások csak adatbázissal, vagy csak web kiszolgálással foglalkozzanak, vagy csak a felhasználói adatok esetleg a tanulók jegyeit felügyelik. Ez a mérce a mikro szolgáltatás architektúrák esetén nem annyira fontos, mivel a szolgáltatásoknak erőforrásaikat tekintve is el kell különülniük, így nem éri meg erőforrások vagy adat mentén vágni.

A tetszőleges fogalom menti felbontás annyit tesz hogy elosztott rendszert hozunk létre tetszőleges funkcionalitás szerint. Erre épít a mikro szolgáltatás architektúra is, mivel a lényege pont az egyes funkciók atomi felbontása.

A harmadik módszer arra tér ki, hogy hogyan lehet egy architektúrát felosztani, hogy skálázható legyen. Itt a klónozhatóság, avagy az egymás melleti kiszálgálás motivál. Ez a mircro-service-eknél kell, hogy teljesüljön, mivel adott esetben a load balancer alatt tudnunk kell definiálni több példányt is egy szolgáltatásból.

## Architektúrális mintákhoz való viszonya
------------------------------------------

Mint korábban láthattuk vannak bizonyos telepítési módszerek, amik mentén szokás a mikro szolgáltatásokat felépíteni. Van aki az architektúrális tervezési minták közé sorolja a mikro szolgáltatás architektúrát, azonban nem lehet élesen elkülöníteni, mivel valamilyen csatolási módszerre szükség van, ami nem specifikus a mikro szolgáltatás-ek esetén, viszont más architektúrális mintákra jellemző.

Ilyen a Pipes and fileter architektúrális minta [\[2\]](https://msdn.microsoft.com/en-us/library/dn568100.aspx), aminek a lényege, hogy a funkciókra bontott architektúrát az elérni kívánt végeredmény érdekében különböző módokon összekötünk. Ebben a módszerben az adat folyamatosan áramlik az egyes alkotó elemek között, és lépésről lépésre alakul ki a végeredmény. Elég olcsón kivitelezhető architektúrális minta, mivel csupán sorba kell kötni hozzá az egyes szolgáltatásokat, azonban nehezen lehet optimalizálni, és könnyen lehet, hogy olyan részek lesznek a feldolgozás közben, amik hátráltatják a teljes folyamatot.

Egy másik elosztott rendszerekhez kitallált minta a subscriber/publisher[\[3\]](https://msdn.microsoft.com/en-us/library/ff649664.aspx), amely arra alapszik, hogy egy szolgáltatásnak szüksége van valamilyan adatra vagy funkcióra, és ezért feliratkozik egy másik szolgáltatásra. Ennek az lesz az eredménye, hogy bizonyos szolgáltatások bizonyos más szolgáltatásokhoz fognak kötődni, és annak megfelelően fognak egymással kommunikálni, hogy milyen feladatot kell végrehajtaniuk.

### Példák:

Amazon - minden Amazon-nal kommunikáló eszköz illetve az egyes funkciók implementációja is szolgáltatásokra van szedve, és ezeket hívják az egyes funkciók (vm indítás, törlés, mozgatás, stb.)

eBay - Különböző műveletek szerint van felbonva a a funkcionalitás, és ennek megfelelően külön szolgáltatásként érhető el a fizetés, megrendelés, szállítási információk, stb.

NetFlix - A nagy terhelést elkerülendő bizonyos streaming szolgáltatásokat átlalakítottak, hogy a mikro szolgáltatás architektúra szerint működjön.

Mintapéldák: http://eventuate.io/exampleapps.html
