
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

module rd_ctrl #(
    ADDR_WIDTH = 4, // 16 depth
    DATA_WIDTH = 32
)(
    input  wire rclk,
    input  wire rrst_n,
    input  wire rinc,
    output wire empty,

    input  wire [ADDR_WIDTH:0] rq2_wptr, // 1 bit more than addr
    output wire [ADDR_WIDTH:0] rptr,
    output wire [ADDR_WIDTH-1:0] raddr
);

endmodule //rd_ctrl