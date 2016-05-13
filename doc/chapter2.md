Mikro szolgáltatások előnyei és hátrányai
=========================================

Ahogy minden architektúrális mintának, a mikro szolgáltatásoknak is vannak előnyei, amik indokoltá teszik a minta használatát, és vannak hátrányai, amiket mérlegelnünk kell a tervezés folyamán.

##Előnyök [@microservices]

###Könnyű fejleszteni

Mivel kis részekre van szedve az alkalmazásunk, a fejlesztést akát több csapatnak is ki lehet osztani, hogy az alkalmazás részeit alkossák meg, hiszen önállóan is életképesek a szolgáltatások. Az egyes szolgáltatások nem rendelkeznek túl sok logikával, így ez kis feladatokat csinál, és könnyebben kezelhető.

###Egyszerűen megérthető

Egy szolgáltatás nagyon kis egysége a teljes alkalmazásnak, így könnyen megérthető. Kevés technológia, és kevés kód áll rendelkezésre egy szolgáltatásnál, így gyorsan beletanulhat egy új fejlesztő a munkába.

###Könnyen kicserélhető, módosítható, telepíthető

A szolgáltatások önnálóak, így az azonos interfésszel rendelkező szolgáltatásra bármikor kicserélhető, illetve módosítható ha megmaradnak a korábbi funkciók. A mikor szolgáltatás telepítése is egyszerű, mivel csak kevés környezeti feltétele van, hogy egy ilyen kis máretű progam működni tudjon.

###Jól skálázható

Mivel sok kis részletből áll az alkalmazásunk, nem szükséges minden funkciónkhoz növelni az erőforrások allokációját, hanem kis komponensekhez is lehet rendelni több erőforrást.

###Támogatja a kevert technológiákat

Az egyik legnagyobb ereje ennek az architektúrának, hogy képes egy alkalmazáson belül kevert technológiákat is használni. Mivel egy jól definiált interfészen keresztül kommunikálnak a szolgáltatások, ezért mindegy milyen technológia van mögötte, amíg ki tudja szolgálni a feladatát. Ennek megfelelően El tudunk helyezni egy Linux-os környezetben használt LDAP-ot, és egy Windows-os környezetben használt Active Directory-t, és minden gond nélkül használni is tudjuk az interfész segítségével.

##Hátrányok [@micro-disadv]

###Komplex rendszer alakul ki

Mivel minden funkcióra saját szolgáltatást csinálunk, nagyon sok lesz az elkülönülő elem, és a teljes rendszer egyben tartása nagyon nehéz feladattá válik. Mivel fontos a szolgáltatások együttműködése, a sok interfésznek ismernie kell egymást, és fenn kell tartani a konzisztenciát minden szolgáltatásnak.

###Nehezen kezelhető az elosztott rendszer

A mikro szolgáltatások architektúra egy elosztott rendszert ír le, és mint minden elosztott rendszer ez is bonyolultabb lesz tőle. Elosztott rendszereknél figyelni kell az adatok konzisztenciáját, a kommunikáció plusz feladatot ad minden szolgáltatás fejlesztőjének, és folyamatosan együtt kell működni a többi szolgáltatás fejlesztőjével.

###Plusz munkát jelént az aszinkron üzenet fogadás

Mivel egy szolgáltatás egyszerre több kérést is ki kell hogy szolgáljon egyszerűbb ha aszinkron módon működik. Ezt azonban mindig le kell implementálni, és az aszinkron üzenetek bonyolítják az adatok kezelését.

###Kód duplikátumok kialakulása

Amikor nagyon hasonló (kis részletben eltérő) szolgáltatásokat csinálunk, megesik, hogy ugyan azt a kódot többször fel kell használnunk, és ezzel kód, és adat duplikátumok keletkeznek, amiket le kell kezelnünk.

###Interfészek fixálódnak

A fejlesztés folyamán a szolgáltatásokhoz rendelt interfészek fixálódnak, és ha módosítani akarunk rajta, akkor több szolgáltatásban is meg kell változtatni az interfészt.

###Nehezen tesztelhető egészben

Mivel sok kis részletből rakódik össze a nagy egész alkalmazás, a tesztelési fázisban kell olyan teszteket is végezni, ami a rendszer egészét, és a kész alkalmazást teszteli. Egy ilyen teszt elksézítése bonyolult lehet, és plusz feladatot ad a sok szolgáltatás külön-külön fordítása, és telepítése is.

##Összehasonlítva a monolitikus architektúrával

A mirco-service architektúrák a monolitikus architektúra ellentetjei, melyben az erőforrások központilag vannak kezelve, és minden funkció egy nagy interfészen keresztül érhető el. A monolitikus architektúra egyszerűen kiépíthető, könnyű tervezni és fejleszteni, azonban nehezen lehet kicserélni, nem elég robosztus, és nehezen skálázható, mivel az erőforrásokat közösen kezelik a funkciók.

Ezzel ellenzétben a mikro szolgáltatás architektúrát ugyan nehezen lehet megtervezni, hiszen egy elosztott rendszert kell megtervezni, ahol az adatátviteltől kezdve az erőforrás megosztáson keresztül semmi sem egyértelmű, viszont a későbbi tovább fejlesztés sokkal egyszerűbb, mivel külön csapatokat lehet rendelni az egyes szolgáltatásokhoz, és könnyen integrálhatók kicserélhetők az alkotó elemek. Mivel sok kis egységből áll, könnyebben lehet úgy skálázni a rendszert, hogy ne pazaroljuk el az erőforrásainkat, és ugyanakkor a kis szolgáltatások erőforrásokban is el vannak különítve, így nem okoz gondot, hogy fel vagy le skálázzunk egy szolgáltatást. Ennek az a hátránya, hogy le kell kezelni a skálázáskor a közös erőforrásokat.(Például ha veszünk egy autentikációs szolgáltatást, akkor ha azt fel skálázzuk, meg kell tartanunk a felhasználók listáját, így duplikálni kell az adatbázist, és fenntartani a konzisztenciát) Ugyan csak előnye a mirco-service architektúrának, hogy különböző technológiákat lehet keverni vele, mivel az egyes szolgáltatások különböző technológiákkal különböző platformon is futhatnak.
