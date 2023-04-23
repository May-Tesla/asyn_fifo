
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

module asyn_fifo_tb ();

    parameter DATA_WIDTH = 32;

    reg  wclk, wrst_n;
    reg  winc;
    wire full;
    reg  [DATA_WIDTH-1:0] wdata;

    reg  rclk, rrst_n;
    reg  rinc;
    wire empty;
    wire [DATA_WIDTH-1:0] rdata;

    asyn_fifo u_asyn_fifo(
        .wclk           ( wclk           ),
        .wrst_n         ( wrst_n         ),
        .winc           ( winc           ),
        .wfull          ( full           ),
        .wdata          ( wdata          ),

        .rclk           ( rclk           ),
        .rrst_n         ( rrst_n         ),
        .rinc           ( rinc           ),
        .rempty         ( empty          ),
        .rdata          ( rdata          )
    );

    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) wdata <= 0;
        else wdata <= wdata + (winc && ~full);
    end

    initial begin
        wclk = 1'b0;
        wrst_n = 1'b1;
        winc = 1'b0;
        rclk = 1'b0;
        rrst_n = 1'b1;
        rinc = 1'b0;
        #10;    // rst enable
        wrst_n = 1'b0;
        rrst_n = 1'b0;
        #20;    // rst disable
        wrst_n = 1'b1;
        rrst_n = 1'b1;
        #20;
        winc = 1'b1;
        rinc = 1'b1;

        while (~full) #20;  // Test write full condition
        #100 winc = 1'b0;
        while (~empty) #20;  // Test read empty condition
        #100 rinc = 1'b0;
        $finish;
    end

    always #5 wclk <= ~wclk;    // 100MHz

    always #10 rclk <= ~rclk;   // 50MHz

endmodule //asyn_fifo