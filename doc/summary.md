# Értékelés

Megismertem a mikroszolgáltatásokra épülő architektúrák tervezési módját, illetve a fejlesztésével, és karbantartásával kapcsolatos nehézségeket. Elkészítettem egy minta alklamazást, ami képes szimulálni egy könyvesbolt működését, és ezt az alkalmazást mikroszolgáltatásokra építettem. Az alkalmazás fejlesztéséhez és teszteléséhez készítettem egy folytonos integrációt támogató keretrendszert, amivel megmondhatjuk, hogy a változtatások jól működnek-e.

## Tovább fejlesztési javaslatok

A minta alkalmazásban rengeteg lehetőség van a továbbfejlesztés szempontjából. Lehet hozzá fejleszteni további funkciókat, mint a regisztráció, keresés, vagy adminisztrtív funkciók (új könyv bevitele, készlet frissítése, stb.). A jelenlegi funkciókat is lehet tovább fejleszteni jobb autentikációs módszerrel, szebb böngésző felülettel, vagy árral összefűzött vásárlással. Nem csak a lehetőségeket érdemes kibővíteni, hanem a használhatóságot, és a felügyeleti eszközöket, mivel monitorozás, közös log kezelés, és skálázási lehetőségek még nincsenek az alkalmazásba építve. Sok előnnyel járhat, ha valódi teljes hardver és szoftver virtualizációt használunk, mivel a Docker konténerek használat körülményes lehet, és nem is igazán stabil, ha egy gépnek kell több konténert futtatni.

Ami a folytonos integrációt támogató keretrendszert illeti, lehetőség van a pipeline bővítésére, amit egy új funkció implemenntálása maga után vonna, vagy automatikusan indíthatóvá tehető az egész verifikációs folyam egy Jenkins pluginnel, ami a verziókezelővel együttműködve minden új változtatásra elindíthatja a pipeline-t. Új feladatokat is hozzá lehet fejleszteni, amik a kód minőségét javítják, és a céljuk, hogy összeszedett jól dokumentált kód készüljök. Egy ilyen ellenőrzés lehetne a Python fájlok formai kiértékelése, ami lehetséges a pylint programmal.

## Problémák, Kritika

A feladat elkészítése közben több probléma is felmerült, ami könnyen lehet fejlesztés közben blokkoló tényező. A legnagyobb probléma a Docker image-ek készítésénél volt, mivel a Docker álltal készített image-ek gyakran változnak, és a visszafelé kompatilibitás nem teljesül 2 verzió között. A témával kapcsolatban találtam egy cikket[@docker-is-bad], ami kifejti, hogy pontosan hol is vannak a hibák a Docker fejlesztési stratégiában, amit a felhasználók észrevehetnek.

Ezzel szembesültem én is, amikor fejlesztettem az adatbázis szolgáltatást, vagy a megrendelés szolgáltatását. A felhasznált **ubuntu** image mögött a csomagok dinamikusan változnak, és két build folyamat között is előfordul, hogy ugyan azon a néven más-más csomagot telepítünk. Az adatbázis kezelő esetén a MySQL csomag lett újabb, és egy nem várt felhasználónév jelszó párost kért, mivel többé már nem volt telepítés utáni alapértelmezett felhasználó. A probléma ugyan nem volt jelentős, de minden szolgáltatást érintett, és éppen ezért hosszabb időt vett igénybe a javítása. A megrendelés esetén a **centos** alap image változott meg, és nem lehetett egyáltalán szolgáltatást indítani a konténer belsejéből. Sajnálatos módon a megoldás az alap image cseréje volt.

## Hol használható

Az elkészített folytonos integrációt támogató keretrendszer szinte minden mikroszolgáltatás alapú alkalmazás támogatásához felhasználható, mivel a folyamat amit implementál, és a szkriptek, amikkel a build-eket lebonyolítom, és a telepítést végzem, könnyen megváltoztathatók bármely más alkalmazás kiszolgálására. A minta alkalmazás nem lenne képes valós könyvesbolt vásárlásának irányítására, azonban nagyon jó mintául szolgál a fejlesztés bemutatására, mivel tartalmaz komplex szolgáltatásokat, amik önnálóan megtalálják egymást, és elég egyszerű, hogy tetszőlegesen továbbfejleszthető legyen.
