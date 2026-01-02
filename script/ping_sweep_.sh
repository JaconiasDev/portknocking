
# PING SWEEP -


# - ************************************************************
# - Port ping sweep Script
# - Autor: NOOB_x64
# - Licença: MIT License
# - Ano: 2026
# - ************************************************************

# - VAMOS  FAZER UM PING SWEEP NA REDE DA VPN PRA IDENTIFICAR HOSTS ATIVOS DENTRO DO RANGE DE IP DA REDE

# - CORES 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' #  sem cor

rm IPs_ATIVOS.txt > /dev/null 2>&1

if [ "$1" == "" ]; then 
    echo 
    echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   script de autoria de N00b_X64    ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Modo de Uso : $0 <REDE>${NC}"
    echo -e "${YELLOW}Modo de Uso: <IP>${NC}"
    echo 
    exit 1        
fi 

    echo
    echo -e "${RED}        ╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}        ║          INICIANDO PORT SCAN NA REDE $1         ║${NC}"
    echo -e "${RED}        ╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""

for host in $(seq 1 254); do 

    if ping -c 1 -w 1 $1.$host | grep -E "ttl=64|ttl=128" > /dev/null 2>&1; then 
        echo
        echo -e "${GREEN}[+]${NC}${YELLOW} - IP = $1.$host  [ATIVO]${NC}"
        echo 
        echo
        echo "$1.$host" >> IPs_ATIVOS.txt
    else 
        echo -e "${RED}[!] - $1.$host =>  SEM RESPOSTA [INATIVO] ${NC}"
    fi
        sleep 0.5s 
        echo -ne "\e[1A\r\033[K" # apaga (\r) move cursor pra o inincio da linha | \o33[k - limpa toda a linha | n - impede que o cusor pule para proxima linha | \e[1A sobre uma linha do cusor

done

echo
echo -e "${RED}        ╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}        ║   -------------- HOSTS ATIVOS NA REDE --------------- ║${NC}"
echo -e "${RED}        ╚═══════════════════════════════════════════════════════╝${NC}"
echo

if [ -s IPs_ATIVOS.txt ] ; then 
    for host_ativos in $(cat IPs_ATIVOS.txt); do
        echo -e "${GREEN}[+]${NC}${YELLOW} - IP = $1.$host_ativos  [ativo] ${NC}"
        echo
    done
else 
    echo -e "${RED}[!] - NENHUM HOST ENCONTRADO | NENHUM HOST ATIVO ${NC}"
    echo 
fi 
