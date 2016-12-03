Implementáció és kapcsolódó nehézségek
======================================

Minta alkalmazás implementációja
--------------------------------

A minta alkalmazás megvalósításához *Docker* konténereket használtam, hogy a saját laptopomon, vagy egy dedikált gépen is meg tudjam oldani az elosztott alkalmazást, mivel így kevés erőforrással is meg tudtam csinálni amit akartam. A kommunikációra kiválasztott módszer a *REST*-es kommunikáció lett, mivel egy széles körben használt megoldás, és rengeteg nyelv támogatja. A szolgáltatások jegyzéséhez *Consult* használtam, ami az utóbbi években sokat fejlődött, és elég átfogó funkcionalitást nyújt számomra.

###Szolgáltatások megvalósítása Docker konténerekben

A mikroszolgáltatások egyik legnagyobb előnye, hogy különböző platformokat és programozási nyelveket használhatunk az architektúrában különösebb probléma nélkül. Ezt a Docker-el úgy oldottam meg, hogy Centos és Ubuntu disztribúciójú környezeteket, és PHP, Python, Java, illetve Bash szkripteket használtam.

A szolgáltatásokhoz tartozó Docker konténerek:

* **Adatbázis**: Az alapja egy *'mysql'* nevezetű konténer, ami tartalmaz egy lightweight Ubuntu-t és benne telepítve egy mysql szervert. Ezt a konténert egy inicializáló szkripttel egészítettem ki, ami elkészítette az alap adatbázist.
* **Terheléselosztó**: A terheléselosztást *HAProxy*-val oldottam meg, amit egy Ubuntu konténerre alapoztam. Létezik egy olyan Docker konténer, ami kifejezetten HAProxy mikroszolgáltatásnak van nevezve, azonban ez a konténer nehezen használható, és a szolgáltatás újraindítása is el lett rontva benne, így egyszerűbbnek láttam egy saját megvalósítást használni.
* **Webkiszolgáló**: A weboldal kiszolgálását egy *'httpd'* nevű lightweight konténer szolgálja ki amiben egy apache webkiszlgáló van. Ezt kiegészítettem néhány *PHP* szkripttel, ami kiszolgálja a kéréseket. Ezt a konténert terveztem úgy, hogy a kéréseket ő szolgálja ki és ezen a szolgáltatáson keresztül érhető el a többi funkcionalitása.
* **Authentikáció**: Egyszerű Ubuntu konténer, ami fel van szerelve *Python*-nal, és a *MySQLdb* Python könyvtárral. Ezen felül tartalmaz egy REST-es kiszolgálót, amin keresztül elérhető a szolgáltatás. Az authentikáció egyszerű adatbázis alapú azonosítás, amit kódolatlanul tárolunk a MySQL adatbázisunkban. Éles változatban természetesen ez nem elegendő.
* **Vásárlás**: Centos konténer alapú környezet, amiben *Java* lett telepítve, és egy webes REST API-n keresztül érhetjük el a szolgáltatását. A konténer webes szolgáltatását *Ngnix* segítségével tettem elérhetővé. Sajnos a félév során változott a Centos alap image repository-ja, és használhatatlanná tette a szolgáltatást, mivel az Ngnix szolgáltatást többé nem tudtam elindítani. Erről a problémáról bövebben a 'Nehézségek, megoldás értékelése' fejezetben írok.

Szolgáltatás felismerés megoldásai
----------------------------------

A szolgáltatások magukban nem sokat érnek, viszont nem tudnak együtt működni ha nem ismerik egymás elérési útvonalát. Ahhoz, hogy a megfelelő helyre érkezzenek be az üzenetek, valamilyen névfeloldásra van szükség, amely képes irányítani a kéréseket a komplex architektúrában. Egyik lehetőség, hogy a Docker álltal szolgáltatott személyre szabott válózatot használjuk, és jól elnevezett konténereket hozunk létre. Egy másik lehetőség a Consul használata, ami nyilvántartja a beregisztrált végpontokat, és elérhetővé teszi egymás számára. A névfeloldáshoz Consul esetében kis trükkre van szükség, de nem olyan nagy feladat. Ugyan a diplomaterv keretei között csak ezt a két módszert vizsgáltam meg, azonban lehetséges saját névfeloldó szervert karbantartani, vagy egy jól felügyelt környezetben konténereket indítani, mint az Amazon AWS Cloud-ban, ami támogatja ezeket a funkciókat.

###Kapcsolatok építése Docker-el:

Ahogy korábban már említettem lehetőség van a Docker legújabb verzióiban megadni, hogy ez egyes konténerek milyen néven és milyen hálózaton keresztül érhető el a többi konténer. A név beállításához a docker run parancs `--hostname` paraméterét használhatjuk, míg a hálózat definiálásához előbb létre kell hozni egy új Docker hálózatot
```{docker}
  docker network create bookstore
```
amire a konténerek tudnak csatlakozni a `--net` kulcsszóval. Ennek segítségével elérhető, hogy nagyon egyszerűen és egy eszköz felhasználásával képesek legyenek látni egymást a szolgáltatások, viszont egy nagy hátulütője van a megoldásnak, mégpedig az, hogy egy gépen kell futnia az összes alkalmazásnak. Másik hátránya ennek a megoldásnak, hogy a konténerek közül csak egynek lehet olyan nevet adni, ami a szolgáltatásra utal (egyszerre csak egy konténernek lehet mondjuk webserver neve), és éppen ezért a skálázáshoz egy saját logikát kell építeni. Mivel ez egy mikroszolgáltatásokra épülő architektúránál közel sem ideális, így ez csupán fejlesztési, és reprezentatív jelleggel használható.

###Kapcsolatok építése Consul-al:

A Consul alkalmazást korábbi félév folyamán használtam már, teljesítmény mérések futtatására Docker konténerben, így megpróbáltam átültetni a logikát a jelenlegi mikroszolgáltatásokat biztosító architektúrába. A gondot az okozta, hogy a Consul alkalmazásnak szükséges egy fix pont, így alkottam egy logikát, melyben minden szolgáltatás önálló szerverként funkcionál, és az összes szolgáltatás próbál csatlakozni az alháózatban lévő végpontokra. Ennek az az eredménye, hogy minden csatlakozó szerver egy új lehetőséget biztosít, és lassan de biztosan kiépül a Consul hálózat.

Ez a megoldás magában nem elegendő, hogy felismerjék egymást a szolgáltatások, így fel kellett használnom a Consul Template nevezetű technikát, amiben a proxy beállításokban az egyes szolgáltatásokhoz tartozó elemeket egy bejegyzés alá rendelem. Ennek megfelelően a proxy-n keresztül minden szolgáltatás minden más szolgáltatást elér, ás a skálázás esetán a proxy megoldja az új elem lekezelését. Mivel ez a megoldás sokkal robosztusabb a Docker alapúnál, ezért ezt használtam a végső programban.
