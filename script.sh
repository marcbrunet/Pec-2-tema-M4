 #!/bin/bash

function printLines () {
  for pakage in $1; do
    echo $pakage
  done
}
function installedPackages {
  distribution=$(cat /etc/os-release |  awk -F'=' '{if($1=="NAME") print $2 }')
  if [ "$distribution" = "fedora" ]; then
    mkdir /tmp/pakages
    touch /tmp/pakages/installed.txt
    touch /tmp/pakages/available.txt
    dnf list --installed | awk '{print $1 }' > /tmp/pakages/installed.txt
    dnf list --available | awk '{print $1 }' > /tmp/pakages/available.txt
    echo "listado de paquetes en: /tmp/pakages/"
  fi
  if [ "$distribution" = '"Ubuntu"' ]; then
    mkdir /tmp/pakages
    touch /tmp/pakages/installed.txt
    touch /tmp/pakages/available.txt
    apt list --installed | awk -F'/' '{if(NR>1)print $1}'> /tmp/pakages/installed.txt
    apt-cache search . > /tmp/pakages/available.txt
    echo "listado de paquetes en: /tmp/pakages/"
  fi
}
function updatePackages {
  distribution=$(cat /etc/os-release |  awk -F'=' '{if($1=="NAME") print $2 }')
  if [ "$distribution" = "fedora" ]; then
    updateDNF=$(dnf list --updates | awk '{if(NR>2)print $1}')
    printLines "$updateDNF"
  fi
  if [ "$distribution" = '"Ubuntu"' ]; then
    sudo apt update
    apt list --upgradable | awk -F'/' '{print $1}'
  fi
}
function searchPackage {
  echo "entre el nombre del paquete"
  read var1
  distribution=$(cat /etc/os-release |  awk -F'=' '{if($1=="NAME") print $2 }')
  if [ "$distribution" = "fedora" ]; then
    dnf provides $var1
  fi
  if [ "$distribution" = '"Ubuntu"' ]; then
    apt-cache search $var1 | awk '{print $1}'
  fi
}
function packageInfo {
  echo "entre el nombre del paquete"
  read var1
  distribution=$(cat /etc/os-release |  awk -F'=' '{if($1=="NAME") print $2 }')
  if [ "$distribution" = "fedora" ]; then
    dnf info $var1
  fi
  if [ "$distribution" = '"Ubuntu"' ]; then
    dpkg -s $var1
  fi
}
function printPacket {
  #statements
  echo "entre el nombre del paquete"
  read var1
  rpm -ql "$var1"
}


title="script de gestion de paquetes"
prompt="escull una opcio:"
options=("paquetes instalados y no instalados" "paquetes para actualizar" "dado un comando, a que paquete pertenece" "la información de un paquete" "muestre el contenido de un paquete")
echo "$title"

PS3="$prompt "
select opt in "${options[@]}" "Quit"; do
    case "$REPLY" in
    1 ) echo "ha escogido $opt"; installedPackages;;
    2 ) echo "ha escogido $opt"; updatePackages;;
    3 ) echo "ha escogido$opt"; searchPackage;;
    4 ) echo "ha escogido $opt"; packageInfo;;
    5 ) echo "ha escogido $opt"; printPacket;;
    $(( ${#options[@]}+1 )) ) echo "adeu!"; break;;
    *) echo "opcio invalida";continue;;
    esac
done
