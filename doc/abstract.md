Kivonat {.unnumbered}
=======

Napjainkban komoly gondot okoz, hogy hogyan lehet hatékonyan elosztott, jó rendelkezésre állású, könnyen skálázható alkalmazást építeni. Sok architektúrális megközelítés van, amit alapul véve hatékonyan tervezhetjük meg a rendszerünket, és könnyen elkészíthetjük az alkalmazásunkat. Egy ilyen architektúrális megközelítés a mikroszolgáltatásokon alapuló architektúra, amivel apró részletekre bontva a feladatot, könnyen kezünkben tarthatjuk az elosztott alkalmazásunkat.

A mikroszolgáltatásokra épülő architekrúra (microservices), egy olyan architektúrális fejlesztési módszertan, ami a programot alkotóelemeire szedi, és minden funkcionalitást teljesen különálló egységként kezel. Egy ilyen alkalmazás fejlesztése közben oda kell figyelni az összes szolgáltatással való együttműködésre, a visszamenőleges kompatibilitásra, és meg kell tartani az alkotóelemek kapcsolatának a konzisztenciáját. Ennek a fenntartása egy nehéz feladat, amit kézileg szinte lehetetlen hosszú távon fenntartani.

A diplomamunka keretében az volt a feladatom, hogy megismerjem az architektúra lényegét és működését, illetve kiderítsem, hogy milyen eszközökkel tudom automatizálás segítségével támogatni a fejlesztés, és működtetés folyamatát.

A diplomamunka célkitűzése, hogy egy olyan mikroszolgáltatásokra épülő alkalmazást készítsek, amellyel be tudom mutatni az architektúra előnyeit, végig tudom vezetni rajta a tesztelés folyamatát, tudom automatizálni a tesztelését, és működtetését, és betekintést tudok adni az architektúrához használatos technológiákba.

Abstract {.unnumbered}
========

Nowadays it's a very big problem, that how to build a distributed, highly available, easily scalable application efficiently. There are many ways to design our system, which tells how  we can implement our application efficiently. One of these design patterns is the microservice based architecture, which creates small services from the big application, by separating the functionality, and we can handle more efficiently our distributed application.

Microservice architecture is a software development methodology, which separates the parts of the application to the smallest functionality, which could be run from a separated environment. It is important to take care about the cooperation between the services, the backward compatibility and the consistency of the service connectivity through the development flow. It is hard to keep these attributes, and almost impossible to keep it on long term by manual verification.

In this thesis I gathered knowledge about the architecture, how it works, how it could be designed, or which continuous integration tool could be used for helping development and maintenance.

The goal of this thesis is to create and example application based on microservice architecture, which could be used for showing the advantages of the technique, and I can show the full process of testing and design. My goal also to create a framework for helping the development of the application by automated testing and integration.
