# Feladat megtervezése

## Minta alkalmazás tervezése

A feladatom egyik része az volt, hogy egy olyan minta alkalmazást készítsek, amelyiken keresztül be lehet mutatni a mikroszolgáltatások fejlesztésének, és tesztelésének a lépéseit, és jól reprezentálja az architektúrális minta jellegzeteségeit.
Minta feladatnak egy webes könyvárúház webes kiszolgáló felületét választottam, mivel ez nem túl bonyolult, és könnyen meghatározhatók benne az elkülönülő szolgáltatások.

### Minta alkalmazás

Egy webes könybesbolt esetén szükség van arra, hogy képesek legyünk megtalálni azt a könyvet, amit meg akarunk venni, képesek legyünk bejelentkezni, hogy hozzánk rendelhesse a rendszer az adott könyvet, és képesnek kell lennie a vásárlás lebonyolítására.

Ahhoz hogy ezeket képes legyen véghez vinni, a következőkre van szükség:
* Egy olyan felület, ahol a felhasználó könnyen és egyszerűen tájékozódhat a bolt kínálatáról,
* egy mögöttes adatbázis, amiben megtalálhatók az adatok
* és felhasználó bejelentkeztetéséhez egy autentikűciós szolgáltatás

A minta alkalmazás tetszőleges webes felületen elérhető szolgáltatás lehetett volna, mivel működésükből fakadóan követik a mikroszolgáltatásokat. A webes kisizolgálás esetén különböző URL-eken keresztül érhetjük el az egyes funkciókat, amik leggyakrabban elemien kicsire vannak tervezve.

### Szolgáltatások

A minta alkalmazást először is a korábban már felvázolt módon (\ref{splitting}. fejezet) fel kell bontanom funkciókra, amikre a szolgáltatásaim épülni fognak.
Egy webes könyvesbolttal kapcsolatban olyan szavakkal találkozhatunk, mint a böngészés, vásárlás, vagy bejelentkezés. Ezekre a funkciókra határoztam meg szolgáltatásokat, illetve az ehhez kellő más erőforrás vezérlő szolgáltatásokat.

Alkalmazás szolgáltatásai:

* Bejelentkezés: Ennek a szolgáltatásnak az a célja, hogy a beregisztrált felhasználók képesek legyenek belépni, és magukhoz rendelni a megrendeléseket.
* Vásárlás: A vásárlók megrendeléseit, és a készlet csökkentését végzi.
* Böngészés: Megjeleníti az boltban lévő könyveket, amiket meg lehet venni, illetve információt szolgáltat a mennyiségrőll is, hogy lehessen tudni, ha valamelyik könyv már nem kapható.

Környezethez tartozó egyéb szolgáltatások:

* Adatbáziskezelő: Mivel minden szolgáltatásnak valamilyen módon közös adathalmazon kell dolgoznia, kényelmesebb lehet egy külső szolgáltatás formájában elérhetővé tenni az adatbázist, amit több funkció is módosíthat.
* Terheléselosztó: A mikroszolgáltatások egyik legnagyobb előnye, hogy szabadon és egyszerűen skálázható. Ezt a tulajdonságot egy terheléselosztón keresztül könnyen meg tudom oldani.

Egy webes árúháznak lehet sokkal több alkotó eleme is, hiszen keresés, és korás funkciók nem lettek felsorolva, viszont az alap funkciókat tartalmazza, és képes kiszolgálni a felhasználókat így elegendő a feladat szempontjából.

![Mikroszolgáltatások terve](img/microservices.png)

### Kommunikáció

A szolgáltatások közötti komminukáció alapja egy olyan széles körben használt protokollon fog alapulni, amivel könnyen lehet tervezni, könnyű implementálni, és hatékonyan képes a kéréseket kezelni. Ahhoz hogy a szolgáltatások egymás között kommunikálni tudjanak, szükség lesz egy nyilvántartó eszközre, hogy az egyes szeparált szolgáltatások valahogy egymésra találjanak.

## Folytonos Integráció

A folytonos integráció[@continuous-integration] (continuous integration) egy jól bevált szoftver fejlesztési gyakorlat, ami azt a célt szolgálja, hogy automatizáltan képesek legyünk a fejlesztett alkalmazásról megmondani, hogy jól funkcionál-e. Az elmélet különböző fázisokat különböztet meg, amiket azért kell véghezvinni, hogy könnyen és egyszerűen tudjuk integrálni a tesztelendő alkalmazást, illetve gyorsítja a visszajelzés folyamatát. Ezeket a fázitokat mutatja az \ref{CIphases}. ábra.

![Folytonos integráció fázisai](img/ci_phases.png)

* *Verziókezelő*: Ahhoz, hogy követni lehessen a változásokat, és a forrásokat meg tudjuk szerezni szervezett, követkető módon, egy verziókezelőre van szükség.
* *Automatizált build rendszer*: A kinyert változtatások alapján el kell készíteni az alkalmazás futtatható és végleges formáját, amit build formájában nyerhetünk ki. Ez sok esetben egy konkrét csomag elkészítése, ami Linux rendszerek esetén egy Debian, vagy RPM csomag, vagy egy olyan termék az eredménye, amit egy az egyben fel lehet telepíteni tetszőleges rendszerre. Ennek a fázisnak a kimenete legalább egy log fájl, ami tartalmazza a build folyamat minden lépését, és a hibákat tartalmazza, ha valami rosszul sikerül, illetve egy olyan artifact, ami sikeres build esetén felhasználható mint maga a termék. A folyamat során teszteket is végrehajthatunk, mivel a leggyakrabban a build folyamat részeként futnak le az egység tesztek, amik az alap funkciók működő képességéről tanúskodnak.
* *Automatikus integráció*: Ha már van egy sikeres build-ünk, akkor azt a bizonyos eredmény artifact-ot valamilyen környezetbe integrálni kell, hogy a valós körülményeknek megfelelően tesztelhessük őket. A környezet maga lehet virtuális vagy valós, és lehetséges, hogy szükség van a telepítés előtt felkészítő folyamatokra is, melyek részét képezik ennek a fázisnak. Egy ilyen előzetes felkészítés lehet például a tűzfal helyes beállítása, ha az alkalmazásunk külső hálózati kapcsolatot is használ.
* *Alkalmazás valós környezetben való tesztelése*: Ebben a fázisban történik az alkalmazás széleskörű funkcionális és stressz tesztelése, ami azt jelenti, hogy az éles környezetben futó alklamazást olyan bemeneteknek, és eseményeknek tesszük ki, hogy a valóságot lehető legjobban megközelítsük.
* *Kiértékelhető eredmények mentése*: Minden fázisnak van valamilyen információval bíró kimenetele, amiket el kell menteni egy olyan helyre, ahol bármikor visszakövethető, és kikereshetők az eredmények. A build folyamatnak, az integrációnak, és a teszt eredményeknek olyan kimenetei is vannak, melyek alapján a konkrét környezet elérése nélkül is képesek lehetünk megmondani, hogy mi is volt a hiba forrása.

A folytonos integrációt nem csak ilyen módon lehet felhjasználni, hanem majdnem tetszőleges folyamat kidolgozható hozzá, ha a valamilyen egyszerű módon képesek vagyunk a változtatásokat időről időre integrálni és tesztelni. Nem szükséges hozzá, hogy a teljes folyamat automatizált legyen, azonban megkönnyíti a fejlesztők dolgát, ha miden fázis automatikusra van készítve.

A folytonos integrációhoz hasonlóan létezik egy olyan fejlesztési gyakorlat, ami a termék kiadására vonatkozóan írja le a folyamatot. Ez a folytonos szállítás[@continuous-delivery] (continuous delivery), ami kicsit szabadabban van megfogalmazva, és akár részének tekinthető a folytonos integráció. A folytonos szállítást, a már megismert fázisokon kívül egy fejlesztési, és egy kiadási fázissal toldották meg, ami a megjelenő termék kiadását, és a kód fejlesztésének meghatározását takarja.

### Használati módok mikroszolgáltatások esetén

Mikroszolgáltatások esetén a folytonos integrációt támogató rendszereket hatékonyan lehet fölhasználni, mivel minden szolgáltatás külön termékként képzelhető el, és a közös integráció is egy fontos tesztelendő elem, amit a fejlesztő csapatok csak nagyon nehézkesen tudnának megoldani kézileg.

Egy módszer a folytonos integráció felhasználására, ha a mikroszolgáltatásokat automatizáltan elkészítjük, és az egyes szolgáltatásokat magukban kipróbáljuk, majd a nagy egységbe foglalt alkalmazást hozzáértő emberek kezében hagyjuk, és nem törődünk vele.

Másik megközelítés lehet, ha az egyes szolgáltatásokat nem kezeljük külön, hanem egyben mindent elkészítünk, és az egész alkalmazást teszteljük autimatizáltan. Ekkor persze felmerülhet az a gond, hogy nehezebben tudjuk megmondani, melyik szolgáltatás hiábja okozta a végleges termék hibáját, azonban megfelelő információk kinyerésével ez sem okozhat gondot.

Végül a teljesen automatizált változatnál külön elkészítjük a szolgáltatásokat, és futtatjuk a hozzájuk tartozó teszteket, és ha minden rendben ment az összes többi szolgáltatással együtt még robosztusabb, és alklamazás szempontjából kritikus teszteket futtatunk automatizáltan.

Azt, hogy melyik a leghatékonyabb megoldás, azt csak konkrét felhasználók tudják megmondani, mivel lehet hogy az erőforrások, lehet hogy az igény, de az is lehet, hogy a praktikusság fogja megszabni melyiket is válasszuk.

A teljesen automatizált folytonos integrációs keretrendszer esetén nagy mennyiségű erőforrásra van szükség, mivel az egyes szolgáltatások tesztelése, és a teljes alklamazás tesztelése is külön erőforrásokat igényel, viszont ha van elég erőforrás, ez lehet a legjobb döntés.

A kis elemi szolgáltatásokat figyelő keretrendszer esetén sokkal kevesebb erőforssá is elég, és sokkal gyorsabb visszajelzést ad a fejlesztő csapatnak, mivel nem kell kivárniuk a komplex alkalmazás tesztjeinke az eredményeit. Ennek lehet az a hátulütője, hogy később kapunk információt egy hiba jelenlétéről, ami sok időt elvehet a fejlesztésből, így vigyázni kell ebben az esetben.

A teljes alkalmazást figyelő integrációs keretrendszernél megkapjuk a folyamat végén az eredményt, ami valós eredményt ad a szolgáltatások működéséről, azonban nagyon lassú visszajelzési forma lehet ez. Ha minden szolgáltatást együtt nézünk, a tesztelés hasonlóan működik, mint egy monolitikus program esetén, így nem célszerű így tesztelni mikroszolgáltatások esetén, azonban kevesebb erőforrást vihet el ez a megoldás, mint a korábbi kettő.

A feladat elvégzéséhez próbáltam egy mindent automatizáló keretrendszert létrehozni, hogy maximalizálni tudjam a mikroszolgáltatásokhoz adott előnyöket.

### Folytonos Integrációt használó keretrendszer feladatai

A folytonos integrációt használó keretrendszereknek lehetőséget kell biztosítaniuk, hogy a buildelés, integráció, és tesztelés folyamata, valamilyen automatizmus segítségével végrehajtható legyen. Ehhez egy általános interfészt kell biztosítania, amivel megmondhatjuk, hogy milyen lépéseken kell végigmenni, hogy az adott fázis végrehajtottnak legyen tekinthető.

### Keretrendszer előnyei a fejlesztésre nézve

A feladat részeként el kell készítenem egy folytonos integrációt támogató keretrendszert, ami a korábban felsorolt tulajdonságokat, és feladatokat képes végrehajtani. Egy mikroszolgáltatás alapú alklamazás fejlesztése közben egy ilyen keretrendszer segít a gyors visszajelzésben, mivel egy szolgáltatás fejlesztése közben nem lehetünk biztosak benne, hogy minden esetben a teljes alkalmazás működő képes, illetve segít felderíteni a szolgáltatás interfészek közötti kritikus eltéréseket.

A gyors visszajelzés mindig fontos, hiszen lassú, és erőforrás igényes feladat, ha a fejlesztő csapatnak kell kipróbálnia a szolgáltatást mind magában egyedileg, mind a komplex alkalmazás részeként. Ezt a költséget megspóroljuk, ha központileg fut az ellenőrzés, és a közös erőforrésokat is könnyebbenlehet optimalizálni. Az összes csapatnak adható olyan folytonos integrációs struktúra, amely a szolgáltatás változtatása esetén egy build folyamatot futtatva megpróbálja integrálni az eredményként kapott alkalmazás részletet, és teszteli az együttműködő képességet. Mivel közös erőforrásokon fut nem kell várni, hogy szabad idősávot kapjon a csapat, és az automatizáltság segít, hogy a csapat másra fordíthassa a figyelmet, amíg nem kap eredményt.

Az interfészek figyelését ugyan az az infrastruktúra figyelheti ami az integrációt, és a szolgáltatás helyességét figyeli, de ebben a tesztelési logikában szerepelnie kell egy olyan interfész tesztelésnek, ami képes detektálni azt, hogy a jelenlegi interfészekkel kompatiblis a szolgáltatás, illetve azt is, hogy visszafelé, korábbi verziókkal kompatilibis-e az új kialakítás.

Fejlesztés szempontjából a folytonos integrációs eszköz tartalmazhat olyan logikát, ami a közvetlen változásokra fut le, és intelligens módon határozza meg a változás hatásait. Az egyik legnépszerűbb folytonos integrációt támogató rendszerben a Jenkins-ben például van plugin minden verziókezelőhöz, amely képes a változtatások felküldésére olyan feladatokat futtatni, amik a kód minőségét (kódolási technika, formázottság, dokumentáció generálás, stb.) figyelik és javítják. Ennek a funkciónak a használata ugyan úgy hasznos lehet mikroszolgáltatások esetén, mint bármilyen fejlesztési módszer esetén.

### Lépések bemutatása

A feladat tervezése közben próbáltam minden szempontot szem előtt tartani, és a következő részeket határoztam meg a minta alkalmazásomhoz.

* Buildelés minden szolgáltatásra: Mivel minden szolgáltatás egyedi, és a szolgáltatások külön termékként kezelésével növelhetjük a modularitást, és az újrafelhasználhatóságot, így minden szolgáltatásnak külön build folyamatot terveztem, amik eredményeként az önműködő alklamazás részleteket kapjuk meg.
* Alkalmazás indítása, minden szolgáltatással: Ha minden részlet elkészült, akkor az összes szolgáltatás indításával és a környezet felkészítésvel egy minta környezetet készítek amiben az alkalmazás fut.
* Tesztek futtatása: A minta környezetben teszteket futtatok, amivel megbizonyosodhatom az alkalmazás működőképességéről.
* Utómunkálatok elvégzése: Mivel a környezet a saját gépem lesz, ezért a nem használt elemek törlése, és a környezet kitisztítása, illetve az eredmények lementése kerül ide.
