
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

module sync_r2w #(
    ADDR_WIDTH = 4, // 16 depth
    DATA_WIDTH = 32
)(
    input  wire wclk,
    input  wire wrst_n,
    input  wire [ADDR_WIDTH:0] rptr,
    output wire [ADDR_WIDTH:0] wq2_rptr
);

endmodule //sync_r2w