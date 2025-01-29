# BGP

## Documentation 

Chapters (fr) - Ip Routing
https://racine.gatoux.com/lmdr/index.php/sommaire-routage-ip/



## Free Range Routing 

A software that implements differents network routing protocols. These protocols allow the routers do forwards informations.

Use the kernel's routing stack for packet forwarding 

# Border Gateway Protocol

Concepts:
- Autonomous system 
- IGP / EGP



## IGP


## EGP

</br>

## Types of Protocols
- Vector Distance:
    
    
- Links state:
    need a lot of informations to pick a route and a router

</br>

## LAN - Local Area Network

#### Doc
https://www.cloudflare.com/fr-fr/learning/network-layer/what-is-a-lan/

### Informations
A network that defines devices on the same network, limited by the same physical (ex: geographic) zone. 

WAN -> Wide Area Network - multiple buidlings (or multpiple LAN)
MAN -> Metropolitan Area Network - Cities 

</br>

## VLAN - Virtual Local Area Network

#### Doc
https://fr.wikipedia.org/wiki/R%C3%A9seau_local_virtuel
https://datascientest.com/vlan-tout-savoir
https://fr.wikipedia.org/wiki/IEEE_802.1Q

### Informations
- A way to divide a LAN Network into multiples networks VLAN (ex: marketing services and sales services)
- The division is made by a software (virtual)
- VLAN and subnetworking are 2 differents way to divide a network
- A TAG ID is placed inside the frame and have a max value of 4096 
| header | TAG ID | rest of the frame |
- Comutators delivers the packet only if the frame only if the tag id correponds to the good port, linit the bandwidth


</br>

## VXLAN - Virtual eXtensible Local Aran Network

#### Doc
https://www.youtube.com/watch?v=QPqVtguOz4w&list=PLUlQYvNTl7iZI0AqGywDAQ-typ-tpB4JV
https://fr.wikipedia.org/wiki/IEEE_802.1Q

### Informations
- Another encapsulation method
- When the frame pass by a switch the frame encapsule a tag id with the eth header and the payload
</br>
| eth header | TAG (id vlan) | payload | FCA |



</br>

## Bridge (Network Interface)
 
#### Doc
https://www.lemagit.fr/definition/Pont-reseau
https://fr.wikipedia.org/wiki/Pont_(r%C3%A9seau)
https://phoenixnap.fr/glossaire/ponts-LAN
https://www.youtube.com/watch?v=yj0hXuUjPMo

### Informations
- Behavior of a virtual switch or a virtual ethernet comutator 
- It is used for interconnecting 2 LANs on the same protocol (ex: ethernet)

- Repeater + Functionality to read MAC address
- Layer 2 device
- 2 ports device 
- types:
    Transparent Bridges:
        - Stations are unaware of the bridge's existence
        - Reconfiguration of the is not needed even of the     bridge is added or removed from network
    Source Routing Bridges:
        - Pass by a specific station
    Local (Virtual/physic)
    Bridge NAT (layer 2 + 3)
    Bridge VLAN-aware

### Questions

```
Sachant qu'un pont reseau (bridge) opere sur la couche 2 (ethernet), comment peut il savoir vers quel interface rediriger le traffic ? Les addresses MAC sont determines par la carte reseau ?

Excellente question ! Un pont réseau (ou bridge) opère effectivement à la couche 2 (Ethernet) et utilise les adresses MAC pour savoir où rediriger le trafic. Voici comment cela fonctionne en détail :
1. Adresses MAC et leur rôle :

    Une adresse MAC (Media Access Control) est une adresse unique attribuée à une carte réseau (NIC). Elle est généralement définie au niveau matériel par le fabricant de la carte réseau.
    Les adresses MAC sont utilisées dans les trames Ethernet pour identifier les expéditeurs et les destinataires au sein d’un réseau local (LAN).

2. Fonctionnement d'un bridge pour rediriger le trafic :

Un pont réseau agit comme un commutateur Ethernet (switch), en créant et maintenant une table de commutation ou table MAC. Cette table est utilisée pour acheminer les trames en fonction de leur adresse MAC de destination.
Étapes principales :

    Apprentissage des adresses MAC :
        Lorsqu'une trame arrive sur l'une des interfaces connectées au bridge, ce dernier inspecte l'adresse MAC source contenue dans la trame.
        Il associe cette adresse MAC source à l'interface d'entrée dans sa table MAC. Cela signifie que, désormais, le bridge sait que cette adresse MAC est accessible via cette interface.

    Exemple :
        Une trame arrive sur l'interface eth0 avec une adresse MAC source AA:BB:CC:DD:EE:FF.
        Le bridge ajoute dans sa table : AA:BB:CC:DD:EE:FF -> eth0.

    Décision de redirection (ou forwarding) :
        Le bridge regarde l'adresse MAC de destination de la trame et consulte sa table MAC :
            Si l'adresse MAC de destination est connue dans la table, la trame est redirigée vers l'interface correspondante.
            Si l'adresse MAC de destination n'est pas dans la table, le bridge diffuse la trame (envoie une copie sur toutes les interfaces sauf celle d'entrée) pour s'assurer qu'elle atteint son destinataire.

    Exemple :
        Si une trame avec l'adresse MAC de destination 11:22:33:44:55:66 arrive, et que la table MAC indique 11:22:33:44:55:66 -> eth1, la trame sera envoyée uniquement sur eth1.

    Expiration des entrées de la table MAC :
        Les entrées de la table MAC ne sont pas permanentes. Si aucune trame n'est reçue d'une adresse MAC pendant une certaine période, cette entrée est supprimée. Cela permet de gérer dynamiquement les changements dans le réseau.

3. Exemple pratique :

Supposons que vous avez un bridge avec deux interfaces :

    eth0 connectée à un ordinateur A.
    eth1 connectée à un ordinateur B.

Scénario 1 : Première communication

    Ordinateur A (MAC AA:AA:AA:AA:AA:AA) envoie une trame à ordinateur B (MAC BB:BB:BB:BB:BB:BB).
    Le bridge :
        Apprend que AA:AA:AA:AA:AA:AA est sur eth0 et l'ajoute à sa table MAC.
        Ne trouve pas encore BB:BB:BB:BB:BB:BB dans sa table, donc diffuse la trame sur toutes les interfaces sauf eth0.
        Lorsque B répond, le bridge apprend que BB:BB:BB:BB:BB:BB est sur eth1 et l'ajoute à sa table.

Scénario 2 : Communication suivante

    Ordinateur A envoie une autre trame à ordinateur B.
    Cette fois, le bridge a déjà les informations dans sa table MAC :
        AA:AA:AA:AA:AA:AA -> eth0
        BB:BB:BB:BB:BB:BB -> eth1
    Le bridge redirige directement la trame sur eth1, sans diffusion.

4. Limitations des adresses MAC et des bridges :

    Dépendance aux adresses MAC :
        Les bridges ne fonctionnent qu’au niveau Ethernet. Ils ne prennent pas en compte les adresses IP ou d'autres couches.

    Trafic inconnu :
        Lorsqu’un destinataire n’est pas encore connu, le bridge diffuse la trame, ce qui peut augmenter le trafic sur le réseau.

    Boucles réseau :
        Si plusieurs bridges ou switches sont connectés en boucle, cela peut entraîner une tempête de broadcast. Pour résoudre ce problème, des protocoles comme STP (Spanning Tree Protocol) sont utilisés.

    Adresses MAC modifiables :
        Bien que les adresses MAC soient définies matériellement, elles peuvent être modifiées ou clonées via des outils logiciels. Cela peut compliquer la gestion du réseau.
```


### Network Interfaces 

#### Doc
https://www.baeldung.com/linux/network-interface-physical-virtual

- Hardware or Software component that connects a device to a network
- Physical:
    - Hardware Component that connect to a network (automatically ?) 
    - A unique id (interface name) are assigned to it
- Virtual:
    - Software base that emulate behaviors of physical interface
    - Includes VLAN, virtual tunnels, virtual wifi interface, network bridge
- Difference:
    - Main diff is that physical interface have fixed MAC address and speed compared to virtual interface
    - Differents configurations
- Use the `ls -l /sys/class/net/` command to check the type of interfaces
```
lrwxrwxrwx 1 root root 0 Jan 28 10:53 docker0 -> ../../devices/virtual/net/docker0
lrwxrwxrwx 1 root root 0 Jan 28 16:20 enp0s3 -> ../../devices/pci0000:00/0000:00:03.0/net/enp0s3
```

</br>

### Create a bridge between 2 interfaces for examples

1. ip link add name br0 type bridge - create an interface 'br0' of type bridge
2. ip link set dev br0 ip - up the interface (enable)
3. ip link set eth1 master br0
   ip link set eth0 master br0 -> connect eth1 and eth2 to the bridge interface

Reminder: A bridge interface forward the packages that match certain MAC address (layer 2, MAC table etc...)



### Create a VXLAN  




## P3 - BGP configuration on GNS3

https://www.youtube.com/watch?v=XcCID1ebkjs