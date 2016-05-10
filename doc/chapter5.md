Minta alkalmazás terve
======================

![Microservices](img/microservices.png)

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

* **Bejelentkezés**: Felhasználó felületen történő authentikálása
* **Böngészés**: Felhasználó láthatja mi van a raktáron
* **Vásárlás**: Felhasználó valamit a saját nevére ír

Ezekből a feladatokból a következő szolgáltatásokat lehet elkészíteni:

* **Felület kiszolgálása**: Egy web kiszolgáló alkalmazása, amin keresztül
  elvégezhetők a különböző műveletek, mint a bejeletkezés, vagy vásárlás.
  Ez a felület magába foglalja a böngészést lehetővé tevő szolgáltatást is.
* **Authentikációs szolgáltatás**: A bejelentkezni szándékozó felhasználó adatait
  ellenőrzi, és hibás bejelentkezés esetén hibát dob.
* **Vásárlási szolgáltatás**: A böngészés közben kiválasztott könyveket lefoglalja
  a raktári készletből.
* **Adatbázis szolgáltatás**: Ez a szolgáltatás tartalmazza a raktár tartalmát, a
  vásárlási naplót, és a bejelentkezési adatokat.
* **Terhelés elosztó szolgáltatás**: Ez a szolgálatatás a skálázhatóságot segíti,
  és egy egységes interfész kialakításában segít.
