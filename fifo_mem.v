
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mei Xuexiao
// 
// Create Date: 2023/04/19 15:17:02
// Design Name: 
// Module Name: asyn_fifo
// Project Name: asyn_fifo
// Target Devices: Zynq-7 ZC706
// Tool Versions: Vivado 2021.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 10ps

module fifo_mem #(
    ADDR_WIDTH = 4, // 16 depth
    DATA_WIDTH = 32
)(
    input  wire wclk,
    input  wire wrst_n,
    input  wire wclken,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [DATA_WIDTH-1:0] wdata,

    input  wire rclk,
    input  wire rrst_n,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output wire [DATA_WIDTH-1:0] rdata
);

endmodule //fifo_mem