`timescale 1ns/1ps

module i2c_fifo (
  input logic clk,
  input logic rst,
  input logic [14:0] din,
  input logic wr_en,
  input logic rd_en,
  output logic [14:0] dout,
  output logic full,
  output logic empty
);

  // Parâmetros
  parameter WIDTH = 15;
  parameter DEPTH = 15;

  // Registradores
  logic [WIDTH-1:0] buffer [0:DEPTH-1];
  logic [WIDTH-1:0] read_data;
  logic [WIDTH-1:0] write_data;

  // Ponteiros
  logic [DEPTH-1:0] write_ptr;
  logic [DEPTH-1:0] read_ptr;

  // Sinais de controle
  logic is_full;
  logic is_empty;

  // Lógica de escrita
  always_ff @(posedge clk or posedge rst)
  begin
    if (rst)
      write_ptr <= '0;
    else if (wr_en && !is_full)
      write_ptr <= write_ptr + 1;
  end

  always_comb
  begin
    write_data = din;
    is_full = (write_ptr == (DEPTH-1));
  end

  // Lógica de leitura
  always_ff @(posedge clk or posedge rst)
  begin
    if (rst)
      read_ptr <= '0;
    else if (rd_en && !is_empty)
      read_ptr <= read_ptr + 1;
  end

  always_comb
  begin
    read_data = buffer[read_ptr];
    is_empty = (read_ptr == write_ptr);
  end

  // Atribuição de dados de leitura
  assign dout = read_data;

  // Sinais de status
  assign full = is_full;
  assign empty = is_empty;

  // Lógica de escrita no buffer
  always_ff @(posedge clk or posedge rst)
  begin
    if (rst)
      buffer <= '{WIDTH{1'bz}};
    else if (wr_en && !is_full)
      buffer[write_ptr] <= write_data;
  end

endmodule
