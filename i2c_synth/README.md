# Repositório contente a estrutura de pastas e os templates dos documentos para desenvolvimento de um topo ou de um bloco.

# Para vários blocos, copiar antes a pasta "blockname_01" antes, alterando o nome para o respectivo bloco

design_name                        # Projeto
    |_top                          # Módulo topo
    |   |_backend                  # Backend (Leiaute) do topo
    |   |   |_constraints          # Arquivos .sdc ou .tcl
    |   |   |_logs                 # Logs da ferramenta
    |   |   |_parasitics           # Arquivos .spef
    |   |   |_physical             # Arquivos .def e .gdsii
    |   |   |_postlayout           # Netlist final - Arquivo .v
    |   |   |_reports              # Relatórios da ferramenta
    |   |   |   |_power
    |   |   |   |_signoff
    |   |   |   |_timing
    |   |   |_script               # Scripts de floorplan, P&R, etc.
    |   |   |_structural           # Netlist de entrada - Arquivo .v
    |   |   |_workspace            # Local de onde o programa será rodado
    |   |_dft                      # DFT do topo
    |   |   |_constraints          # Arquivos .sdc
    |   |   |_logs                 # Logs da ferramenta
    |   |   |_patterns             # Arquivos contendo vetores de teste
    |   |   |_reports              # Relatórios da ferramenta
    |   |   |_scripts              # Scripts de DFT
    |   |   |_workspace            # Local de onde o programa será rodado
    |   |_docs                     # Documentos 
    |   |   |_block_guide
    |   |   |_design_guide
    |   |   |_integration_guide
    |   |   |_presentations
    |   |   |_references
    |   |   |_test_guide
    |   |_frontend                 # Design do topo
    |   |   |_constraints          # Arquivos .sdc ou .tcl
    |   |   |_lec                  # Logic Equivalence Checking
    |   |   |_logs                 # Logs da ferramenta
    |   |   |_model                # Modelo(s) do topo (matlab, systemc...)
    |   |   |_parasitics           # Arquivos .spef
    |   |   |_reports              # Relatórios da ferramenta
    |   |   |   |_area
    |   |   |   |_power
    |   |   |   |_timing
    |   |   |_rtl                  # Descrição do bloco e do testbench
    |   |   |   |_src              # Arquivos HDL da integração do top
    |   |   |   |_tb               # testbench para testes basicos da integração do top
    |   |   |_script               # Scripts de síntese, simulação...
    |   |   |_simulation           # Resultados das simulações
    |   |   |   |_gatelevel
    |   |   |   |_rtl
    |   |   |_software             # Referente aos softwares de teste do sistema 
    |   |   |   |_api              # Interface de progamação do hardwares
    |   |   |_structural           # Netlist de saída - Arquivo .v
    |   |   |_workspace            # Local de onde o programa será rodado
    |   |_verification             # Verificação do topo
    |   |   |_docs                 # Documentos
    |   |   |_logs                 # Logs da ferramenta
    |   |   |_reports              # Relatórios da ferramenta
    |   |   |_scripts              # Scripts de verificação
    |   |   |_src                  # Arquivos de alimentação do ambiente
    |   |   |_tb                   # Codigos do ambiente UVM
    |   |   |_workspace            # Local de onde o programa será rodado
    |_blocks                       # Pasta blocos - Integram o topo EX:UART, AXI, AES, VITERBI, ...
    |   |_blockname01              # Mesma logica das pastas do top sendo que referente aos ips
    |   |   |_dft
    |   |   |   |_constraints
    |   |   |   |_logs
    |   |   |   |_patterns
    |   |   |   |_reports
    |   |   |   |_scripts
    |   |   |   |_workspace
    |   |   |_docs
    |   |   |   |_block_guide
    |   |   |   |_design_guide
    |   |   |   |_presentations
    |   |   |   |_references
    |   |   |_frontend
    |   |   |   |_constraints
    |   |   |   |_lec
    |   |   |   |_logs
    |   |   |   |_model
    |   |   |   |_reports
    |   |   |   |   |_area
    |   |   |   |   |_power
    |   |   |   |   |_timing
    |   |   |   |_rtl
    |   |   |   |   |_src
    |   |   |   |   |_tb
    |   |   |   |_script
    |   |   |   |_simulation
    |   |   |   |   |_gatelevel
    |   |   |   |   |_rtl
    |   |   |   |_software
    |   |   |   |   |_api
    |   |   |   |_structural
    |   |   |   |_workspace
    |   |   |_verification
    |   |   |   |_docs
    |   |   |   |_logs
    |   |   |   |_reports
    |   |   |   |_scripts
    |   |   |   |_src
    |   |   |   |_tb
    |   |   |   |_workspace
    |   |_blockname02

