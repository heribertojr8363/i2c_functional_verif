Este passo do fluxo consiste na simulação RTL do IP em desenvolvimento.

OBS: Antes de executar este passo o usuário deve editar a variável "block" do makefile para
gerar os logs corretamente.

OBS: Nos arquivos setup e dofile (na pasta scripts), substitua os caracteres "xxx" pelo nome do seu IP.

Para executar, faça no terminal:

> make 

Para fazer a simulação RTL.

> make debug

Para verificar o resultado através do arquivo de log ... (rtlsim_IPname.log)

> make coverage 

Para carregar a ferramenta de cobertura de código (ICCR)

Na janela que vai abrir, clique em File->Open Test->cov_work->scope->test_IPname

Então a ferramenta exibirá várias informações sobre a cobertura código do design.

OBS: Isso ajuda na depuração e na melhoria do testbench desenvolvido pelo designer.

> make waves

Para carregar a forma de onda da simulação.

> make clean 

Para apagar os logs e demais arquivos gerados.





