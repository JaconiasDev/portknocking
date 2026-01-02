#!/bin/bash

# - ************************************************************
# - Port Knocking Script
# - Autor: NOOB_x64
# - Descrição: Script para demonstrar técnica de Port Knocking
# - Licença: MIT License
# - Ano: 2026
# - ************************************************************

# - PORTKNOCKING SCRIPT
# - ESSE SCRIPT IRA SIMULAR A TECNICA DE PORTKNOCKING ONDE VAMOS MANDAR O PADRAO DE PORTAS A UM DETERMINADO HOST 
# - COM UM TEMPO DEFINIDO ENTRE CADA "BATIDA" - E DEPOIS DISSO SE CONECTAR A PORTA QUE ABRIU NESSE HOST E DEPOIS ENCERRAR A CONEXAO 

# - CONFIGURACOES :
# - IP = PASSADO POR ARGUMENTO 
# - SEQUENCIA DE PORTAS PRA ATIVAR = (13 , 37 , 30000, 3000)
# - SEQEUNCIA DE PORTA PRA DESATIVAR = (2424 2525)
# - LISTEN_PORTS = 1337
# - TIME = 1 
# - 
# - 
# - SEMPRE USAR SUDO ANTES DE EXECUTAR O HPIN3 

sudo -v # PRIVILEGIOS AO EXECUTAR COMANDOS 

# - CORES 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' #  sem cor


banner_portknocking () { 
    echo -e "${RED}"
    cat << 'EOF'                                               
                                                        
                ##                                ##      
            ####                                ####    
            ####                                    ##    
            ####            ##########              ####  
            ########################################    
                ####################################      
                ################################        
                    ##########################          
                ##################################      
            ########################################    
                ################################        
                    ############################          
                ######    ############    ####          
                    ####      ######        ####          
                    ############################          
                    ########################            
                        ####################              
                        ################                
                        ################                
                        ################                
                            ############                  
                                ##    
        ╔═══════════════════════════════════════════════════════╗
        ║----------- ENVIANDO SEQUENCIA DE PORTAS --------------║
        ╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo
}

# pega todos os args antes de SEREM alterados na linha que possui um shift 
total_args=("$@")  # colocar $total_args toda vez que chamar a funcao verifiy_execution_args  | cria um array com todos os agrs 
contador=0
MODO_SLEEP=false

verifiy_execution_args () {

    for args in "${@}"; do 
        case "$args" in 
        --sweep)  
            echo
            echo -ne "${GREEN}[+] - VOCE QUER FAZER UM PING SWEEP NA SUA REDE PRA DESCOBRIR MAIS HOSTS ATIVOS PRA ESSE TEST ? (S/N) ${NC}"
            read responde_
            echo

            if [[ "$responde_" =~ ^[sS]$ ]]; then 

                 _pingSweep "$IP"
            fi 
        ;;
        --sleep)   
            MODO_SLEEP=true 
        ;;
        esac
    done

}



# funcao recebe as portas seja as portas padrao ou portas definidas pelo "user" pelo arguemnto

port_knoking_activer () {
    # se tiver o arg --sleep ele ja nao segue mais esse fluxo , ele para o --sleep onde ta,bem chamos p listen_port
    verifiy_execution_args "${total_args[@]}"

    # modo padrao 

    local seq_ports=("$@")

    if [ "$MODO_SLEEP" == true  ]; 
       then 
            for port in "${seq_ports[@]}";  do 
                echo -e "${GREEN}[+] - $contador  ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN] ▶ ${NC} ${RED}BATENDO NA PORTA ${BLUE}[$port]${NC}${RED} DO IP ${NC} ${BLUE}[$IP]${NC}${NC}"
                hping3 --syn -p "$port" -c 1 "$IP" >/dev/null 2>&1; # pede apenas uma vez 
                sleep $time_ports # espera 1 segundos 
                ((contador+=1))
            done  #pra portsknockin , daemon que esperam uma sequencia muito muito proxima de batidas essa forma pode gerar atrasos portanto use a forma 2 onde envia os pacotes instantaneamente 
            echo 
            listen_port_socket
            exit 1 
    else 
            sudo hping3 --syn -c 1 -p "${seq_ports[0]}" "$IP" > /dev/null 2>&1;
            sudo hping3 --syn -c 1 -p "${seq_ports[1]}" "$IP" > /dev/null 2>&1; 
            sudo hping3 --syn -c 1 -p "${seq_ports[2]}" "$IP" > /dev/null 2>&1; 
            sudo hping3 --syn -c 1 -p "${seq_ports[3]}" "$IP" > /dev/null 2>&1;
            sleep 0.5
            # efeito visual 
            echo 
            echo -e "${YELLOW}[!] - SEQUENCIA ENVIADA INSTANTANEAMENTE!${NC}"
            echo
            echo -e "${GREEN}[+] -  ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN] ▶ ${NC} ${RED}BATEU NA PORTA  ${BLUE}["${seq_ports[0]}"]${NC}${RED} DO IP ${NC} ${BLUE}[$IP]${NC}${NC}"
            sleep 0.5
            echo -e "${GREEN}[+] -  ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN] ▶ ${NC} ${RED}BATEU NA PORTA  ${BLUE}["${seq_ports[1]}"]${NC}${RED} DO IP ${NC} ${BLUE}[$IP]${NC}${NC}"
            sleep 0.5
            echo -e "${GREEN}[+] -  ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN] ▶ ${NC} ${RED}BATEU NA PORTA  ${BLUE}["${seq_ports[2]}"]${NC}${RED} DO IP ${NC} ${BLUE}[$IP]${NC}${NC}"
            sleep 0.5
            echo -e "${GREEN}[+] -  ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN] ▶ ${NC} ${RED}BATEU NA PORTA  ${BLUE}["${seq_ports[3]}"]${NC}${RED} DO IP ${NC} ${BLUE}[$IP]${NC}${NC}"
            echo
            listen_port_socket # chama a funcao que verifica se a porta abriu no servidor / host 
            echo 
            exit 1
    fi

}

# funcao pra desaativar o malware 

desable_portknocking () {

    local ports_desable=("$@") # (2424 2525)

        for port_d in "${ports_desable[@]}"; do 
           sudo hping3 --syn -p $port_d -c 1 $IP > /dev/null 2>&1
        done

        echo -e "${GREEN}[+] - ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN] ▶ ${NC} ${RED}BATENDO NA PORTA ${BLUE}[${ports_desable[0]}]${NC}${RED} DO IP ${NC} ${BLUE}[$IP]${NC}${NC}"
        sleep 1 
        echo -e "${GREEN}[+] - ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN] ▶ ${NC} ${RED}BATENDO NA PORTA ${BLUE}[${ports_desable[1]}]${NC}${RED} DO IP ${NC} ${BLUE}[$IP]${NC}${NC}\n"
        
        echo -e "${GREEN}[*] - VERIFICANDO SE O SOCKET [$IP:$listen_port] foi fechado...${NC}\n"
        sleep 1 

        # pode usar o curl tambem :  curl --connect-timeout 2 "http://IP:PORT" - se retonar a pag html ele ta ativo se nao a porta  estar desativa (ex: 1337) 

        if sudo hping3 -S -p "$listen_port" -c 1 "$IP" 2>/dev/null | grep -q "flags=SA"; # -q grep = --quiet / --silent  / silencioso sem exibir saida 
         then 
            echo -e "${YELLOW}[-] [$IP:$listen_port] = PORTA PERMANECE ESCULTANDO  ${NC}"
            echo 
            exit 0
        else
            echo -e "${GREEN}[-] - [$IP:$listen_port] = A PORTA FOI FECHADA COM SUCESSO  ✔ ${NC}"
            echo
            exit 1
        fi

}


# funcao que verifica o se a porta abriu no servidor e se ta escultando (socket)
listen_port_socket () {

        echo 
        echo -e "${RED}        ╔═══════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}        ║   VERIFICANDO SOCKET: ${GREEN}[$IP:$listen_port]${NC}            ${RED}║${NC}"
        echo -e "${RED}        ╚═══════════════════════════════════════════════════════╝${NC}"
        echo
        ((contador+=1))
        echo -e "${YELLOW}[+] - $contador  ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN] ▶ ${NC} ${RED}CONECTANDO AO SOCKET : [$IP:$listen_port] ${NC}"
        echo
        sleep 1
  if sudo hping3 -S -p "$listen_port" -c 1 "$IP" 2>/dev/null | grep -q "flags=SA"; 
     then 
        ((contador+=1))
        echo -e "${YELLOW}[+] - $contador  ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[SYN/ACK] ▶ ${NC} ${RED}SOCKET : [$IP:$listen_port] SYNCRONIZADO ✔ ${NC}"
        sleep 1 
        ((contador+=1))
        echo -e "${YELLOW}[+] - $contador  ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[ACK] ▶ ${NC} ${RED}SOCKET : [$IP:$listen_port] ESCULTANDO ✔ ${NC}"
        echo 
        wget -T 1 -t 1 http://"$IP":"$listen_port" -O page_m.html > /dev/null 2>&1
        echo -e "${GREEN}[!] - ${RED}PAGINA HTML DO MALWARE SALVA EM : page_m.html  ✔ ${NC}"
        echo 

        echo -ne "${GREEN}[!] - ${RED}DESEJA PARAR O MALWARE ? (S/N) :  ${NC}\n"
        read responde2

        if [[ "$responde2" =~ ^[sS]$ ]]; then 
            desable_portknocking "${port_sequence_desative[@]}"
        else
            exit 1
        fi


  else 
        echo -e "${YELLOW}[-] -    ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}  [SYN]   ▶ ${NC} ${RED}SOCKET : ${BLUE}[$IP:$listen_port]${NC} ${RED}A PORTA PERMANCE FECHADA / PORTA NAO RESPONDEU${NC}"
        echo -e "${YELLOW}[-] -    ["$(date +'%H:%M:%S')"]${NC} - ${BLUE}[RST/ACK] ▶ ${NC} ${RED}SOCKET : ${BLUE}[$IP:$listen_port]${NC} ${RED}CONEXAO FECHADA POIS A PORTA $listen_port ESTAR FECHADA ${NC}"
        echo 
        echo -e "${YELLOW}[-] -    ["$(date +'%H:%M:%S')"]${NC} - ${RED}VERIFIQUE SE SEU FIREWALL NAO ESTAR DROPANDO SEUS PACOTES / BLOQUEANDO ICMP E TENTE NOVAMENTE  ${NC}"
  fi
       echo
       exit 1 
}


# FUNCAO QUE CHAMA O CODIGO AUXILIAR PRA FAZER O PING SWEEP NA REDE 
_pingSweep () {

  Rede=$(echo $1 | sed 's/\./ /3' | cut -d " " -f 1 )

  source ./ping_sweep_.sh $Rede


}

IP=$1 
shift
ports=("$@") # pra validacao

# portas padrao do script 
port_sequence_active=( 13 37 30000 3000 )
port_sequence_desative=(2424 2525)
listen_port=1337
time_ports=1



if [ "$IP" == "--help" ]; 
    then
        echo
        echo -e "${YELLOW} - help ${NC}"
        echo -e "${YELLOW} - usage: ativar_port_knocking  [options] ${NC}"
        echo -e "${YELLOW} - OPÇÕES DE PORT KNOCKING:${NC}"
        echo -e " ${GREEN} - (Padrão) Executa o port knocking de forma instantânea  no seu Host ${NC}"
        echo -e "${YELLOW} --sweep = <REDE>  ativa o modo de ping sweep onde o script irar fazer uma tentativa de descoberta de mais hosts ativo do seu range IP da sua rede Interna \n e voce pode alterar esse valor -sw | sweep diretamente no script na chamada da funcao (port_knoking_activer) passando --sweep ou -sw pra o arguemento da funcao  ${NC}"
        echo -e "${YELLOW} --sleep = <TIME>  ativa o modo de espera de X segundos ou X milesegundos entre cada Batida do portknocking  ${NC}"
        echo
        exit 1
fi



if [ -z  "$IP"  ] || [[  !  $IP  =~ ^[0-9.]+$ ]]; # [[]] pois estamos usando exprecoes regulares na condicao \ verifica se o IP e valido 
    then 
        echo 
        echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║   script de autoria de N00b_X64    ║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
        echo -e "${YELLOW}[+] - Modo de Uso : $0  192.168.10.10  10 100 1000 10000${NC}"
        echo -e "${YELLOW}[+] - Modo de Uso: <IP> <SEQUENCE PORT(opcional)>${NC}"
        echo -e "${YELLOW}[+] - Modo de Uso: $0 --help ${NC}"
        echo 
        exit 1        
fi 


if [ ${#ports[@]} -eq 0 ];
    then 
        echo 
        echo 
        echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║   script de autoria de N00b_X64    ║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
        echo -e "${YELLOW}[+] - Voce passou o Endereco IP ($IP) mas nao passou a sequencia de portas  ${NC}"
        echo
        echo -ne "${YELLOW}[+] - Executar sequencia de portas Padrao ? [S/N] : ${NC}" 
        read responde
        echo 
        if [ "$responde" == "S" ] || [ "$responde" == "s" ];
            then 
                echo -ne "${YELLOW}[+] - Continuando com portas Padrao ${NC}"
                sleep 2
                clear
                banner_portknocking 
                port_knoking_activer "${port_sequence_active[@]}"
                exit 
        elif [ "$responde" == "N" ] ||  [ "$responde" == "n" ];
            then 
                exit 1
        fi
        echo 
fi

# - chama o banner
banner_portknocking  
port_knoking_activer "${ports[@]}" # fncao de knocking com portas personalizadas do user 
