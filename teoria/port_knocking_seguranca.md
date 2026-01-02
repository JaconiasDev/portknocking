# - Port Knocking / Bater na porta

# Simulação da Técnica de segurança Port Knocking
# Como funciona?  
# Essa técnica se chama (Port Knocking)

# Essa técnica é usada pra quê? Vejamos:
# - Essa técnica é usada para segurança da rede e serviços em servidores ou um host.
# - Essa técnica permite que eu deixe os meus serviços como (SSH / FTP / SMTP) todos desativados / todas as portas desativadas.

# - Mas aí você deve se perguntar: e como um servidor poderia ter esses tipos de serviços desativados, já que o servidor serve para servir esses serviços? E essa é uma boa pergunta, e é aí que vem a sacada dessa técnica, já que, como falei, ela permite que eu deixe essas portas fechadas, porém podendo serem abertas assim que necessário!

# - A técnica de Port Knocking é uma boa técnica de esconder os nossos serviços porque, de fato, ela não mostra esses serviços ativos na rede, até porque eles não estão! O que já evita muitos **PORT SCANS** vendo essas portas abertas, o que incrementa a segurança por obscuridade.

# - Como essa técnica é usada para ativar as portas sem acessar o servidor diretamente?

# - É simples. Essa técnica é usada da seguinte maneira, por exemplo:
# - Imagine que eu, como ADM da rede, quero acessar o SSH do meu servidor (59.45.145.85) – se eu tentar me conectar de cara no serviço SSH, eu não vou conseguir acessá-lo, já que essa porta 22 ela não está aberta no servidor!
# - Isso porque estamos usando essa técnica de (PORT KNOCKING).
# - Pra eu acessar esse serviço no meu servidor, eu preciso "bater" ou, como o nome da técnica diz ("bater na porta").
# - Ou seja, temos que bater em uma sequência específica de portas do meu servidor para que o meu serviço de SSH seja ativado e eu consiga me comunicar e acessar esse serviço!

# - Funciona assim...

# - Basicamente, essa técnica funciona assim! Eu preciso, antes de acessar um serviço, bater em uma sequência específica de portas, como por exemplo: pra eu ativar a porta SSH no meu servidor, antes meu host (eu) precisa bater nas portas 13, 37, 30000, 3000. Com isso, é identificado que houve tráfego SYN / houve batida de portas nessa sequência específica, então o SSH é ativado!

# - Simulação de como isso é feito:

# - [00300] - [192.168.100.10:10982] => [SYN] => [59.45.145.85:13] 
# - [00400] - [192.168.100.10:10880] => [SYN] => [59.45.145.85:37] 
# - [00500] - [192.168.100.10:10379] => [SYN] => [59.45.145.85:30000] 
# - [00900] - [192.168.100.10:56887] => [SYN] => [59.45.145.85:3000] 

# -> Como podemos ver, nosso host Client envia pacotes de Sincronização [SYN] para o nosso servidor [59.45.145.85] na porta [13]... 
# -> 13
# -> 37
# -> 30000
# -> 3000

# - Porém, como vemos, só mandamos os pacotes de SYN; não houve ali o **3-way-handshake** como esperado, o que já nos diz que isso é uma técnica de PORT KNOCKING.
# - E outra coisa que devemos sempre ver é o campo de **TIME**, porque ele indica também que estamos usando essa técnica, já que para a porta no servidor ser aberta, essa sequência ela deve estar dentro de um curto período de tempo (às vezes até milissegundos), como nesse exemplo que dei. A diferença entre a primeira batida de porta {syn - port=13} e a segunda batida de porta {syn - port=37} é de 100 milissegundos (isso é um exemplo; num cenário real, esse time poderia ser maior ou menor).
# - Esse tipo de observação de linha do tempo de quando a porta foi "batida" é muito importante. Por quê?
# - É simplesmente porque o nosso **(knockd)**, que é o (DAEMON = "(serviço em segundo plano) que escuta o tráfego da interface de rede em um nível baixo (link-layer), o que permite que ele 'veja' tentativas de conexão mesmo em portas que o firewall mantém fechadas").
# - O daemon fica escutando em segundo plano na rede do servidor pra ver se, durante um pequeno espaço de tempo, foi detectada alguma batida nessa sequência de portas. Lembrando que:

# - TEMPO IMPORTA  
# - SEQUÊNCIA DE PORTAS IMPORTA  

# - Isso é importante entender porque o nosso daemon ele vai ver tudo que possa ali na minha interface de rede do servidor, e pra ele ver que eu quero abrir uma porta, eu tenho que passar a sequência correta, pois se tiver atrasos, ele pode tratar isso como ruídos na rede. Assim, se eu passar a sequência... também se meu daemon está definido que as portas de sequência são: [13 - 37 - 30000 - 3000], se eu fizer desse jeito [3000 - 30000 - 37 - 13] não vai funcionar porque está ao contrário.
# - Essa técnica precisa que você passe a sequência correta e num período de tempo, porque não adianta eu passar a sequência correta, por exemplo: [13 - 37 - 30000 - 3000], porém ter uma diferença de **TIMES** de 3s ou 4s entre essas batidas. Por exemplo:

# - [00300] - [192.168.100.10:10982] => [SYN] => [59.45.145.85:13] 
# - [00700] - [192.168.100.10:10880] => [SYN] => [59.45.145.85:37] 
# - [02000] - [192.168.100.10:10379] => [SYN] => [59.45.145.85:30000] 
# - [60900] - [192.168.100.10:56887] => [SYN] => [59.45.145.85:3000] 

# - Como podemos ver, existe uma diferença muito grande de **TIMES** entre essas portas_DST que meu host está tentando acessar no servidor | mandando a sequência de pacotes [SYN].
# - Em casos como esses, a porta do serviço SSH no servidor continua inativa! Pois o daemon precisa dessas portas dentro de um curto espaço de tempo!

# - **************************************************************************************************************************
# - IMPORTANTE  
# - DAEMON = serviço em segundo plano, que nesse exemplo é o knockd (ouvindo toda a rede)! 

# - knockd = serviço que fica escutando/monitorando a interface de rede para identificar padrões que, no nosso exemplo, são padrão de portas.
# - **************************************************************************************************************************

# - PONTOS IMPORTANTES DESSA TÉCNICA:
# - Sequência de portas: a sequência importa. Ex: (13, 37, 30000, 3000) é diferente de (3000, 30000, 37, 13).
# - A ordem dos fatores altera o produto (a porta só abre se a ordem for a exata).
# - O DAEMON trabalha em nível baixo (link-layer); com isso, não importa se a porta está aberta ou fechada no firewall.
# - A linha de tempo desses eventos importa! – Não adianta a sequência ser (13, 37, 30000, 3000), mas a diferença do tempo entre eles ser muito grande!