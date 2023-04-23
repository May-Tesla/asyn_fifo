
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

module sync_w2r #(
    ADDR_WIDTH = 4, // 16 depth
    DATA_WIDTH = 32
)(
    input  wire rclk,
    input  wire rrst_n,
    input  wire [ADDR_WIDTH:0] wptr,
    output reg  [ADDR_WIDTH:0] rq2_wptr
);

    reg  [ADDR_WIDTH:0] rq1_wptr;

    always @(posedge rclk or negedge rrst_n) begin
        if(rrst_n) {rq2_wptr, rq1_wptr} <= {(2*ADDR_WIDTH){1'b0}};
        else {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
    end

endmodule //sync_w2r