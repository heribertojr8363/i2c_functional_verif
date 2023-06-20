Este passo do fluxo consiste na simulação Gate Level do IP em desenvolvimento.

OBS: Antes de executar este passo o usuário deve editar a variável "block" do makefile para
gerar os logs corretamente.

OBS: Nos arquivos setup e dofile (na pasta scripts), substitua os caracteres "xxx" pelo nome do seu IP. 
No arquivo setup, deve-se descomentar a variável DFT (#-define DFT) para o caso de netlist com as 
estruturas de DFT.

OBS: Estes scripts estão considerando o PDK 180nm da XFAB.

Para executar, faça no terminal:

> make 

Para fazer a simulação Gate Level.

> make debug

Para verificar o resultado através do arquivo de log ... (gatesim_IPname.log)

> make waves

Para carregar a forma de onda da simulação.

> make clean 

Para apagar os logs e demais arquivos gerados.

OBS: Esta etapa só pode ser realizada, posteriormente, a execução da síntese lógica.





