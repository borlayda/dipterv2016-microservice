Nehézségek, megoldás értékelése
-------------------------------

Sajnálatos módon egy ilyen összetett, és elágazó rendszer esetén gyakran ütközünk problémákba, és ezeket a gondokat leggyakrabban nem is a saját fejlesztésünk, hanem a használt eszküzük okozzák. Erre a célra hasznos lehet fenntartani a folytonos integrációt támogató eszközben egy eszköz konzisztenciát, és visszafelé kompatibilitást tesztelő részt fejleszteni, illetve lassan, és megfontoltan váltani az új eszközverzióknál.

###Nehézségek a Docker használatával

A diplomaterv elkészítése során számtalanszor futottam olyan hibába, amit a Docker konténerek használata okozott. Volt olyan, hogy az alapul szolgáló image készítésekor nem volt megfelelő a repository, és eltűntek csomagok amikre szükségem lett volna, hol a futó konténerek álltak le minden ok nélkül. A Docker fejlesztése közben sajnálatos módon nem gondoltak a visszafele kompatibilitásra, és minden új verzióban van valamilyen meglepetés, ami nem úgy működik, mint a korábbiban. Találtam egy cikket[@docker-is-bad], ami leírja a legtöbb problémát, amivel Docker konténerek használata közben találkozhatunk, viszont nem igazán van alternatív lehetőség.

Az egyik legnagyobb probléma amivel találkoztam, az a Centos alapú konténerek esetében jelentkezett. Ez a probléma az volt, hogy a Centos alap image megváltozott, és onnantól kezdve nem lehetett használni benne az Nginx szolgáltatást, vagy akármyilen szolgáltatást. A Docker konténerekben használt programok megváltoztak, és a build során történt frissítés lehetetlenné tette a szolgáltatás működését. Megoldásként átálltam egy Ubuntu alapú image-re, mivel abban nem jelentkezett ilyen jellegű hiba.

###Nehézségek a Consul használatával

A Consul használatához hozzászoktam már a korábbi félévek során, de az újítások miatt kicsit át kellett gondolnom a használatot. Eleinte megpróbáltam használni az önálló laboratórium során használt szkriptemet, de valamilyen szintaktikai hibára panaszkodott, és nem tudtam használni azt a változatot. Az én megérzésem az, hogy az események küldésében történt valami, mivel látszólag a Docker-el ellentétben a Consul visszafelé kompatibilis, és a szerver építés nem változott. Sajnálatos módon elég sok időt emésztett fel egy új változat elkészítése, ami végül sokkal hibatűrőbb lett, mint elődje, és nem csak egy fix ponton keresztül lehet elérni a többi Consul klienst. Egy másik változtatás lett, hogy minden végpont szerverként funkcionál, így ha kiesik valamelyik szerver, a Consul hálózat nem szakad meg, és nem kell újra építeni.

A Consul template egy új fejlesztése a Hashicorp-nak, és a honlapon ad is pár mintát a fejlesztő cég, azonban nincs kiélezve a valóságra, így kénytelen voltam más forrásokból megtudni, hogy hogyan célszerű használni a Consul Template-et HAProxy-val. Az előző félévben események küldésével oldottam ezt meg, viszont ez az új funkció sokkal ígéretesebbnek tűnt.

###Váratlan meglepetések

Ugyan a legnagyobb meglepetést a Docker okozta az image inkonzisztenciájával, de ettől függetlenül volt néhány apróbb meglepetés, ami a fejlesztést visszavetette. Egy ilyen meglepetés például, hogy a Docker konténerekben beállított hosts fájl tartalma már nem az mint korábban, és ezen keresztül nem látják egymást a konténerekek. A HAProxy-val kapcsolatban ez előző félévhez képest nem történt semmi, azonban a felhasznált verzió változhatott, mivel sem az indító szkript, sem a konfigurációs fájl nem ott volt megtalálható, mint az előző félévben.

Ami a MySQL-t illeti a Docker konténerekben való használata nem igazán támogatott dolog, mivel nem kéne kritikus adatokat használni a konténerekben, de az előző félévhez képest változott a csomag, mivel a konténer buildelésénél egy olyan hiba merült fel, hogy a csomag kiakadt, amikor a felhasználó nevet és jelszót kérte a telepítő. Ezt egy egyszerű módosítás megoldotta, de nagyon sok idő volt rájönni, mivel is van a baj.
Ami az adatbázist illeti, nem csak a csomag de a működés és a hozzá tartozó authentikáció is megváltozott, mivel az előző félévben képes voltam jelszó nálkül használni a felhasználót, addig ebben a félévben kötelező volt megadnom valamit, ami az összes szolgáltatás változtatásával járt.

###Értékelés

####Komponensek

A minta alkalmazás főbb komponensei a mikroszolgáltatások elve szerint lettek szétválasztva, azonban az adatbázis külön szolgáltatásként kezelése nem teljesen ezt a metodológiát követi. A praktikusság és erőforrás kezelés szempontjából sokkal jobb megoldást kaptam, mint ha az össze szolgáltatás önálló adatbázissal rendelkezne, de lehet, hogy még jobb lett volna egy szolgáltatásokon kívül elhelyezkedő adatbázis szerver.
Ami az authentikációt illeti, lehetséges, hogy jobban jártam volna egy szolgáltatásonkénti ellenörzéssel, mivel ha kiveszem az authentikációt vezérlő szolgáltatást, az egész alkalmazás veszélynek lesz kitéve. Természetesen más megközelítésből ez a tervezés éppen jó, hiszen az authentikálás funkcióját csak egy szolgáltatás végzi, és így plugin-szerűen kivehető, vagy berakható.

####Kommunikáció

Ami a Rest kommunikációt illeti, teljesen megfelelt a célnak, és könnyen egyszerűen tudtam vele változtatni az interfészeket, és nagyon egyszerű volt a kiszolgáló alkalmazások elkészítése is. Ha cél lett volna más kommunikációs technológiák bemutatása is, akkor sokkal nehezebb feladatom lett volna, mivel a kevert Rest-es és XML alapú, vagy socket kommunikáció, komoly többlet fejlesztés okozott volna, illetve a struktúrát is átrajzolta volna.

####Fejlesztési élmény

A minta alkalmazás fejlesztése során nem használtam semmilyen folytonos integrációt támogató eszközt, se semmilyen automatizált módszert, ami ellenőrizte volna a munkámat. Sajnos ez nagyon megnehezítette a fejlesztést, mivel minden alkalommal külön meg kellett győződnöm arról, hogy az alkalmazás minden eleme külön elkészíthető, és a létrehozott alkalmazás is jól használható, illetve az interfészek is jól működnek. Ha lett volna valamilyen automatizált módszer, ami a kód szintaktikáját folyamatosan figyelte volna minden változtatáskor, vagy lett volna valamilyen logika, ami megpróbálta volna összerakni az alkalmazást, és funkció tesztek alapján megmondta volna, hogy jó-e amit csinálok, akkor sokkal gyorsabban is haladhattam volna. A félév során több Docker-es problémába is beleütköztem, és volt, hogy csak órák alatt jöttem rá, hogy a Docker konténer a hibás. Ezt egy egyszerű konzisztencia ellenőrzés elkaphatta volna és percek alatt meglett volna a hibaok.
