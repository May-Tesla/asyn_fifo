
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
    input  wire [ADDR_WIDTH:0] rptr,    // Gray code
    output reg  [ADDR_WIDTH:0] wq2_rptr
);

    reg  [ADDR_WIDTH:0] wq1_rptr;

    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) {wq2_rptr, wq1_rptr} <= {(2*ADDR_WIDTH){1'b0}};
        else {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
    end

endmodule //sync_r2w