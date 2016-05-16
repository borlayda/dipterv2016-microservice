Technológiai áttekintés[@micro-introPt1]
=======================

Az integrációhoz olyan technológiákat lehet használni, melyek lehetővé teszik az egyes szolgáltatások elkülönült működését. Ahhoz, hogy jó technológiákat válasszunk, mindeképpen ismernünk kell az igényeket, mivel a technológiák széles köre áll rendelkezésünkre. Fontos szem előtt tartani pár általános érvényű szabályt is[@micro-golden], ami a mikroszolgáltatások helyes működéséhez kell. Ezek pedig a következők:

* Modulárisan szétválasztani a szolgáltatásokat
* Legyenek egymástól teljesen elkülönítve
* Legyen jól definiált a szolgáltatások kapcsolata

A következő feladatokra kellenek technológiák:
* Hogyan lehet feltelepíteni egy önálló szolgáltatást? (telepítés)
* Hogyan lehet összekötni ezeket a szolgáltatásokat? (automatikus környezet felderítés)
* Hogyan lehet fenntartani, változtatni a szolgáltatások környezetét? (integrációs keretrendszer)
* Hogyan lehet skálázni a szolgáltatást? (skálázás)
* Hogyan lehet egységesen használni a skálázott szolgáltatásokat? (load balance, konzisztencia fenntartás)
* Hogyan lehet virtualizáltan ezt kivitelezni? (virtualizálás)
* A meglévő szolgáltatásokat hogyan tartsuk nyilván? (service registy)
* Hogyan figyeljük meg az alkalmazást működés közben (monitorozás, loggolás)

## Telepítési technológiák

A microservice-eket valamilyen módon létre kell hozni, egy hosthoz kell rendelni, és az egyes elemeket össze kell kötni. A szolgáltatások telepítéséhez olyan technológiára van szükség amivel könnyen elérhetünk egy távoli gépet, és könnyen kezelhetsük az ottani erőforrásokat. Ehhez a legkézenfekvőbb megoldás a Linux rendszerek esetén az SSH kapcsolaton keresztül végrehajtott Bash parancs, de vannak eszközök, amikkel ezt egyszerűbben és elosztottabban is megtehetjük.

* **Jenkins**[@jenkins]: A Jenkins egy olyan folytonos integráláshoz kifejlesztett eszköz, mellyel képesek vagyunk különböző funkciókat automatizálni, vagy időzítetten futtani. A Jenkins egy Java alapú webes felülettel rendelkező alkalmazás, amely képes bash parancsokat futtatni, Docker konténereket kezelni, build-eket futtatni, illetve a hozzá fejlesztett plugin-eken keresztül, szinte bármire képes. Támogatja a fürtözést is, így képesek vagyunk Jenkins slave-eket létrehozni, amik a mester szerverrel kommunikálva végzik el a dolgukat. A microservice architektúrák esetén alkalmas a szolgáltatások telepítésére, és tesztelésére.

* **ElasticBox**[@elasticbox]: Egy olyan alkalmazás, melyben nyilvántarthatjuk az alkalmazásainkat, és könnyen egyszerűen telepíthetjük őket. Támogatja a konfigurációk változását, illetve számos technológiát, amivel karban tarthatjuk a környezetünket. (Docker, Puppet, Ansible, Chef, stb) Együtt működik különböző cloud megoldásokkal, mint az AWS, vSphere, Azure, és más környezetek. Hasonlít a Jenkins-re, csupán ki van élezve a microservice architektúrák vezérlésére. (Illetve fizetős a Jenkins-el ellentétben) Mindent végre tud hajtani ami egy microservice alkalmazáshoz szükséges, teljes körű felügyeletet biztosít. [@jenkins-elasticbox]

* **Kubernetes**[@kubernetes]: A Kubernetes az ElasticBox egy opensource változata, ami lényegesen kevesebbet tud, azonban ingyenesen elérhető. Ez a projekt még nagyon gyerekcipőben jár, így nem tudom felhasználni a félév során.

Egyéb lehetőség, hogy a fejlesztő készít magának egy olyan szkriptet, ami elkészíti számára a micro-service architektúrát, és lehetővé teszi az elemek dinamikus kicserélését. (ad-hoc megoldás)

## Környezet felderítési technológiák

Az egyes szolgáltatásoknak meg kell találniuk egymást, hogy megfelelően működhessen a rendszer, azonban ez nem mindig triviális, így szükség van egy olyan alkalmazásra, amivel felderíthetjük az aktív szolgáltatásokat.

* **Consul**[@consul]: A Hashicorp szolgáltatás felderítő alkalmazása, amely egy kliens-szerver architektúrának megfelelően megtalálja a környezetében lévő szolgáltatásokat, és figyeli az állapotukat (ha inaktívvá válik egy szolgáltatás a Consul észre veszi). Ez az alkalmazás egy folyamatosan választott mester node-ból és a többi slave node-ból áll. A mester figyeli az alárendelteket, és kezeli a kommunikációt. Egy új slave-et úgy tudunk felvenni, hogy a consul klienssel kapcsolódunk a mesterre. Ha automatizáltan tudjuk vezényelni a feliratkozást, egy nagyon erős eszköz kerül a kezünkbe, mivel eseményeket küldhetünk a szervereknek, és ezekre különböző feladatokat hajthatunk végre.

## Integrációs keretrendszerek

A telepítéshez és a rendszer állapotának a fenntartásához egy olyan eszköz kell, amivel gyorsan egyszerűen végrehajthatjuk a változtatásainkat, és ha valamit változtatunk egy szolgáltatásban, akkor az összes hozzá hasonló szolgáltatás értesüljön a változtatáról, vagy hajtson végre ő maga is változtatást.

* **Puppet**[@puppet]: Olyan nyilt forrású megoldás, amellyel leírhatjuk objektum orientáltan, hogy milyen változtatásokat akarunk elérni, és a Puppet elvégzi a változtatásokat. Automatizálja a szolgáltatás változtatásának minden lépését, és egyszerű gyors megoldást szolgáltatat a komplex rendszerbe integráláshoz.

* **Chef**[@chef]: A Chef egy olyan konfiguráció menedzsment eszköz ami nagy mennyiségű szerver számítógépet képes kezelni, fürtözhető, és megfigyeli az alá szervezett szerverek állapotát. Tartja a kapcsolatot a gépekkel, és ha valamelyik konfiguráció nem felel meg a definiált repectkönynek (amiben definiálhatjuk az elvárt környezeti paramétereket) akkor változtatásokat indít be, és eléri, hogy a szerver a megfelelő konfigurációval rendelkezzen. Népszerű konfiguráció menedzsment eszköz, amiz könnyedén használhatunk integrációhoz, illetve a szolgáltatások cseréjéhez, és karbantartásához.

* **Ansible**[@ansible]: A Chef-hez hasonlóan képes változtatásokat eszközölni a szerver gépeken egy SSH kapcsolaton keresztül, viszont a Chef-el ellentétben nem tartja a folyamatos kapcsolatot. Az Ansible egy tipikusan integrációs célokra kifejlesztett eszköz, amelyhez felvehetjük a gépeket, amiken valamilyen konfigurációs változtatást akarunk végezni, és egy "playbook" segítségével leírhatjuk milyen változásokat kell végrehajtani melyik szerverre. Könnyen irányíthatjuk vele a szolgáltatásokat, és definiálhatunk szolgáltatásonként egy playbook-ot ami mondjuk egy fürtnyi szolgáltatást vezérel. Ez az eszköz hasznos lehet, ha egy szolgáltatásnak elő akarjuk készíteni a környezetet.

* **SaltStack**[@saltstack]: A SaltStack nagyon hasonlít a Chef-re, mivel ez a termék is széleskörű felügyeletet, és konfiguráció menedzsment-et kínál számunkra, amit folyamatos kapcsolat fenntartással, és gyors kommunikációval ér el. Az Ansible-höz nagyon hasonlóan konfigurálható (nem lennék meglepve ha azt használná a háttérben), szintén ágens nélküli kapcsolatot tud létesíteni, és a Chef-hez hasonlóan több 10 ezer gépet tud egyszerre karbantartani.

## Skálázási technológiák

A microservice architektúrák egyik nagy előnye, hogy az egyes funkciókra épülő szolgáltatásokat könnyedén lehet skálázni, mivel egy load balancert használva csupán egy újabb gépet kell beszervezni, és máris nagyobb terhelést is elbír a rendszer. Ahhoz hogy ezt kivitelezni tudjuk, szükségünk van egy terhelés elosztóra, és egy olyan logikára, ami képes megsokszorozni az erőforrásainkat. Cloud-os környezetben ez könnyen kivitelezhető, egyébként hideg tartalékban tartott gépek behozatalával elérhető. Sajnálatos módon általános célú skálázó eszköz nincsen a piacon, viszont gyakran készítenek maguknak saját logikát a nagyobb gyártók.

* **Elastic Load Balancer**[@elastic-load-balance]: Az Amazon AWS-ben az ELB avagy rugalmas terhelés elosztó az, ami ezt a célt szolgálja. Ennek a szolgáltatásnak az lenne a lényege, hogy segítse az Amazon Cloud-ban futó virtuális gépek hibatűrését, illtve egységbe szervezi a különböző elérhetőségi zónákban lévő gépeket, amivel gyorsabb elérést tudunk elérni. Mivel ez a szolgáltatás csupán az Amazon AWS-t felhasználva tud működni, nem megfelelő általános célra, azonban ha az Amazon Cloud-ban építjük fel a microservice architektúránkat, akkor erős eszköz lehet számunkra.

## Terhelés elosztás

A microservice architektúrának egyik fontos eleme a terhelés elosztó, vagy valamilyen fürtözést lehetővé tevő eszköz. Ez azért fontos, mert egy egységes interfészt tudunk kialakítani a szolgáltatásaink elérésére, és könnyíti a skálázódást a szolgáltatások mentén.

* **HAProxy**[@haproxy] [@LB-haproxy]: Egy magas rendelkezésre állást biztosító, és megbízhatóságot növelő terhelés elosztó eszköz. Konfigurációs fájlokon keresztül megszervezhetjük, hogy mely gépet hogyan érjünk el, milyen IP címek mely szolgáltatásokhoz tartoznak, illetve round robin módon osztja szét a kéréseket az egyes szerverek között. Ez az eszköz csak és kizárólak a HTTP TCP kéréseket tudja elosztani, de egyszerű könnyen telepíthető, és könnyen kezelhető (ha nem dinamikusan változnak a fürtben lévő gépek, mert ha igen akkor szükséges egy mellékes frissítő logika is)

* **ngnix**[@nginx]: Az Nginx egy nyilt forráskódú web kiszolgáló és reverse proxy szerver, amivel nagy méretű rendszereket kezelhetünk, és segít az alkalmazás biztonságának megörzésében. A kiterjesztett változatával (Nginx Plus) képesek lehetünk a terhelés elosztásra, és alkalmazás telepítésre. Nem teljesen a proxy szerver szerepét váltja ki, de képes elvégezni azt.

## Virtualizációs technológiál

A microservice architektúrák kialakításánál nagy előnyt jelenthet, ha valamilyen virtualizációt használunk fel a környezet kialakításához. Virtualizált környezetben könnyebb a telepítés, skálázás, és a monitorozás is egyszerűbb lehet.

* **Docker**[@docker]: Egy konténer virtualizációs eszköz, amelynek segítségével egy adott kernel alatt több különböző környezettel rendelkező alkalmazásokat futtató környezetet hozhatunk létre. A Docker egy szeparált fájlrendszert hoz létre a host gépen, és abban hajt végre műveleteket. Készíthetünk vele előre elkészített alkalmazás környezeteket, és szolgáltatásokat, ami ideálissá teszi microservice architektúrák létrehozásánál. A Docker konténerek segítségével egyszerűen telepíthetjük, skálázhatjuk, és fejleszthetjük a rendszert.

* **libvirt**[@libvirt]: Többféle virtualizációs technológiával egyűtt működő eszköz, amivel könnyedén irányíthatjuk a virtuális gépeket, és a virtualizálás komolyabb részét el absztrahálja. Támogat KVM-em, XEN-t, VirtualBox-ot LXC, és sok más virtualizáló eszköt. Ezzel az eszközzel a környezet kialakítását szabhatjuk meg, tehát a hardware-eserőforrások megosztásában nyújt nagy segítséget.

* **kvm**[@kvm]: A KVM egy kernel szintű virtualizációs eszköz, amivel virtuális gépeket tudunk készíteni. Processzor szintjén képes szétválasztani az erőforrásokat, és ezzel szeparált környezeteket létrehozni. Virtualizál a processzoron kívül hálózati kártyát, háttértárat, grafikus meghajtót, és sok mást. A KVM egy nyilt forrűskódú projekt és létrehozhatunk vele Linux és Windows gépeket is egyaránt.

* **Akármilyen cloud**: Ha virtualizációról beszélünk, akkor adja magát hogy a CLoud-os környezeteket is ide értsük. Egy microservice architektúrájú programot a legcélszerűbb valamilyen Cloud-os környezetben létrehozni, mivel egy ilyen környezetnek definiciója szerint tartalmaznia kell egy virtualizációs szintet, megosztott erőforrásokat, monitorozást, és egyfajta leltárat a futó példányokról. Ennek megfelelően a microservice architektúra minden környezeti feltételét lefedi, csupán a szolgáltatásokat, business logikát, és az interfészeket kell elkészítenünk. Jellemzően a Cloud-os környezetek tartalmaznak terhelés elosztást, és skálázási megoldást is, amivel szintén erősítik a szolgáltatás alapú architektúrákat. Ilyen környezet lehet az Amazon, Microsoft Azure, Google App Engine, OpenStack, és sokan mások.

## Service registy-k [@service-registry-pattern]  [@micro-introPt3]

Számon kell tartani, hogy milyen szolgáltatások elérhetők, milyen címen és hány példányban az architektúránkban, és ehhez valamilyen szolgáltatás nyilvántartási eszközt kell használnunk.

* **Eureka**[@eureka-glance]: Az Eureka a Netflix fejlesztése, egy AWS környezetben működő terhelés elosztó alkalmazás, ami  figyeli a felvett szolgáltatásokat, és így mint nyilvántartás is megfelelő. A kommunikációt és a kapcsolatot egy Java nyelven írt szerver és kliens biztosítja, ami a teljes logikát megvalósítja. EGyütt működik a Netflix álltal fejlesztett Asgard nevezetű alkalmazással ami az AWS szolgáltatásokhoz való hozzáférést segíti. Ugyan ez az eszköz erősen optimalizált az Amazon Cloud szolgáltatásaihoz, de a leírás alapján megállja a helyét önállóan is. Mivel nyilt forráskódú, mintát szolgáltat egyéb alkalmazásoknak is.

* **Consul**: Korábban már említettem ezt az eszközt, mivel abban segít, hogy felismerjék egymást a szolgáltatások. A kapcsolatot vizsgáló és felderítő logikán kívül tartalmaz egy nyilvántartást is a beregisztrált szolgáltatásokról, amiknek az állapotát is vizsgálhatjuk.

* **Apache Zookeeper**[@zookeeper]: A Zookeeper egy központosított szolgáltatás konfigurációs adatok és hálózati adatok karbantartására, ami támogatja az elosztott működést, és a szerverek csoportosítását. Az alkalmazást elosztott alkalmazás fejlesztésre, és komplex rendszer felügyeletére és telepítés segítésére tervezték. A conzulhoz hasonlóan működik, és a feladata is ugyan az.

## Monitorozás, loggolás [@micro-service-monitoring] [@microservice-monitoring]

Ha már megépítettük a microservice architektúrát, akkor meg kell bizonyosodnunk róla, hogy minden megfelelően működik, és minden rendben zajlik a szolgáltatásokkal. Ehhez többféle módon és többféle eszközzel is hozzáférhetünk, mivel az alkalmazás hibákat egy log szerver, a környezeti problémákat egy monitorozó szerver tudja megfelelően megmutatni számunkra.

* **Zabbix**[@zabbix]: A Zabbix egy sok területen felhasznált, több 10 ezer szervert párhuzamosan megfigyelni képes, akármilyen adatot tárolni képes monitorozó alkalmazás, ami képes elosztott működésre, és virtuális környezetekben jól használható. Ágens nélküli és ágenses adatgyűjtésre is képes, és az adatokat különböző módokon képes megjeleníteni (földrajzi elhelyezkedés, gráfos megjelenítés, stb.). Nem egészen a microservice architektúrákhoz lett kialakítva, de egy elég általános eszköz, hogy felhasználható legyen ilyen célra is.

* **Kibana[@kibana] + LogStash**[@logstash]: A Kibana egy ingyenes adatmegjelenítő és adatfeldolgozó eszköz, amit az elasticsearch fejlesztett ki, és a logstash pedig egy log server, amivel tárolhatjuk a loggolási adatainkat, és egyszerűen kereshetünk benne. Kifejezetten adatfeldolgozásra szolgál mind a két eszköz, és közvetlenül együttműködnek az elasticsearch alkalmazással.

* **Sensu**[@sensu]: A Sensu egy egyszerű monitorozó eszköz, amivel megfigyelhetjük a szervereinket. Támogatja Ansible Chef, Puppet használatát, és támogatja a Plugin szerű bővíthetőséget. A felülete letisztult és elég jó áttekintést ad a szerverek állapotáról. Figyel a dinamikus változásokra, és gyorsan lekezeli a változásokkal járó riasztásokat. Ezek a tulajdonságai teszik a Cloud-okban könnyen és hatékonyan felhasználhatóvá.

* **Cronitor**[@cronitor] [@cron-monitoring]: Ez a monitorozó eszköz mikró-szolgáltatások és cron job-ok megfigyelésére lett kifejlesztve, HTTP-n keresztül kommunikál, és a szologáltatások állapotát figyeli. Nem túl széleskörű eszköz, azonban ha csak a szolgáltatások állapota érdekel hasznos lehet, és segíthet a Service Registry képzésében is.

* **Ruxit**[@ruxit] [@ruxit-monitoring]: Egy Cloud-osított monitorozó eszköz, amivel teljesítmény monitorozást, elérhetőség monitorozást, és figyelmeztetés küldést végezhetünk. Az benne a különleges, hogy mesterséges intelligencia figyeli a szervereket, és kianalizálja a szerver állapotát, és a figyelmeztetéseket is követi. Könnyen skálázható, és használat alapú bérezése van. Ez a választás akkor jön jól, ha olyan feladatot szánunk az alkalmazásunknak, ami esetleg időben nagyon változó terhelést mutat, és az itt kapot riasztások szerint akarunk skálázni.
