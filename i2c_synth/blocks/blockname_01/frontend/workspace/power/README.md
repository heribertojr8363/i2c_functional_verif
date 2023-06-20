Este passo do fluxo consiste na análise de consumo do IP em desenvolvimento.

OBS: Antes de executar este passo o usuário deve editar a variável "block" do makefile para
gerar os logs corretamente.

Para executar, faça no terminal:

> make 

Para fazer a análise de consumo médio.

Para verificar o resultado, vá no path:

IPname/logs/power/pwr_ana_average_IPname.log

> make prof

Para fazer a análise de perfil de consumo.

Para verificar o resultado, vá no path:

IPname/logs/power/pwr_ana_prof_IPname.log

> make clean 

Para apagar os logs e demais arquivos gerados.

OBS: Esta etapa só pode ser realizada, posteriormente, a execução das etapas de síntese lógica e 
simulação gate level.




