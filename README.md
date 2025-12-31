On each docker server, simply clone the repo:

```
git clone https://github.com/jarrah31/Show-Running-Containers.git
cd Show-Running-Containers/
./showrunningcontainers.sh
```
The output looks like this:
```
Running Docker Containers:
on IPs:

dsrv3:  beszel-agent      henrygd/beszel-agent:latest    3 weeks ago   Up 13 days
dsrv3:  dawarich_app      freikin/dawarich:latest        3 hours ago   Up 3 hours (healthy)  3000/tcp
dsrv3:  dawarich_db       postgis/postgis:17-3.5-alpine  2 months ago  Up 13 days (healthy)  5432/tcp
dsrv3:  dawarich_redis    redis:7.4-alpine               2 months ago  Up 13 days (healthy)  6379/tcp
dsrv3:  dawarich_sidekiq  freikin/dawarich:latest        3 hours ago   Up 3 hours (healthy)  3000/tcp
dsrv3:  dozzle            amir20/dozzle:latest           2 weeks ago   Up 13 days            7007/tcp
dsrv3:  n8n               docker.n8n.io/n8nio/n8n        2 months ago  Up 13 days            5678/tcp
dsrv3:  termix            ghcr.io/lukegus/termix:latest  6 weeks ago   Up 13 days            30001-30006/tcp,9000/tcp
dsrv3:  watchtower        containrrr/watchtower          2 months ago  Up 13 days (healthy)  [excluded]
```

If you have ssh key-pairs set up between your computer and each server, you can run a script such as this to list all containers at the same time:
```
echo "==================================================="
ssh dsrv2 ./Show-Running-Containers/showrunningcontainers.sh
echo "==================================================="
ssh dsrv3 ./Show-Running-Containers/showrunningcontainers.sh
echo "==================================================="
ssh dsrv4 ./Show-Running-Containers/showrunningcontainers.sh
echo "==================================================="
ssh dsrv5 ./Show-Running-Containers/showrunningcontainers.sh
```
