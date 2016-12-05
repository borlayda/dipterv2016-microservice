Technológiai áttekintés
-----------------------

Az integrációhoz olyan technológiákat[@micro-introPt1] lehet használni, melyek lehetővé teszik az egyes szolgáltatások elkülönült működését. Ahhoz, hogy jó technológiákat válasszunk, mindeképpen ismernünk kell az igényeket, mivel a technológiák széles köre áll rendelkezésünkre. Fontos szem előtt tartani pár általános érvényű szabályt is[@micro-golden], ami a mikroszolgáltatások helyes működéséhez kell. Ezek pedig a következők:

* Modulárisan szétválasztani a szolgáltatásokat
* Legyenek egymástól teljesen elkülönítve
* Legyen jól definiált a szolgáltatások kapcsolata

A következő feladatokra kellenek technológiák:

* Hogyan lehet feltelepíteni egy önálló szolgáltatást? (telepítés)
* Hogyan lehet összekötni ezeket a szolgáltatásokat? (automatikus környezet felderítés)
* Hogyan lehet fenntartani, változtatni a szolgáltatások környezetét? (konfiguráció management)
* Hogyan lehet skálázni a szolgáltatást? (skálázás)
* Hogyan lehet egységesen használni a skálázott szolgáltatásokat? (load balance, konzisztencia fenntartás)
* Hogyan lehet virtualizáltan ezt kivitelezni? (virtualizálás)
* A meglévő szolgáltatásokat hogyan tartsuk nyilván? (service registy)
* Hogyan figyeljük meg az alkalmazást működés közben (monitorozás, loggolás)

### Telepítési technológiák

A mikroszolgáltatásokat valamilyen módon létre kell hozni, egy hosthoz kell rendelni, és az egyes elemeket össze kell kötni. A szolgáltatások telepítéséhez olyan technológiára van szükség amivel könnyen elérhetünk egy távoli gépet, és könnyen kezelhetjük az ottani erőforrásokat. Ehhez a legkézenfekvőbb megoldás a Linux rendszerek esetén az SSH kapcsolaton keresztül végrehajtott Bash parancs, de vannak eszközök, amikkel ezt egyszerűbben és elosztottabban is megtehetjük.

* **Jenkins**[@jenkins]: A Jenkins egy olyan folytonos integráláshoz kifejlesztett eszköz, mellyel képesek vagyunk különböző funkciókat automatizálni, vagy időzítetten futtani. A Jenkins egy Java alapú webes felülettel rendelkező alkalmazás, amely képes bash parancsokat futtatni, Docker konténereket kezelni, build-eket futtatni, illetve a hozzá fejlesztett plugin-eken keresztül, szinte bármire képes. Támogatja a fürtözést is, így képesek vagyunk Jenkins slave-eket létrehozni, amik a mester szerverrel kommunikálva végzik el a dolgukat. A mikroszolgáltatás architektúrák esetén alkalmas a szolgáltatások telepítésére, és tesztelésére.

* **ElasticBox**[@elasticbox]: Egy olyan alkalmazás, melyben nyilvántarthatjuk az alkalmazásainkat, és könnyen egyszerűen telepíthetjük őket. Támogatja a konfigurációk változását, illetve számos technológiát, amivel karban tarthatjuk a környezetünket (Docker, Puppet, Ansible, Chef, stb). Együtt működik különböző számítási felhő megoldásokkal, mint az AWS, vSphere, Azure, és más környezetek. Hasonlít a Jenkins-re, csupán ki van élezve a mikroszolgáltatás alapú architektúrák vezérlésére (Illetve fizetős a Jenkins-el ellentétben). Mindent végre tud hajtani ami egy mikroszolgáltatás alapú alkalmazáshoz szükséges, teljes körű felügyeletet biztosít. [@jenkins-elasticbox]

* **Kubernetes**[@kubernetes]: A Kubernetes az ElasticBox egy opensource változata, ami lényegesen kevesebbet tud, azonban ingyenesen elérhető. Ez a projekt még nagyon gyerekcipőben jár, így nem tudom felhasználni a félév során.

Egyéb lehetőség, hogy a fejlesztő készít magának egy olyan szkriptet, ami elkészíti számára a mikroszolgáltatás alapú architektúrát, és lehetővé teszi az elemek dinamikus kicserélését (ad-hoc megoldás). Ennek a megoldásnak a hátránya hogy nincs támogatva, és minden funkciót külön kell implementálni. Sokkal nagyobb erőforrásokat emészthet fel mint egy ingyenes, vagy nyílt forrású megoldást választani.

### Környezet felderítési technológiák

Az egyes szolgáltatásoknak meg kell találniuk egymást, hogy megfelelően működhessen a rendszer, azonban ez nem mindig triviális, így szükség van egy olyan alkalmazásra, amivel felderíthetjük az aktív szolgáltatásokat.

* **Consul**[@consul]: A Hashicorp szolgáltatásfelderítő alkalmazása, amely egy kliens-szerver architektúrának megfelelően megtalálja a környezetében lévő szolgáltatásokat, és figyeli az állapotukat (ha inaktívvá válik egy szolgáltatás a Consul észre veszi). Ez az alkalmazás egy folyamatosan választott mester állomásból és a többi slave állomásból áll. A mester figyeli az alárendelteket, és kezeli a kommunikációt. Egy új slave-et úgy tudunk felvenni, hogy a consul klienssel kapcsolódunk a mesterre. Ha automatizáltan tudjuk vezényelni a feliratkozást, egy nagyon erős eszköz kerül a kezünkbe, mivel eseményeket küldhetünk a szervereknek, és ezekre különböző feladatokat hajthatunk végre.

A Consult leszámítva nem nagyon találtam olyan eszközt ami a nekem kellő funkciókat tudta volna, főleg csak bizonyos szolgáltatásokhoz találtam felderítő eszközt. A kézi megoldás itt is lehetséges, mivel saját névfeloldás esetén a névfeloldó szervert használhatjuk az egyes állomások felderítésére, vagy Docker-t használva a Docker hálózatok elérhetővé teszik a szolgáltatásokat a futtató konténer hoszt nevével.

### Konfiguráció management

A telepítéshez és a rendszer állapotának a fenntartásához egy olyan eszköz kell, amivel gyorsan egyszerűen végrehajthatjuk a változtatásainkat, és ha valamit változtatunk egy szolgáltatásban, akkor az összes hozzá hasonló szolgáltatás értesüljön a változtatásról, vagy hajtson végre ő maga is változtatást.

* **Puppet**[@puppet]: Olyan nyílt forrású megoldás, amellyel leírhatjuk objektum orientáltan, hogy milyen változtatásokat akarunk elérni, és a Puppet elvégzi a változtatásokat. Automatizálja a szolgáltatás változtatásának minden lépését, és egyszerű, gyors megoldást szolgáltatat a komplex rendszerbe integráláshoz.

* **Chef**[@chef]: A Chef egy olyan konfiguráció menedzsment eszköz ami nagy mennyiségű szerver számítógépet képes kezelni, fürtözhető, és megfigyeli az alá szervezett szerverek állapotát. Tartja a kapcsolatot a gépekkel, és ha valamelyik konfiguráció nem felel meg a definiált repectkönynek, (amiben definiálhatjuk az elvárt környezeti paramétereket) akkor változtatásokat indít be, és eléri, hogy a szerver a megfelelő konfigurációval rendelkezzen. Népszerű konfiguráció menedzsment eszköz, amit könnyedén használhatunk integrációhoz, illetve a szolgáltatások cseréjéhez, és karbantartásához.

* **Ansible**[@ansible]: A Chef-hez hasonlóan képes változtatásokat eszközölni a szerver gépeken egy SSH kapcsolaton keresztül, viszont a Chef-el ellentétben nem tartja a folyamatos kapcsolatot. Az Ansible egy tipikusan integrációs célokra kifejlesztett eszköz, amelyhez felvehetjük a gépeket, amiken valamilyen konfigurációs változtatást akarunk végezni, és egy "playbook" segítségével leírhatjuk milyen változásokat kell végrehajtani melyik szerverre. Könnyen irányíthatjuk vele a szolgáltatásokat, és definiálhatunk szolgáltatásonként egy playbook-ot ami mondjuk egy fürtnyi szolgáltatást vezérel. Ez az eszköz hasznos lehet, ha egy szolgáltatásnak elő akarjuk készíteni a környezetet.

* **SaltStack**[@saltstack]: A SaltStack nagyon hasonlít a Chef-re, mivel ez a termék is széleskörű felügyeletet, és konfiguráció menedzsmentet kínál számunkra, amit folyamatos kapcsolat fenntartással, és gyors kommunikációval ér el. Az Ansible-höz nagyon hasonlóan konfigurálható, szintén ágens nélküli kapcsolatot tud létesíteni, és a Chef-hez hasonlóan több 10 ezer gépet tud egyszerre karbantartani.

Minden konfigurációs menedzsment eszköznek megvan a saját nyelve, amivel deklaratívan le lehet írni, hogy mit szeretnénk változtatni, és azokat a program beállítja. Erre a feladatra nem nagyon érdemes saját eszközt készíteni, mivel számos megoldás elérhető, és a megvalósítás komoly tervezést, és fejlesztést igényel. Érdemes megemlíteni a Docker konténerek adta lehetőséget, mivel a Docker konténerek gyorsan konfigurálhatók, fejleszthetők, és a konténer képeken keresztül jól karbantarthatók, így a konfiguráció menedzsment is megoldható velük. Ami hiányzik ebből a megoldásból az a többi szolgáltatás értesítése a változtatásról.

### Skálázási technológiák

A mikroszolgáltatás alapú architektúrák egyik nagy előnye, hogy az egyes funkciókra épülő szolgáltatásokat könnyedén lehet skálázni, mivel egy load balancert használva csupán egy újabb gépet kell beszervezni, és máris nagyobb terhelést is elbír a rendszer. Ahhoz hogy ezt kivitelezni tudjuk, szükségünk van egy terheléselosztóra, és egy olyan logikára, ami képes megsokszorozni az erőforrásainkat. Számítási felhő alapú környezetben ez könnyen kivitelezhető, egyébként hideg tartalékban tartott gépek behozatalával elérhető. Sajnálatos módon általános célú skálázó eszköz nincsen a piacon, viszont gyakran készítenek maguknak saját logikát a nagyobb gyártók.

* **Elastic Load Balancer**[@elastic-load-balance]: Az Amazon AWS-ben az ELB avagy rugalmas terhelés elosztó az, ami ezt a célt szolgálja. Ennek a szolgáltatásnak az lenne a lényege, hogy segítse az Amazon Cloud-ban futó virtuális gépek hibatűrését, illtve egységbe szervezi a különböző elérhetőségi zónákban lévő gépeket, amivel gyorsabb elérést tudunk elérni. Mivel ez a szolgáltatás csupán az Amazon AWS-t felhasználva tud működni, nem megfelelő általános célra, azonban ha az Amazon Cloud-ban építjük fel a mikroszolgáltatás alapú architektúránkat, akkor erős eszköz lehet számunkra.

A skálázás egyik legegyszerűbb megvalósítása, hogy egy proxy szervert felhasználva, valamilyen módon egységesen elosztjuk a kéréseket, és egy saját monitorozó eszközzel figyeljük a terhelést (processzor terheltség, memória, hálózati terhelés). Ha valamelyik érték megnő, egy ágenses vagy ágens nélküli technológiával a virtualizált környezetben egy új példányt készítünk a terhelt szolgáltatásból, és a proxy automatikusan megoldja a többit. Nem tökéletes megoldát kapunk, azonban ez a legtöbb felhasználási esetben megfelelőnek bizonyul.

### Terheléselosztás

A mikroszolgáltatás alapú architektúrának egyik fontos eleme a terhelés elosztó, vagy valamilyen fürtözést lehetővé tevő eszköz. Ez azért fontos, mert egy egységes interfészt tudunk kialakítani a szolgáltatásaink elérésére, és könnyíti a skálázódást a szolgáltatások mentén.

* **HAProxy**[@haproxy] [@LB-haproxy]: Egy magas rendelkezésre állást biztosító, és megbízhatóságot növelő terheléselosztó eszköz. Konfigurációs fájlokon keresztül megszervezhetjük, hogy mely gépet hogyan érjünk el, milyen IP címek mely szolgáltatásokhoz tartoznak, illetve választhatóan round robin, legkisebb terhelés, session alapú, vagy egyéb módon osztja szét a kéréseket az egyes szerverek között. Ez az eszköz csak és kizárólak a HTTP TCP kéréseket tudja elosztani, de egyszerű, könnyen telepíthető, és könnyen kezelhető (ha nem dinamikusan változnak a fürtben lévő gépek, mert ha igen akkor szükséges egy mellékes frissítő logika is).

* **Ngnix**[@nginx]: Az Nginx egy nyílt forráskódú web kiszolgáló és reverse proxy szerver, amivel nagy méretű rendszereket kezelhetünk, és segít az alkalmazás biztonságának megörzésében. A kiterjesztett változatával (Nginx Plus) képesek lehetünk a terheléselosztásra, és alkalmazás telepítésre. Nem teljesen a proxy szerver szerepét váltja ki, de képes elvégezni azt.

A kézi megvalósítás gyakorlatilag egy kézileg implementált terheléselosztó eszköz lenne, amihez viszont hálózati megfigyelés, és routing szökséges, így nem javalott ilyen eszköz készítése.

### Virtualizációs technológiák

A mikroszolgáltatás alapú architektúrák kialakításánál nagy előnyt jelenthet, ha valamilyen virtualizációt használunk fel a környezet kialakításához. Virtualizált környezetben könnyebb a telepítés, skálázás, és a monitorozás is egyszerűbb lehet.

* **Docker**[@docker]: Egy konténer virtualizációs eszköz, amelynek segítségével egy adott kernel alatt több különböző környezettel rendelkező, alkalmazásokat futtató környezetet hozhatunk létre. A Docker egy szeparált fájlrendszert hoz létre a gazda gépen, és abban hajt végre műveleteket. Készíthetünk vele előre elkészített alkalmazás környezeteket, és szolgáltatásokat, ami ideálissá teszi mikroszolgáltatás alapú architektúrák létrehozásánál. A Docker konténerek segítségével egyszerűen telepíthetjük, skálázhatjuk, és fejleszthetjük a rendszert.

* **libvirt**[@libvirt]: Többféle virtualizációs technológiával egyűtt működő eszköz, amivel könnyedén irányíthatjuk a virtuális gépeket, és a virtualizálás komolyabb részét el absztrahálja. Támogat KVM-em, XEN-t, VirtualBox-ot, LXC-t, és sok más virtualizáló eszköt. Ezzel az eszközzel a környezet kialakítását szabhatjuk meg, tehát a hardveres erőforrások megosztásában nyújt nagy segítséget.

* **KVM**[@kvm]: A KVM egy kernel szintű virtualizációs eszköz, amivel virtuális gépeket tudunk készíteni. Processzor szintjén képes szétválasztani az erőforrásokat, és ezzel szeparált környezeteket létrehozni. Virtualizál a processzoron kívül hálózati kártyát, háttértárat, grafikus meghajtót, és sok mást. A KVM egy nyílt forráskódú projekt és létrehozhatunk vele Linux és Windows gépeket is egyaránt.

* **Akármilyen cloud**: Ha virtualizációról beszélünk, akkor adja magát hogy a számítási felhőket is ide értsük. Egy mikroszolgáltatás architektúrájú programot a legcélszerűbb valamilyen számítási felhőben létrehozni, mivel egy ilyen környezetnek definiciója szerint tartalmaznia kell egy virtualizációs szintet, megosztott erőforrásokat, monitorozást, és egyfajta leltárat a futó példányokról. Ennek megfelelően a mikroszolgáltatás alapú architektúra minden környezeti feltételét lefedi, csupán a szolgáltatásokat, business logikát, és az interfészeket kell elkészítenünk. Jellemzően a Cloud-os környezetek tartalmaznak terheléselosztást, és skálázási megoldást is, amivel szintén erősítik a szolgáltatás alapú architektúrákat. Ilyen környezet lehet az Amazon, Microsoft Azure, Google App Engine, OpenStack, és sokan mások.

Amennyiben nincs a kezünkben egy saját virtualizáló eszköz, a virtualizálás kézi megvalósítása értelmetlen plusz komplexitást ad az alkalmazáshoz.

### Szolgáltatás jegyzékek (service registry)

Számon kell tartani, hogy milyen szolgáltatások elérhetők, milyen címen és hány példányban az architektúránkban, és ehhez valamilyen szolgáltatás nyilvántartási eszközt[@service-registry-pattern]  [@micro-introPt3] kell használnunk.

* **Eureka**[@eureka-glance]: Az Eureka a Netflix fejlesztése, egy AWS környezetben működő terheléselosztó alkalmazás, ami  figyeli a felvett szolgáltatásokat, és így mint nyilvántartás is megfelelő. A kommunikációt és a kapcsolatot egy Java nyelven írt szerver és kliens biztosítja, ami a teljes logikát megvalósítja. Együtt működik a Netflix álltal fejlesztett Asgard nevezetű alkalmazással, ami az AWS szolgáltatásokhoz való hozzáférést segíti. Ugyan ez az eszköz erősen optimalizált az Amazon Cloud szolgáltatásaihoz, de a leírás alapján megállja a helyét önállóan is. Mivel nyílt forráskódú, mintát szolgáltat egyéb alkalmazásoknak is.

* **Consul**: Korábban már említettem ezt az eszközt, mivel abban segít, hogy felismerjék egymást a szolgáltatások. A kapcsolatot vizsgáló és felderítő logikán kívül tartalmaz egy nyilvántartást is a beregisztrált szolgáltatásokról, amiknek az állapotát is vizsgálhatjuk.

* **Apache Zookeeper**[@zookeeper]: A Zookeeper egy központosított szolgáltatás konfigurációs adatok és hálózati adatok karbantartására, ami támogatja az elosztott működést, és a szerverek csoportosítását. Az alkalmazást elosztott alkalmazás fejlesztésre, és komplex rendszer felügyeletére és telepítés segítésére tervezték. A consulhoz hasonlóan működik, és a feladata is ugyan az.

Kézi megoldás erre nem nagyon van, csupán egy központi adatbázisban, vagy leltár alkalmazásban elmentet adatokból tudunk valamilyen jegyzéket csinálni, amihez viszont a szolgáltatások mindegyikének hozzá kell férni. Könnyen konfigurálható megoldást kapunk, és tetszőleges adatot menthetünk a szolgáltatásokról, de egyéb funkciók, mint az esemény küldés és fogadás, csak bonyolult implementációval lehetséges.

### Monitorozás, loggolás

Ha már megépítettük a mikroszolgáltatás alapú architektúrát, akkor meg kell bizonyosodnunk róla, hogy minden megfelelően működik, és minden rendben zajlik a szolgáltatásokkal. Ezekhez az adatokhoz többféle módon és többféle eszközzel is hozzáférhetünk, mivel az alkalmazás hibákat egy log szerver, a környezeti problémákat egy monitorozó szerver tudja megfelelően megmutatni számunkra[@micro-service-monitoring] [@microservice-monitoring].

* **Zabbix**[@zabbix]: A Zabbix egy sok területen felhasznált, több 10 ezer szervert párhuzamosan megfigyelni képes, akármilyen adatot tárolni képes monitorozó alkalmazás, ami képes elosztott működésre, és virtuális környezetekben jól használható. Ágens nélküli és ágenses adatgyűjtésre is képes, és az adatokat különböző módokon képes megjeleníteni (földrajzi elhelyezkedés, gráfos megjelenítés, stb.). Nem egészen a mikroszolgáltatás alapú architektúrákhoz lett kialakítva, de egy elég általános eszköz, hogy felhasználható legyen ilyen célra is.

* **Elasticsearch + Kibana[@kibana] + LogStash**[@logstash]: A Kibana egy ingyenes adatmegjelenítő és adatfeldolgozó eszköz, amit az Elasticsearch fejlesztett ki, és a Logstash pedig egy log server, amivel tárolhatjuk a loggolási adatainkat, és egyszerűen kereshetünk benne. Kifejezetten adatfeldolgozásra szolgál mind a két eszköz, és közvetlenül együttműködnek az Elasticsearch alkalmazással.

* **Sensu**[@sensu]: A Sensu egy egyszerű monitorozó eszköz, amivel megfigyelhetjük a szervereinket. Támogatja Ansible Chef, Puppet használatát, és támogatja a plugin-szerű bővíthetőséget. A felülete letisztult, és elég jó áttekintést ad a szerverek állapotáról. Figyel a dinamikus változásokra, és gyorsan lekezeli a változásokkal járó riasztásokat. Ezek a tulajdonságai teszik a számítási felhőkben könnyen és hatékonyan felhasználhatóvá.

* **Cronitor**[@cronitor] [@cron-monitoring]: Ez a monitorozó eszköz mikroszolgáltatások és cron job-ok megfigyelésére lett kifejlesztve, HTTP-n keresztül kommunikál, és a szologáltatások állapotát figyeli. Nem túl széleskörű eszköz, azonban ha csak a szolgáltatások állapota érdekel hasznos lehet, és segíthet a szolgáltatás jegyzék képzésében is.

* **Ruxit**[@ruxit] [@ruxit-monitoring]: Egy számítási felhőben működő monitorozó eszköz, amivel teljesítmény monitorozást, elérhetőség monitorozást, és figyelmeztetés küldést végezhetünk. Az benne a különleges, hogy mesterséges intelligencia figyeli a szervereket, és kianalizálja a szerver állapotát, és a figyelmeztetéseket is követi. Könnyen skálázható, és használat alapú bérezése van. Ez a választás akkor jön jól, ha olyan feladatot szánunk az alkalmazásunknak, ami esetleg időben nagyon változó terhelést mutat, és az itt kapot riasztások szerint akarunk skálázni.

A monitorozás kézi megvalósítása egyszerűen kivitelezhető, ha van egy központi adatbázisunk, amit minden szolgáltatás elér, és ebben az adatbázisban a szolgáltatásokba ültetett egyszerű logika küldhet adatokat, amit valamilyen egyszerű módszerrel megjelenítve, valamilyen monitorozást érhetünk el. Ennek egyik előnye, hogy nem kell komplex eszközt telepíteni mindenhova, és nem kell karban tartani, hátránya viszont, hogy nehezen karbantartható, minden szolgáltatásra külön kell elkészíteni, és a fenti megoldásokkal ellentétben a semmiből kell kiindulni.
