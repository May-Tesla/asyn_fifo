
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
    output reg  rempty,

    input  wire [ADDR_WIDTH:0] rq2_wptr, // 1 bit more than addr
    output reg  [ADDR_WIDTH:0] rptr,    // Gray code
    output wire [ADDR_WIDTH-1:0] raddr  // Bin code
);

    wire rempty_temp;
    reg  [ADDR_WIDTH:0] rbin;
    wire [ADDR_WIDTH:0] rbin_next;
    wire [ADDR_WIDTH:0] rgray_next;

    assign rbin_next  =   rbin + (rinc & ~rempty);       // Address incremented when enabled and not satisfied
    assign rgray_next =  (rbin_next>>1) ^ rbin_next;    // Binary code to Gray code

    always @(posedge rclk or negedge rrst_n) begin
       if (!rrst_n) {rbin, rptr} <= 0;
       else         {rbin, rptr} <= {rbin_next, rgray_next};
    end

    assign raddr = rbin[ADDR_WIDTH-1:0];    // The lower n bits of n+1 bit binary code can be directly addressed

    // Generation of full queue information, comparison logic: MSB and 2nd MSB are opposite, and the remaining bits are equal
    assign rempty_temp = (rgray_next == {~rq2_wptr[ADDR_WIDTH:ADDR_WIDTH-1],
                                          rq2_wptr[ADDR_WIDTH-2:0]});

    always @(posedge rclk or negedge rrst_n)
       if (!rrst_n) rempty <= 1'b0;
       else         rempty <= rempty_temp;

endmodule //rd_ctrl