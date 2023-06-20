Este passo do fluxo consiste na execução da síntese lógica do IP em desenvolvimento.

OBS: Antes de executar este passo o usuário deve editar a variável "block" do makefile para
gerar os logs corretamente.

OBS: No arquivo synth.tcl (na pasta scripts), deve-se definir o valor do período de clock para o RTL a ser sintetizado 
através da variável "CLK_PERIOD". Este valor deve ser em ns (nano segundos).

OBS: No arquivo synth.tcl (na pasta scripts), deve-se editar o nome do "clk_i" caso nome do clock empregado no RTL
seja diferente.

OBS: O arquivo synth.tcl supõe que usuário tenha usado o script de simulacão RTL fornecido neste referenceflow, que 
cria o arquivo de atividade do circuito de extensao ".tcf". Se usuário não utilizou este script, ele deve editar o
script synth.tcl, comentando a linha "read_tcf ..." para evitar erros na execucão do script. 

OBS: No arquivo synth.tcl (na pasta scripts), o usuário pode habilitar a inserção das estruturas de SCAN no netlist, 
usando a variável DFT (set DFT 1, para inserir o DFT) (opcional)

OBS: Estes scripts estão considerando o PDK 180nm da XFAB.

Para executar, faça no terminal:

> make 

Para fazer a síntese lógica do RTL.

> make debug

Para verificar o resultado através do arquivo de log ... (synth_IPname.log)

> make clean 

Para apagar os logs e demais arquivos gerados.

OBS: Esta etapa só pode ser realizada, posteriormente, a execução da simulação RTL.





