Este passo do fluxo consiste na execução do LEC do IP em desenvolvimento.

OBS: Antes de executar este passo o usuário deve editar a variável "block" do makefile para
gerar os logs corretamente.

OBS: Estes scripts estão considerando o PDK 180nm da XFAB.

Para executar, faça no terminal:

> make 

Para fazer a equivalência lógica entre o RTL e o Netlist obtido a partir da síntese (LEC).

> make debug

Para fazer a depuração, usando a interface gráfica.

Na janela que será aberta, clique em Tools->Mapping Manager. Depois na janela do Mapping Manager, vá no último
botão do "CLASS" (Select Compare Class) e desabilite todos as views com opção "Disable All" e depois vá 
no botão "CLASS" novamente e clique na opção "Non-Equivalent".

OBS: Não pode ter pontos de não equivalência.

> make log

Para verificar o resultado através do arquivo de log ... (lec_IPname.log)

> make clean 

Para apagar os logs e demais arquivos gerados.

OBS: Esta etapa só pode ser realizada, posteriormente, a execução da síntese lógica.





