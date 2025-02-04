# BGP


# P1


### GNS3

#### Documentation 
- https://docs.gns3.com/docs/

#### What is GNS3 ?
Graphical Network Simulator is used to configure, test and troubleshoot virtual and real networks. GNS3 allows you to run a small topology consisting of only a few devices on your laptop, to those that have many devices hosted on multiple servers or even hosted in the cloud. It is used for certifications like CCNA and CCNP.

### Free Range Routing

#### Documentation 
- https://frrouting.org/

#### What is FRR ?
A software that implements differents network routing protocols. These protocols allow the routers do forwards informations. Use the kernel's routing stack for packet forwarding 

### BGP - Border Gateway Protocol

BGP is a huge topic because it is a protocol for a specific topology of a network. So to learn what it is used for and how it works, we firstly need to understand the fundamentals:
- What is routing inside a network ? 
- What are the routing protocols ?
- What is sepecific to BGP ?

#### Documentation
Chapters (FR) - Ip Routing
https://racine.gatoux.com/lmdr/index.php/sommaire-routage-ip/


#### What is a routing protocol ?
- https://en.wikipedia.org/wiki/Routing_protocol 


#### What is BGP ? How it works ?

#### What is IGP, EGP and AS ?

#### What is OSPF ?

#### What is ISIS ?

#### What are their differences ?


## Types of Protocols
- Vector Distance:
    
    
- Links state:
    need a lot of informations to pick a route and a router

</br>









---


# P2

Before jumping into concepts of bridges and vxlan some  basics knowledge in networking on linux are required.


### Network Interfaces 

#### Doc
- https://www.baeldung.com/linux/network-interface-physical-virtual

#### What are network interfaces ?
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

### LAN - Local Area Network

#### Doc
- https://www.cloudflare.com/fr-fr/learning/network-layer/what-is-a-lan/

### Informations
A network that defines devices on the same network, limited by the same physical (ex: geographic) zone. 

WAN -> Wide Area Network - multiple buidlings (or multpiple LAN)
MAN -> Metropolitan Area Network - Cities 


## Bridge (Network Interface)
 
#### Doc
- https://www.lemagit.fr/definition/Pont-reseau
- https://fr.wikipedia.org/wiki/Pont_(r%C3%A9seau)
- https://phoenixnap.fr/glossaire/ponts-LAN
- https://www.youtube.com/watch?v=yj0hXuUjPMo

### What is a bridge ?
- Behavior of a virtual switch or a virtual ethernet comutator 
- It is used for interconnecting 2 LANs on the same protocol (ex: ethernet)
- In practice a bridge connects 2 or more interfaces between them, capture the traffic and map each MAC addresses to each interfaces.
See the exercice below

### Simple exercice 

We will create a simple exercice to understand how a bridge interface works.
```
TOPOLOGY
         -----------------
         |     router    |
         -----------------
               |eth0|
               |eth1|
               |br0 |
             -----|------               
        eth0 |          | eth1
             |          |
        eth0 |          | eth1
        ----------      ----------
        | host-1 |      | host-2 |
        ----------      ----------
        30.1.1.1/24     30.1.1.2/24
```
In this topology we have a router with 2 interfaces at the start eth0 and eth1. On a router, by default, each interfaces is a the distinct network. 

#### How to connect the hosts ?

So a way to connect our hosts is to use a bridge. It will works as a virtual switch between eth0 and eth1 and know where to forward the traffic between our interfaces.

#### Walkthrough
- Assign IP address on each hosts on the same network (30.1.1.x)
- We want to share and extend the communication between the hosts but each hosts are on different networks 
- To resolve this, we use a bridge and link the interfaces connected with the hosts </br>
```
ip link add br0 type bridge
ip link set eth0 master br0
ip link set eth1 master br0
```
- To finalise the configuration our hosts need an ip address which they will communicate with
- Then we assign an ip addr at the bridge (br0) on the same network as hosts (30.1.1.x)</br>
```
ip addr add 30.1.1.254/24 dev br0
```
- And Voila ! Hosts can ping each other 

#### Ok ok cool ... But How ?

Well in this exemple our router is useless haha. We are only using the ethernet connection and functionnalities. Let's show the differents steps with a ping (host1 -> host2).

#### 1. Gateway and network search
host-1 see that the address to ping is on the same network that her so it's directly accessible by sending an ARP request over the address of the network (30.1.1.0)
#### 2. host-1 ARP 
host-1 send and ARP request on broadcast (ff:ff:ff:ff:ff:ff) over the network (30.1.1.0)
#### 3. Bridge forward 
The bridge interface receive the ARP request and forwrad it to all of the associated interfaces.
#### 4. host-2 ARP
host-2 recieve the ARP request send by the router (bridge) see that her ip address match and then send back her MAC address to the bridge
#### 5. Bridge forward
The bridge receive the response of the arp request (host-2). Check the MAC table and forward the traffic to host-1.
#### 6. Update ARP table
host-1 receive the response and update his ARP table (IP <-> MAC)

>Note ! `arp` - command display the ARP table of a machine
>Note ! `ip neigh show` - command show the associations IP <-> MAC

---



### VLAN - Virtual Local Area Network

#### Doc
- https://fr.wikipedia.org/wiki/R%C3%A9seau_local_virtuel
- https://datascientest.com/vlan-tout-savoir
- https://fr.wikipedia.org/wiki/IEEE_802.1Q

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
- https://www.youtube.com/watch?v=QPqVtguOz4w&list=PLUlQYvNTl7iZI0AqGywDAQ-typ-tpB4JV
- https://fr.wikipedia.org/wiki/IEEE_802.1Q

### Informations
- Another encapsulation method
- When the frame pass by a switch the frame encapsule a tag id with the eth header and the payload
</br>
| eth header | TAG (id vlan) | payload | FCA |



</br>

- https://vincent.bernat.ch/en/blog/2017-vxlan-linux

### Create a VXLAN on eth1 

ip  link add vxlan10 type vxlan10 id 10 dev eth1 remote x.x.x.x dtsport 4789 - 
A vxlan is created on the eth1 interface with a vtep defined to 



### VXLAN - Virtualized eXtensible Local Area Network

#### Doc
- https://www.youtube.com/watch?v=QPqVtguOz4w
- https://www.youtube.com/watch?v=YNqKDI_bnPM&list=PLDQaRcbiSnqFe6pyaSy-Hwj8XRFPgZ5h8
- https://forum.huawei.com/enterprise/intl/fr/thread/Que-sont-les-VTEP-et-les-VNI-dans-VXLAN/667502537563062272?blogId=667502537563062272
- https://www.youtube.com/watch?v=M4GpBecb59o

The main purpose of a VXLAN is to segment the network exactly like VLAN 

- Encapsulation	
    Directement sur Ethernet	
    UDP sur IP (sur Ethernet)
- Nombre d’IDs	
    4096 VLANs max (12 bits)	
    ~16 millions de VXLANs (24 bits)
- Transport	
    Fonctionne sur un LAN	
    Peut traverser un WAN/IP
- Niveau	
    Couche 2 (Ethernet)	
    Couche 2 sur Couche 3 (Ethernet sur UDP/IP)
- Cas d’usage	
    Segmentation locale dans un switch ou routeur Virtualisation et Datacenters (overlay)

- VXLAN frame format encapsule the original layer 2 frame </br>
```
-------------------------
| VXLAN | Layer 2 Frame |
-------------------------
```
- Upstream switch attaches a VXLAN header to the original frame. This header contains values ~16M compared to the 4096 of vlan
- This new frame is encapsuled in a udp package (GRE ?)
    GRE (Generic Routing Encapsulation) is a tunnel traffic encapsulation (IP to IP L3) (vpn ...)
    

#### Underlay / Overlay

- Underlay: Physical network (layer 3)
- Overlay: Virtual VXLAN (L2 on L3 - Ethernet on UDP/IP)



</br>

```
Quand utiliser VXLAN, VLAN ou GRE ?
- VLAN  -> Segmentation réseau sur un switch local
- VXLAN -> Transporter du niveau 2 sur IP pour la virtualisation (VMs, conteneurs)
- GRE   -> Interconnecter deux réseaux distants en tunnel IP
```

### Create a VXLAN  

https://www.fibermall.com/fr/blog/vxlan.htm# - Comprendre VXLAN : Explication du réseau local extensible virtuel


ip add 

### STP - Spanning tree protocol

#### Doc
- https://www.youtube.com/watch?v=6MW5P6Ci7lw
- https://www.youtube.com/watch?v=japdEY1UKe4

Prevent from broacast loops and broadcast storm 





## P3 - BGP configuration on GNS3

- https://www.youtube.com/watch?v=XcCID1ebkjs


### EVPN x VXLAN 

#### Doc
- 


### VPC - Virutal Private Cloud


## Usefuls Commands
```
arp - display the ARP table 

ip neigh show           - display table association of IP <-> MAC
ip -d link show IFACE   - show caracteristics of an interface IFACE
ip route add default via x.x.x.x dev iface - create a default route x.x.x.x and via the interface dev iface
```
