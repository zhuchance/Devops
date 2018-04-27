#!/bin/sh

usage(){
  echo "Usage: $0 FILE_NAME_DOCKER_CE_TAR_GZ"
  echo "       $0 docker-18.03.1-ce.tgz"
  echo "Get docker-ce binary from: https://download.docker.com/linux/static/stable/x86_64/"
  echo "eg: wget https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz"
  echo ""
}
SYSTEMDDIR=/usr/lib/systemd/system
SERVICEFILE=docker.service
DOCKERDIR=/usr/local/bin
DOCKERBIN=docker
SERVICENAME=docker

mkdir -p /etc/docker/

if [ $# -ne 1 ]; then
  usage
  exit 1
else
  FILETARGZ="$1"
fi

if [ ! -f ${FILETARGZ} ]; then
  echo "Docker binary tgz files does not exist, please check it"
  echo "Get docker-ce binary from: https://download.docker.com/linux/static/stable/x86_64/"
  echo "eg: wget https://download.docker.com/linux/static/stable/x86_64/docker-17.09.0-ce.tgz"
  exit 1
fi

echo "##unzip : tar xvpf ${FILETARGZ}"
tar xvpf ${FILETARGZ}
echo

echo "##binary : ${DOCKERBIN} copy to ${DOCKERDIR}"
cp -p ${DOCKERBIN}/* ${DOCKERDIR} >/dev/null 2>&1
which ${DOCKERBIN}

echo "##systemd service: ${SERVICEFILE}"
echo "##docker.service: create docker systemd file"
cat >${SYSTEMDDIR}/${SERVICEFILE} <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
Environment="PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin"
ExecStart=/usr/local/bin/dockerd 
ExecStartPost=/sbin/iptables -I FORWARD -s 0.0.0.0/0 -j ACCEPT
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF


cat >/etc/docker/daemon.json   <<'HERE'

{
  "registry-mirrors": ["https://kuamavit.mirror.aliyuncs.com", "https://registry.docker-cn.com", "https://docker.mirrors.ustc.edu.cn"], 
  "max-concurrent-downloads": 10,
  "log-driver": "json-file",
  "log-level": "warn",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
    }
}

HERE


cat >/etc/docker/key.json    <<'HERE'
{"crv":"P-256","d":"19J17jXt-tHKG5TE4wWiYap0cph6S05k_oELDl42uIk","kid":"IBUD:XIHZ:7N4J:PLVF:7V2T:CKIK:JFBM:U4SH:TIVB:DCS4:JSCG:5HPC","kty":"EC","x":"JuipZ8q29CKnnce0qVzSorTcbeKc96kIN7GEj-pO6ZE","y":"ezTci7edLG7N7Fa7ZFWheADWzK_pTwY2wn9XlzJaFqg"}
HERE



echo ""

systemctl daemon-reload
echo "##Service status: ${SERVICENAME}"
systemctl status ${SERVICENAME}
echo "##Service restart: ${SERVICENAME}"
systemctl restart ${SERVICENAME}
echo "##Service status: ${SERVICENAME}"
systemctl status ${SERVICENAME}

echo "##Service enabled: ${SERVICENAME}"
systemctl enable ${SERVICENAME}

echo "## docker version"
docker version
