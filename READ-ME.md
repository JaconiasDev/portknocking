# SCRIPT DE DEMONSTRACAO DA TECNICA DE PORT KNOCKING 

## Pré-requisitos para execução do script
```
    # Debian/Ubuntu
    apt install hping -y

    # Arch Linux 
    sudo pacman -S hping

    # verificar se estao instalados 
    whereis hping 
```

## Instalação 🚀 
```
    # clone repositorio 
    git clone "https://github.com/JaconiasDev/portknocking.git"

    # acesse a estrutura do script 
    cd /script 

    # Der permisao de execusao para o script 
    chmod +x ativar_port_knocking.sh ping_sweep_.sh

    # execute o escript 
    ./ativar_port_knocking.sh 

    # adicionar ao binarios dos sistema 
    mv ativar_port_knocking.sh /usr/local/bin/portknocking 

    ativar_port_knocking

```

## Modo de Uso
```
    ./ativar_port_knocking.sh  <ip> <ports_sequence>

    ./ativar_port_knocking.sh --help
```

## Funcionalidades 
* Faz o portkncking na rede 
* Pode fazer ping sweep para descobrir mais host ativos em um  range de IP 
* Pode fazer portknocking com timeout (sleep) 
* Desativa portknocking

## aviso
> Esse script é Didatico apenas - Resolucao Desafio ( ***DESEC*** ), Autoria : **Noob_x64**
