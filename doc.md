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
A software that implements differents network routing protocols. These protocols allow the routers to forwards informations. Use the kernel's functionalities like the kernel routing stack for packet forwarding.

#### Documentation
Chapters (FR) - Ip Routing
- (French) https://racine.gatoux.com/lmdr/index.php/sommaire-routage-ip/

#### What is a routing protocol ?
- https://en.wikipedia.org/wiki/Routing_protocol 

#### What is BGP ? How it works ?
Border Gateway Protocol is a extern routing protocol (EGP) used to exchanges routes between Autonomous systems (AS).

#### What is IGP, EGP and AS ?
(French) https://racine.gatoux.com/lmdr/index.php/igp-egp-et-as/ 

- **Interior Gateway Protocol**
</br>
Used to exchange routing table information between gateways (routers) **inside** an AS. </br>
IGPs are divided in 2 categories:
    - **Distance-vector routing protocols** </br>
    Measures the distance by the numbers of routers a packet has to pass; one rounter count as one hop. Each nodes exchange its routing table with his neighbors. Exemple RIP

    - **Link-state routing protocols** </br>
    Every nodes constructs a map of the connectivity to the network in the form of a graph, showing how nodes are connected to each others. Then independently calculates the next best logical path from it to every possible destination in the network.</br>
    Routers exchange betwen them a lot of informations about their connectivity (delay, reachable, ...)


- **Exterior Gateway Protocol**
</br>
Used to exchange routing table information between gateways (routers) **between** ASs.
The most used protocol. BGP is the mainly Exterior Gateway Protocol.

- **Autonomous System**
</br>
A collection of connected IP networks, physical networks and routers considered and managed by a single entity. It's possible to enter and leave the AS by border routers. Each AS have an ASN (Autonomous System Number).

#### What is Open Shortest Path First (OSPF) ?
https://en.wikipedia.org/wiki/Open_Shortest_Path_First </br>
https://www.youtube.com/watch?v=kfvJ8QVJscc </br>
OSPF is an Interior Gateway Protocol. It uses a link state routing. 

#### What is Intermediate System to Intermediat System (ISIS) ?
https://en.wikipedia.org/wiki/IS-IS </br>
IS-IS is a Interior Gateway Protocol. It uses a link state routing. 

#### What are their differences ?
https://www.youtube.com/watch?v=K4prZSnOUTQ&t=211s

---


# P2

Before jumping into concepts of bridges and vxlan some basics knowledge in linux networking are required.


### Network Interfaces 

#### Documentation
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

#### Documnetation
- https://www.cloudflare.com/fr-fr/learning/network-layer/what-is-a-lan/

### Informations
A network that defines devices on the same network, limited by the same physical zone (ex: geographic). 

WAN -> Wide Area Network - multiple buidlings (or multpiple LAN)
MAN -> Metropolitan Area Network - Cities 


## Bridge (Network Interface)
 
#### Documentation
- https://www.lemagit.fr/definition/Pont-reseau
- https://fr.wikipedia.org/wiki/Pont_(r%C3%A9seau)
- https://phoenixnap.fr/glossaire/ponts-LAN
- https://www.youtube.com/watch?v=yj0hXuUjPMo

### What is a bridge ?
- Behavior of a virtual switch or a virtual ethernet comutator 
- It is used for interconnecting 2 LANs on the same protocol and extends L2 layer (ex: ethernet)
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

### Ok ok cool ... But How ?

Well in this exemple our router is useless haha. We are only using the ethernet connection and functionnalities. Let's show the differents steps with a ping (host1 -> host2).

- **1. Gateway and network search** </br>
host-1 see that the address to ping is on the same network that her so it's directly accessible by sending an ARP request over the address of the network (30.1.1.0)
- **2. host-1 ARP** </brs>
host-1 send and ARP request on broadcast (ff:ff:ff:ff:ff:ff) over the network (30.1.1.0)
- **3. Bridge forward** </br>
The bridge interface receive the ARP request and forwrad it to all of the associated interfaces.
- **4. host-2 ARP** </br>
host-2 recieve the ARP request send by the router (bridge) see that her ip address match and then send back her MAC address to the bridge
- **5. Bridge forward** </br>
The bridge receive the response of the arp request (host-2). Check the MAC table and forward the traffic to host-1.
- **6. Update ARP table** </br>
host-1 receive the response and update his ARP table (IP <-> MAC)

>Note ! `arp` - command display the ARP table of a machine
>Note ! `ip neigh show` - command show the associations IP <-> MAC
>Note ! `brctl showmacs br0` - show MAC mapping in a bridge 

---

### VLAN - Virtual Local Area Network

#### Documentation
- https://en.wikipedia.org/wiki/VLAN
- https://fr.wikipedia.org/wiki/R%C3%A9seau_local_virtuel
- https://datascientest.com/vlan-tout-savoir
- https://fr.wikipedia.org/wiki/IEEE_802.1Q
- https://www.youtube.com/watch?v=jC6MJTh9fRE
- https://www.youtube.com/watch?v=A9lMH0ye1HU
- https://www.youtube.com/watch?v=QPqVtguOz4w&list=PLUlQYvNTl7iZI0AqGywDAQ-typ-tpB4JV
- https://fr.wikipedia.org/wiki/IEEE_802.1Q
- https://www.youtube.com/watch?v=hD0fBfYIoDU

We saw previously what a LAN, MAN and WAN is. Now it's time to understand what is a VLAN and what it is used for.

### What is a VLAN ?
- A way to segment a LAN network into multiples virtual networks (ex: services sales, marketing ...)
- The switchs add a 802.1Q format header of 4 bytes.
- VLAN and subnetworking are 2 differents way to divide a network
- A TAG ID is placed inside the frame and have a max value of 4096 (12 bits reserved)
- Defined in 802.1Q standard
- To connects two hosts with differents vlan we need a router (with a trunk port)

### What it is used for ?
- minimize the brodcast load traffic on a network
- better way to manage groups of hosts (sales, marketing etc...)
- security, a host can only its traffic and not all the traffic of the network

```
802.1Q Tag Format
| 16 bytes - Tag protocol identifier (TPID)   |        16 bytes - Tag Control Identifier (TCI)          |
                                              |  3 bits - PCP  | 1 bit - DEI | 12 bits - VLAN Identifier|
```
- **Tag Protocol Identifier** -  </br>
Value of 0x8100 wich identify the frame from untagged frames for the switches
- **Priority Code Point** -  maps the frame to priority level
- **Drop eligible Indicator** - indicate eligibility to drop the frame
- **VLAN identifier** - id used to identify the vlan, values 0 - 4095  



## VXLAN - Virtual eXtensible Local Aran Network

#### Documentation
- https://www.youtube.com/watch?v=QPqVtguOz4w
- https://www.youtube.com/watch?v=YNqKDI_bnPM&list=PLDQaRcbiSnqFe6pyaSy-Hwj8XRFPgZ5h8
- https://forum.huawei.com/enterprise/intl/fr/thread/Que-sont-les-VTEP-et-les-VNI-dans-VXLAN/667502537563062272?blogId=667502537563062272
- https://www.youtube.com/watch?v=M4GpBecb59o
- https://vincent.bernat.ch/en/blog/2017-vxlan-linux
- https://datatracker.ietf.org/doc/rfc7348/
- https://support.huawei.com/enterprise/en/doc/EDOC1100277355/4b7cb278/overview-of-vxlan
- https://www.youtube.com/watch?v=7nwlwLJH6yQ

### What is a VXLAN ?

- Overlay encapsulation protocol
- A way to segment the network into multiples virtual networks 
- Switches (VTEP) place a header VXLAN with a VNI of 24 bits (16B values) in the ethernet frame
- Defined in RFC 7348


### What it is used for ?
The VXLAN protocol has beed created to respond to differentes issues. 
- **VLAN limitation** 
By adding more bit for the VN identifier (VNI) its now possible to have ~16B differents VXLANs
- **Cloud Virtualization**  - Cloud's expansion bring new issues like: </br>
The Cross-pod Expansion - Imagine that a company need more ressources (pods) to hanle a huge load. The cloud provider need to expand the company'ressources to other pods. VMs need to be on the same network to communicate so a L2 network is needed. VLAN could be an option but only if we are sure the expansion is on the same pod, the same LAN. </br>
IP addressing - How to differentiate ips of the same politics but for 2 differents companies ? Well layer 2 is the most suitable way to resolve this issue. So we can't just rely only on ip networks etc...
- **STP issues** - Spanning tree protocol block some switch ports to limit broadcast flood

### STP - Spanning tree protocol

#### Documentation
- https://www.youtube.com/watch?v=6MW5P6Ci7lw
- https://www.youtube.com/watch?v=japdEY1UKe4

Prevent from broacast loops and broadcast storm 

> Note ! **Underlay**: Physical network (layer 3)
> **Overlay**: Virtual VXLAN (L2 on L3 - Ethernet on UDP/IP)

</br>

### When use VXLAN or VLAN ?

- VLAN  -> Segment network on the same switches, same LAN
- VXLAN -> Transport l2 frame to IP virtualisation (VMs, containers ...)

### Create a VXLAN  

https://www.fibermall.com/fr/blog/vxlan.htm# - Comprendre VXLAN : Explication du réseau local extensible virtuel

- Single remote end point 
```
ip link add my_vxlan type vxan id X dev ethX ip x.x.x.x remote y.y.y.y dstport 4789
```
- Multicast 
```
ip link add my_vxlan type vxlan id X dev ethX ip x.x.x.x group 224.y.y.y dstport 4789
```
IANA Guidelines for IPv4 Multicast Address Assignments: https://datatracker.ietf.org/doc/html/rfc5771






## P3 - BGP configuration on GNS3

### Documentation
- https://www.youtube.com/watch?v=XcCID1ebkjs
- https://www.youtube.com/watch?v=O6tCoD5c_U0
- https://www.youtube.com/watch?v=1nCflEqdSBk
 
## BGP 

### What is BGP ?
Border Gateway Protocol is a routing technology to transfer packets over networks (AS).
It is an Exterior Gateway Protocol (EGP) and the main protocol to making Internet. It connects companies, ineternet providers (IP) and big networks between them.  
</br>
BGP is by essence a Exterior Gateway Protocol but it can be used inside an AS. 
When 2 routers used BGP inside the same AS, BGP is used in intern (iBGP) and need to be configured differently. eBGP is used to exchange route informations between ASs and iBGP is used to ditributing informations to the router within your the AS.

### How BGP works ? 
In a BGP system, routers establish TCP connexions on port 179 called BGP peers, and exchange informations about AS's paths. BGP uses hiw own metrics to determine the Best Path Selection (BPS) (AS-Path, Next-Hop...).


### What is a Route Reflector System ? 
https://en.wikipedia.org/wiki/Border_Gateway_Protocol#Route_reflectors </br>
https://networklessons.com/bgp/bgp-route-reflector </br>
https://datatracker.ietf.org/doc/html/rfc4456 </br>

iBGP need a special configuration to work correctly, it needs that every iBGP routers be connected in full mesh topology. 
This configuration is hard to maintain and not scalable. (For N router we need to establish n * (n-1) / 2, so for 100 routers -> 4950 sessions) 
The route reflector is a design that resolve this problem.

A Route Reflector is a router in BGP that acts as a central hub. In practice, for redundency multiple RR are configured in an AS and each of them are connected to iBGP routers.

#### Configuration Route Reflector

- https://networklessons.com/bgp/bgp-route-reflector


### What is MPLS ? 

#### Documentation
- https://www.youtube.com/watch?v=BuIWNecUAE8

</br>
MPLS - Multiprotocol Label Switching is a routing technique that use labels rather than network addresses. Instead of read the routing table at each hops, MPLS creates a labels system to improve the traffic and have a better QoS (Quality of service)
It takes place between the layer 2 and the layer 3.

### How MLPS works ?
When a packet pass by the MPLS network, a Label Edge Router (LER) assign to the packet a label.
The next routers (Label Switching Routers - LSR) do not read the addrees anynore but use the label to transfer the packet. At the edge of the MPLS router a LER remove the label letting the packet in his origin form. Routers can have differents names like (CE customer Edge, PE Provider Edge, P Provider)

### How it is related to BGP (relation)? What are the differences ? 
BGP is a routing technology, it calculates the best paths to transfer a packet through differents networks while MPLS improves the transimission of the packets between the routers. Thay can be used independently and act on differents planes (control plane and data plane).



### What is EVPN ? 
https://rickmur.com/evpn-rfc-7432-explained/





### EVPN - VXLAN ? Interactions ? It is separated ?
https://www.youtube.com/watch?v=cdvstTm467k </br>

### What is the Control plane (CP) and the Data plane (DP) ?
https://fr.wikipedia.org/wiki/Plan_de_contr%C3%B4le </br>
https://www.snaplogic.com/blog/data-plane-vs-control-plane-whats-the-difference </br>
https://www.ibm.com/think/topics/control-plane-vs-data-plane </br>

Control plane and Data plane are **concepts** that help engineers, developers and network administrators understand how data travels across a network.

A control plane is a critical part of a computer network that **carries information and controls routing, determining the path data travels between connected devices.** Defines what to do with the ingress packets, where they should go. (ex: OSPF, BGP EVPN). It maintain the routint table. 

The data plane is responsible for the actual **movement of data from one system to another**. It is the workhorse that **delivers data to end users from systems** and vice versa. It checks the routing table to know in wich interface forward traffic. (ex: VXLAN)


### Differences between the Control Plane and the Data plane ?
https://www.cloudflare.com/fr-fr/learning/network-layer/what-is-the-control-plane/ </br>
 


### How OSPF works and the configuration ?
https://networklessons.com/ospf/introduction-to-ospf </br>
https://networklessons.com/ospf/basic-ospf-configuration </br>
https://study-ccna.com/loopback-interface-loopback-address/ </br>
https://www.youtube.com/watch?v=faUd0vcRzI8 </br>

A loopback interface is a virtual interface in our network device that is always up and active after it has been configured.The loopback interface can be considered stable because once you enable it, it will remain up until you issue the shutdown command under its interface configuration mode. It’s very useful when you want a single IP address as a reference that is independent of the status of any physical interfaces in the networking device. You can also configure the loopback address as the Router ID for routing protocols like OSPF and BGP.




### VPC - Virutal Private Cloud ??


## Usefuls Commands
```
arp - display the ARP table 

ip neigh show           - display table association of IP <-> MAC
ip -d link show IFACE   - show caracteristics of an interface IFACE
ip route add default via x.x.x.x dev iface - create a default route x.x.x.x and via the interface dev iface
```
