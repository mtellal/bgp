#!/bin/bash 

echo -e "\nGenerating router_mtellal" 
docker build . -f Dockerfile_router -t router_mtellal

echo -e "\nGenerating host_mtellal-1"
docker build . -f Dockerfile_host -t host_mtellal-1 
