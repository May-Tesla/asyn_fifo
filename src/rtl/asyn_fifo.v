
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
// Revision: 1.0 - work correctly
// 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 10ps
`define XILINX

module asyn_fifo #(
    ADDR_WIDTH = 4, // 16 depth
    DATA_WIDTH = 32
)(
    `ifdef XILINX
        input  wire clk_in1_p,
        input  wire clk_in1_n,
        input  wire clk_in2_p,
        input  wire clk_in2_n,
        input  wire sys_rst  ,
    `else
        input  wire wclk,
        input  wire wrst_n,
        input  wire rclk,
        input  wire rrst_n,
        input  wire [DATA_WIDTH-1:0] wdata,
        output wire [DATA_WIDTH-1:0] rdata,
    `endif
    input  wire winc,
    output wire wfull,

    input  wire rinc,
    output wire rempty
);

    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;
    wire [ADDR_WIDTH:0] wq2_rptr, rptr;
    wire [ADDR_WIDTH:0] rq2_wptr, wptr;

    `ifdef XILINX
        wire wclk, wrst_n;
        wire rclk, rrst_n;
        reg  [DATA_WIDTH-1:0] wdata;
        wire [DATA_WIDTH-1:0] rdata;
        always @(posedge wclk or negedge wrst_n) begin
            if(!wrst_n) wdata <= 0;
            else wdata <= wdata + (winc && ~wfull);
        end
    `endif

    wr_ctrl#(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    ) u_wr_ctrl (
        .wclk           ( wclk           ),
        .wrst_n         ( wrst_n         ),
        .winc           ( winc           ),
        .wfull          ( wfull          ),
        .wq2_rptr       ( wq2_rptr       ),
        .wptr           ( wptr           ),
        .waddr          ( waddr          )
    );

    sync_r2w#(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    ) u_sync_r2w (
        .wclk           ( wclk           ),
        .wrst_n         ( wrst_n         ),
        .rptr           ( rptr           ),
        .wq2_rptr       ( wq2_rptr       )
    );

    rd_ctrl#(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    ) u_rd_ctrl (
        .rclk           ( rclk           ),
        .rrst_n         ( rrst_n         ),
        .rinc           ( rinc           ),
        .rempty         ( rempty         ),
        .rq2_wptr       ( rq2_wptr       ),
        .rptr           ( rptr           ),
        .raddr          ( raddr          )
    );

    sync_w2r#(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    ) u_sync_w2r (
        .rclk           ( rclk           ),
        .rrst_n         ( rrst_n         ),
        .wptr           ( wptr           ),
        .rq2_wptr       ( rq2_wptr       )
    );

    fifo_mem#(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    ) u_fifo_mem (
        .wclk           ( wclk           ),
        .winc           ( winc           ),
        .wfull          ( wfull          ),
        .waddr          ( waddr          ),
        .wdata          ( wdata          ),
        // .rclk           ( rclk           ),
        .raddr          ( raddr          ),
        .rdata          ( rdata          )
    );

    `ifdef XILINX
        clk_wiz_0 u0_clk_wiz (
            // Clock out ports
            .clk_out1  ( wclk    ),  // output clk_out1, 100M
            // Status and control signals
            .reset     ( sys_rst ),  // input reset
            .locked    ( wrst_n  ),  // output locked
            // Clock in ports
            .clk_in1_p ( clk_in1_p ),  // input clk_in1_p
            .clk_in1_n ( clk_in1_n )   // input clk_in1_n
        );

        clk_wiz_1 u1_clk_wiz (
            // Clock out ports
            .clk_out1  ( rclk    ),  // output clk_out1, 50M
            // Status and control signals
            .reset     ( sys_rst ),  // input reset
            .locked    ( rrst_n  ),  // output locked
            // Clock in ports
            .clk_in1_p ( clk_in2_p ),  // input clk_in1_p
            .clk_in1_n ( clk_in2_n )   // input clk_in1_n
        );

        ila_0 w_monitor (
            .clk    ( wclk  ), // input wire clk
            .probe0 ( winc  ), // input wire probe0
            .probe1 ( wfull ), // input wire probe1
            .probe2 ( waddr ), // input wire [ 3:0]  probe2
            .probe3 ( wdata )  // input wire [31:0]  probe3
        );
        
        ila_0 r_monitor (
            .clk    ( rclk   ), // input wire clk
            .probe0 ( rinc   ), // input wire probe0
            .probe1 ( rempty ), // input wire probe1
            .probe2 ( raddr  ), // input wire [ 3:0]  probe2
            .probe3 ( rdata  )  // input wire [31:0]  probe3
        );
    `endif
endmodule //asyn_fifo