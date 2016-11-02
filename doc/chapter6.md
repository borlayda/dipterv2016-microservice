Alkalmazás implementálása
=========================

A minta alkalmazás megvalósításához *Docker* konténereket használtam, hogy a saját laptopomon, vagy egy dedikált gépen is meg tudjam oldani az elosztott alkalmazást, mivel így kevés erőforrással is meg tudtam csinálni amit akartam. A kommunikációra kiválasztott módszer a *REST*-es kommunikáció lett, mivel egy széles körben használt megoldás, és rengeteg nyelv támogatja. A szolgáltatások jegyzéséhez *consult* használtam, ami az utóbbi években sokat fejlődött, és elég átfogó funkcionalitást nyújt számomra.

Szolgáltatások megvalósítása Docker konténerekben
-------------------------------------------------

A mikroszolgáltatások egyik legnagyobb előnye, hogy különböző platformokat és programozási nyelveket használhatunk az architektúrában különösebb probléma nélkül. Ezt a Docker-el úgy oldottam meg, hogy Centos és Ubuntu disztribúciójú környezeteket, és PHP, Python, Java, illetve Bash szkripteket használtam.

A szolgáltatásokhoz tartozó Docker konténerek:

* **Adatbázis**: Az alapja egy *'mysql'* nevezetű konténer, ami tartalmaz egy lightweight Ubuntu-t és benne telepítve egy mysql szervert. Ezt a konténert egy inicializáló szkripttel egészítettem ki, ami elkészítette az alap adatbázist.
* **Terhelés elosztó**: A terhelés elosztást *HAProxy*-val oldottam meg, amit egy Ubuntu konténerre alapoztam. Létezik egy olyan Docker konténer, ami kifejezetten HAProxy mikroszolgáltatásnak van nevezve, azonban ez a konténer nehezen használható, és a szolgáltatás újraindítása is el lett rontva benne, így egyszerűbbnek láttam egy saját megvalósítást használni.
* **Webkiszolgáló**: A weboldal kiszolgálását egy *'httpd'* nevű lightweight konténer szolgálja ki amiben egy apache webkiszlgáló van. Ezt kiegészítettem néhány *PHP* szkripttel, ami kiszolgálja a kéréseket. Ezt a konténert terveztem úgy, hogy a kéréseket ő szolgálja ki és ezen a szolgáltatáson keresztül érhető el a többi funkcionalitása.
* **Authentikáció**: Egyszerű Ubuntu konténer, ami fel van szerelve *Python*-nal, és a *MySQLdb* Python könyvtárral. Ezen felül tartalmaz egy REST-es kiszolgálót, amin keresztül elérhető a szolgáltatás.
* **Vásárlás**: Centos konténer alapú környezet, amiben *Java* lett telepítve, és egy webes REST API-n keresztül érhetjük el a szolgáltatását. A konténer webes szolgáltatását *Ngnix* segítségével tettem elérhetővé. Sajnos a félév során változott a Centos alap image, és használhatatlanná tette szolgáltatást, mivel az Ngnix szolgáltatást többé nem tudtam elindítani. Erről a problémáról bövebben a 8. fejezetben írok.






Kapcsolatok építése Consul-al:
-----------------------------

A Consul alkalmazást korábbi félév folyamán használtam már, teljesítmény mérések futtatására, így megpróbáltam átültetni a logikát a jelenlegi mikroszolgáltatásokat biztosító architektúrába. A gondot az okozta, hogy a Consul alkalmazásnak szükséges egy fix pont, és ehhez találnom kellett egy olyan elemet, ami mindenképpen elsőnek indul el. Ez az elem lett a proxy szerver, ami összefogja az elemeket. A korábbi félévben használt kód megfelelő volt számomra, mivel nagyon hasonló minta alkalmazást használtam a teljesítmény mérésekhez is.

Ez a megoldás nem elég elosztott a mikro szolgáltatások tekintetében, azonban egy elág hatékony, és könnyen implementálható megoldás. A mikro szolgáltatásokra épülő architektúréban jellemzően van egy Service Registry elem, ami lehetővé teszi a szolgáltatások nyílvántartását, és ez biztosíthatja a kapcsolatot is. A Consul ebben a kialakításban pontosan így is működött, viszont található olyan eszköz amit kifejezetten a szolgáltatásokhoz találtak ki. Ez lenne például az Apache Zookeeper.

Kapcsolatok építése Docker-el:
-----------------------------

Ahogy korábban már említettem lehetőség van a Docker legújabb verzióiban megadni ,hogy ez egyes konténerek milyen néven és milyen hálózaton keresztül érhető el a többi konténer. A név beállításához a docker run parancs `--hostname` paraméterét használhatjuk, míg a hálózat definiálásához előbb létre kell hozni egy új Docker hálózatot
```{docker}
  docker network create bookstore
```
amire a konténerek tudnak csatlakozni a `--net` kulcsszóval. Ennek segítségével elértem, hogy nagyon egyszerűen és egy eszköz felhasználásával képesek legyenek látni egymást a szolgáltatások, viszont egy nagy hátulütője van a megoldásnak, mégpedig az, hogy egy gépen kell futnia az összes alkalmazásnak. Mivel ez egy mikroszolgáltatásokra épülő architektúránál közel sem ideális, így ez csupán fejlesztési, és reprezentatív jelleggel használható. (Mivel a labor célja, hogy bemutassam az architektúra működését, ezért ez megfelel számomra)
