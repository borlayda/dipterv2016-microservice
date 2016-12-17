Mikroszolgáltatások előnyei és hátrányai
----------------------------------------

Ahogy minden architektúrális mintának, a mikroszolgáltatásoknak is vannak előnyei[@microservices], amik indokoltá teszik a minta használatát, és vannak hátrányai[@micro-disadv], amiket mérlegelnünk kell a tervezés folyamán.

###Előnyök

####Könnyű fejleszteni

Mivel kis részekre van szedve az alkalmazásunk, a fejlesztést akár több csapatnak is ki lehet osztani, hogy az alkalmazás részeit alkossák meg, hiszen önállóan is életképesek a szolgáltatások. Az egyes szolgáltatások nem rendelkeznek túl sok logikával, így kis méretű könnyen kezelhető feladatokkal kell a csapatoknak foglalkozni.

####Egyszerűen megérthető

Egy szolgáltatás nagyon kis egysége a teljes alkalmazásnak, így könnyen megérthető. Kevés technológia, és kevés kód áll rendelkezésre egy szolgáltatásnál, így gyorsan beletanulhat egy új fejlesztő a munkába. A dokumentáció, átláthatóság, illetve a hibák analizálása közben is jól jön, hogy élesen elvállnak az egyes egységek.

####Könnyen kicserélhető, módosítható, telepíthető

A szolgáltatások önnálóan is működnek, így az azonos interfésszel rendelkező szolgáltatásra bármikor kicserélhető, illetve módosítható ha megmaradnak a korábbi funkciók. A szolgáltatás telepítése is egyszerű, mivel csak kevés környezeti feltétele van annak, hogy egy ilyen kis méretű progam működni tudjon. A fejlesztést nagyban segíti, hogy egy korábbi verziójú alkalmazásba plugin-szerűen be lehet integrálni az újonnan fejlesztett részeket, mivel ez gyors visszajelzést ad a fejlesztőknek. Ez a tulajdonsága a folytonos integrációt támogató eszközöknél is előnyös, mivel könnyen lehet vele automatizált metodológiákat készíteni.

####Jól skálázható

Mivel sok kis részletből áll az alkalmazásunk, nem szükséges minden funkciónkhoz növelni az erőforrások allokációját, hanem kis komponensekhez is lehet rendelni több erőforrást. Például egy számítási felhőben, a teljesítményben látható változásokat könnyen és gyorsan lehet kezelni, a problémát okozó funkció felskálázásval.

####Támogatja a kevert technológiákat

Az egyik legnagyobb ereje ennek az architektúrának, hogy képes egy alkalmazáson belül kevert technológiákat is használni. Mivel egy jól definiált interfészen keresztül kommunikálnak a szolgáltatások, ezért mindegy milyen technológia van mögötte, amíg ki tudja szolgálni a feladatát. Ennek megfelelően el tudunk helyezni egy Linux-os környezetben használt LDAP-ot, és egy Windows-os környezetben használt Active Directory-t is, és minden gond nélkül használni is tudjuk őket az interfésziek segítségével.

###Hátrányok

####Komplex alkalmazás alakul ki

Mivel minden funkcióra saját szolgáltatást csinálunk, nagyon sok lesz az elkülönülő elem, és a teljes alkalmazás egyben tartása nagyon nehéz feladattá válik. Mivel fontos a szolgáltatások együttműködése, a sok interfésznek ismernie kell egymást, és fenn kell tartani a konzisztenciát minden szolgáltatással.

####Nehezen kezelhető az elosztott rendszer

A mikroszolgáltatások architektúra egy elosztott rendszert ír le, és mint minden elosztott rendszer ez is bonyolultabb lesz a monolitikus változatánál. Elosztott rendszereknél figyelni kell az adatok konzisztenciáját, a kommunikáció plusz feladatot ad minden szolgáltatás fejlesztőjének, és folyamatosan együtt kell működni a többi szolgáltatás fejlesztőjével.

####Plusz munkát jelenthet az aszinkron üzenet fogadás

Mivel egy szolgáltatás egyszerre több kérést is ki kell hogy szolgáljon egyszerűbb ha aszinkron módon működik. Ezt azonban mindig le kell implementálni, és az aszinkron üzenetek bonyolítják az adatok kezelését. Az egyes szolgáltatások között könnyen lehetnek adatbázisbeli inkonzisztenciák, mivel aszinkron működés esetén nem minden kiszolgált kérésnek ugyan az a ritmusa. Ugyan nem megoldhatatlan feladat ezeket az időbeli problémákat lekezelni, de plusz komplexitást hozhat be, amit egy közös környezetben lock-olással könnyedén megoldhatnánk.

####Kód duplikátumok kialakulása

Amikor nagyon hasonló (kis részletben eltérő) szolgáltatásokat csinálunk, megesik, hogy ugyan azt a kódot többször fel kell használnunk, és ezzel kód, és adat duplikátumok keletkeznek, amiket le kell kezelnünk. Nem nehéz találni olyan példát, ahol a létrehozás és szerkesztés művelete megvalósítható ugyan külön szolgáltatásként, viszont nehezíti a feladatot, hogy 2 külön adatbázist kéne módosítani az ideális megvalósításban, és ezek konzisztenciáját fenn kéne tartani.

####Interfészek fixálódnak

A fejlesztés folyamán a szolgáltatásokhoz rendelt interfészek fixálódnak, és ha módosítani akarunk rajta, akkor több szolgáltatásban is meg kell változtatni az interfészt. Ennek a problémának a megoldása, alapos tervezés, és sokszintű, bonyolult interfész struktúra használatával megoldható.

####Nehezen tesztelhető egészben

Mivel sok kis részletből rakódik össze a nagy egész alkalmazás, a tesztelési fázisban kell olyan teszteket is végezni, ami a rendszer egészét, és a kész alkalmazást teszteli. Egy ilyen teszt elkészítése bonyolult lehet, és plusz feladatot ad a sok szolgáltatás külön-külön fordítása, és telepítése is.

###Összehasonlítva a monolitikus architektúrával

A mikroszolgáltatás architektúra és a monolitikus architektúra egymás ellentetjei, melyben az erőforrások központilag vannak kezelve, és minden funkció egy nagy interfészen keresztül érhető el. A monolitikus architektúra egyszerűen kiépíthető, könnyű tervezni és fejleszteni, azonban nehezen lehet kicserélni, nem elég robosztus, és nehezen skálázható, mivel az erőforrásokat közösen kezelik a funkciók.

Ezzel ellentétben a mikroszolgáltatás architektúrát nehezen lehet megtervezni, hiszen egy elosztott rendszert kell megtervezni, ahol az adatátviteltől kezdve az erőforrás megosztáson keresztül semmi sem egyértelmű. A kezdeti nehézségek után viszont a későbbi továbbfejlesztés sokkal egyszerűbb, mivel külön csapatokat lehet rendelni az egyes szolgáltatásokhoz, és könnyen integrálhatók, kicserélhetők az alkotó elemek. Mivel sok kis egységből áll, könnyebben lehet úgy skálázni a rendszert, hogy ne pazaroljuk el az erőforrásainkat, és ugyanakkor a kis szolgáltatások erőforrásokban is el vannak különítve, így nem okoz gondot, hogy fel vagy le skálázzunk egy szolgáltatást. Ennek az a hátránya, hogy le kell kezelni a skálázáskor a közös erőforrásokat.(Például ha veszünk egy autentikációs szolgáltatást, akkor ha azt fel skálázzuk, meg kell tartanunk a felhasználók listáját, így duplikálni kell az adatbázist, és fenntartani a konzisztenciát) Ugyan csak előnye a mikroszolgáltatás architektúrának, hogy különböző technológiákat lehet keverni vele, mivel az egyes szolgáltatások különböző technológiákkal különböző platformon is futhatnak.
