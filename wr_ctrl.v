
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

module wr_ctrl #(
    ADDR_WIDTH = 4, // 16 depth
    DATA_WIDTH = 32
)(
    input  wire wclk,
    input  wire wrst_n,
    input  wire winc,
    output reg  wfull,

    input  wire [ADDR_WIDTH:0] wq2_rptr, // 1 bit more than addr
    output reg  [ADDR_WIDTH:0] wptr,
    output wire [ADDR_WIDTH-1:0] waddr
);
    wire wfull_temp;
    reg  [ADDR_WIDTH:0] wbin;
    wire [ADDR_WIDTH:0] wbin_next;
    wire [ADDR_WIDTH:0] wgray_next;

    assign wbin_next  =   wbin + (winc & ~wfull);       // Address incremented when enabled and not satisfied
    assign wgray_next =  (wbin_next>>1) ^ wbin_next;    // Binary code to Gray code

    always @(posedge wclk or negedge wrst_n) begin
       if (!wrst_n) {wbin, wptr} <= 0;
       else         {wbin, wptr} <= {wbin_next, wgray_next};
    end

    assign waddr = wbin[ADDR_WIDTH-1:0];    // The lower n bits of n+1 bit binary code can be directly addressed

    // Generation of full queue information, comparison logic: MSB and 2nd MSB are opposite, and the remaining bits are equal
    assign wfull_temp = (wgray_next == {~wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1],
                                         wq2_rptr[ADDR_WIDTH-2:0]});

    always @(posedge wclk or negedge wrst_n)
       if (!wrst_n) wfull <= 1'b0;
       else         wfull <= wfull_temp;

endmodule //wr_ctrl