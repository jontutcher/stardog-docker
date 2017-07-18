# Docker-Stardog

This runs [Stardog 5 CE](http://www.stardog.com) in Docker. 

## To Build

1. Download Stardog & license key, place in new `resources` directory
2. Re-package Stardog .zip file as a .tar.gz file.
3. `docker build --tag stardog:latest .`

## To Run

Note: If you get java segfault errors on run, try giving Docker more RAM. 

1. `docker run -d -p 5820:5820 -p 80:80 --name stardog_db stardog:latest`