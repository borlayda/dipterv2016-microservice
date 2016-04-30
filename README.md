# Mikroszolgáltatásokra épülő architektúra fejlesztésének és tesztelésének támogatása

[Documentation](https://github.com/borlayda/dipterv2016-microservice/wiki)

Alkalmazás leírás:
-----------------

Az alkalmazás, amin ketesztül a mikró szolgáltatások működését bemutatom, egy
könyvesbolt webárúháza lesz, ami rendelkezik egy webes felülettel. A felhasználó
be tud jelentkezni a felületre, és tud könyveket vásárolni magának.

Szolgáltatások:
--------------

A szolgáltatások meghatározásánál elsőnek azt vettem alapul, hogy milyen
feladatokat kell teljesítenie a rendszernek, majd az erőforrásokat vettem
alapul.

A könyvesbolthoz tartozóan a következő tevékenységeket határoztam meg:
* Bejelentkezés: Felhasználó felületen történő authentikálása
* Böngészés: Felhasználó láthatja mi van a raktáron
* Vásárlás: Felhasználó valamit a saját nevére ír
Ezekből a feladatokból a következő szolgáltatásokat lehet elkészíteni:
* Felület kiszolgálása: Egy web kiszolgáló alkalmazása, amin keresztül
  elvégezhetők a különböző műveletek, mint a bejeletkezés, vagy vásárlás.
  Ez a felület magába foglalja a böngészést lehetővé tevő szolgáltatást is.
* Authentikációs szolgáltatás: A bejelentkezni szándékozó felhasználó adatait
  ellenőrzi, és hibás bejelentkezés esetén hibát dob.
* Vásárlási szolgáltatás: A böngészés közben kiválasztott könyveket lefoglalja
  a raktári készletből.
* Adatbázis szolgáltatás: Ez a szolgáltatás tartalmazza a raktár tartalmát, a
  vásárlási naplót, és a bejelentkezési adatokat.
* Terhelés elosztó szolgáltatás: Ez a szolgálatatás a skálázhatóságot segíti,
  és egy egységes interfész kialakításában segít.

Megvalósítás:
------------

A megvalósításhoz felhasznált technológiák a szolgálatatások felismerésében
különböztek. Kipróbáltam a korábbi félévek során használt Consul-t, amivel
dinamikusan esemény vezérelten képesek kommunikálni a szolgálatatások.
Másodszorra a Docker konténerekbe beépített módzsert használtam fel, amivel
könnyen, már indítás közben felismerik egymást a szolgáltatások.
Harmadszorra pedog egy gyakran használt service registry-t használtam, az
Apache Zookeepert.

Megvalósítás Docker konténerekkel:
----------------------------------

Az egyszerűség kedvéért, és a koncepció kipróbálásához Docker konténereket
használtam, mivel ezek könnyedén elindíthatók, kkonfigurálhatók, és helyi gépen
is lehetővé teszik egy komplex architektúra kipróbálását.

A mikro szolgáltatások egyik legnagyobb előnye, hogy különböző platformokat és
programozási nyelveket használhatunk az architektúrában különösebb probléma
nélkül. Ezt a Docker-el úgy oldottam meg, hogy Centos és Ubuntu disztribúciójú
környezeteket, és PHP, Python, Java, illetve Bash szkripteket használtam.

A szolgáltatásokhoz tartozó Docker konténerek:
* Adatbázis: Az alapja egy 'mysql' nevezetű konténer, ami tartalmaz egy
  lightweight Ubuntu-t és benne telepítve egy mysql szervert. Ezt a konténert
  egy inicializáló szkripttel egészítettem ki, ami elkészítette az alap
  adatbázist.
* Terhelés elosztó: A terhelés elosztást HAProxy-val oldottam meg, amit egy
  Ubuntu konténerre alapoztam. Létezik egy olyan Docker konténer, ami
  kifejezetten HAProxy mikro szolgáltatásnak van nevezve, azonban ez a konténer
  nehezen használható, és a szolgáltatás újraindítása is el lett rontva benne,
  így egyszerűbbnek láttam egy saját megvalósítást használni.
* Webkiszolgáló: A weboldal kiszolgálását egy 'httpd' nevű lightweight konténer
  szolgálja ki amiben egy apache webkiszlgáló van. Ezt kiegészítettem PHP-val,
  és néhány szkripttel, ami kiszolgálja a kéréseket.
* Authentikáció: Egyszerű Ubuntu konténer, ami fel van szerelve Python-nal, és
  a MySQLdb Python könyvtárral. Ezen felül tartalmaz egy REST-es kiszolgálót,
  amin keresztül elérhető a szolgáltatás.
* Vásárlás: Centos konténer alapú környezet, amiben Java lett telepítve, és egy
  webes REST API-n keresztül érhetjük el a szolgáltatását.

Kapcsolatok építése Consul-al:
-----------------------------

A Consul alkalmazást korábbi félév folyamán használtam már, teljesítmény mérések
futtatására, így megpróbáltam átültetni a logikát a jelenlegi mikro
szolgáltatásokat biztosító architektúrába.
A gondot az okozta, hogy a Consul alkalmazásnak szükséges egy fix pont, és ehhez
találnom kellett egy olyan elemet, ami mindenképpen elsőnek indul el.
Ez az elem lett a proxy szerver, ami összefogja az elemeket. A korábbi félévben
használt kód megfelelő volt számomra, mivel nagyon hasonló minta alkalmazást
használtam a teljesítmény mérésekhez is.

Ez a megoldás nem elég elosztott a mikro szolgáltatások tekintetében, azonban
egy elág hatékony, és könnyen implementálható megoldás. A mikro szolgáltatásokra
épülő architektúréban jellemzően van egy Service Registry elem, ami lehetővé
teszi a szolgáltatások nyílvántartását, és ez biztosíthatja a kapcsolatot is.
A Consul ebben a kialakításban pontosan így is működött, viszont található olyan
eszköz amit kifejezetten a szolgáltatásokhoz találtak ki. Ez lenne például az
Apache Zookeeper.

Kapcsolatok építése Docker-el:
-----------------------------

Ahogy korábban már említettem lehetőség van a Docker legújabb verzióiban megadni
,hogy ez egyes konténerek milyen néven és milyen hálózaton keresztül érhető el
a többi konténer. A név beállításához a docker run parancs --hostname
paraméterét használhatjuk, míg a hálózat definiálásához előbb létre kell hozni
egy új Docker hálózatot
  docker network create bookstore
amire a konténerek tudnak csatlakozni a --net kulcsszóval. Ennek segítségével
elértem, hogy nagyon egyszerűen és egy eszköz felhasználásával képesek legyenek
látni egymást a szolgáltatások, viszont egy nagy hátulütője van a megoldásnak,
mégpedig az, hogy egy gépen kell futnia az összes alkalmazásnak. Mivel ez egy
mikro szolgáltatásokra épülő architektúránál közel sem ideális, így ez csupán
fejlesztési, és reprezentatív jelleggel használható. (Mivel a labor célja, hogy
bemutassam az architektúra működését, ezért ez megfelel számomra)

Kapcsolatok építése Zookeeper-el:
---------------------------------

TODO: Kipróbálni a Zookepert

Automatizálás:
--------------

A mikro szolgáltatások architektúrájában a következő feladatokat lehet
automatizálni:
1. Teszt alkalmazás build-elése: Gyakran van szükség a szolgáltatást futtató
...fájlok és egyéb tartalmak fordítására (C, Java, bináris kép fájlok frodítása)
..., és ezeket a forrásokat könnyedén elkészíthetjük automatizáltan is, mielőtt
...a környezetet összeépítenénk.
2. Teszt architektúra telepítése: Az egyes szolgáltatásokat egy felügyelt
...környezetbe helyezve valamilyen környezeti konfigurációval együtt
...telepíthetjük (esetünkben Docker konténerekbe csomagolhatjuk), és az így
...kialakuló architektúrát használhatjuk fel a céljaunkra. (Esetünkben
...kialakítunk egy könyvesboltot)
3. Teszt architektúra konfigurálása: Van, hogy telepítés után nem elég magára
...hagyni a rendszert, és használni a szolgáltatásokat, de szükséges különböző
...beállításokat végrehajtani, hogy a megfelelő módon működjön az alkalmazás.
...Ilyen feladat lehet a szolgáltatásokhoz tartozó registry frissítése, vagy
...a futtató gépeken a rendelkezésre állás javítása, és egyéb biztonsági
...mechanizmusok alkalmazása. (Esetemben a Zookeeper felkonfigurálása lesz
...a feladat.)
4. Teszt architektúra tesztelése: Az éles futó architektúrán futtathatunk
...teszteket, amikkel megbizonyosodhatunk, hogy a rendszer megfelelően működik,
...és minden rendben van, átadható a megrendelőnek, vagy átengedhető a
...felhasználóknak. Ilyen teszt lehet az alkalmazás elemeinek a unit tesztelése,
...szolgáltatásonként funkció tesztek futtatása, a szolgáltatások kapcsolaihoz
...integrációs és rendszer tesztek futtatása, illetve a skálázás és egyéb
...teljesítményt befojásoló tényezőkhöz teljesítmény tesztek futtatása.
...(Esetemben unit teszteket fogok futtatni)

Jenkins Job-ok fejelesztése:
----------------------------



Egyéb minta alkalmazások:
------------------------

KanBan board minta:

https://github.com/eventuate-examples/es-kanban-board

Archivematica minta:

https://www.archivematica.org/en/
