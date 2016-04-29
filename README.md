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

Egyéb minta alkalmazások:
------------------------

KanBan board minta:

https://github.com/eventuate-examples/es-kanban-board

Archivematica minta:

https://www.archivematica.org/en/
