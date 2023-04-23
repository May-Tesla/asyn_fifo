
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

module asyn_fifo #(
    ADDR_WIDTH = 4, // 16 depth
    DATA_WIDTH = 32
)(
    input  wire wclk,
    input  wire wrst_n,
    input  wire winc,
    output wire wfull,
    input  wire [DATA_WIDTH-1:0] wdata,

    input  wire rclk,
    input  wire rrst_n,
    input  wire rinc,
    output wire rempty,
    output wire [DATA_WIDTH-1:0] rdata
);

    wr_ctrl#(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    )u_wr_ctrl(
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
    )u_sync_r2w(
        .wclk           ( wclk           ),
        .wrst_n         ( wrst_n         ),
        .rptr           ( rptr           ),
        .wq2_rptr       ( wq2_rptr       )
    );

    rd_ctrl#(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    )u_rd_ctrl(
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
    )u_sync_w2r(
        .rclk           ( rclk           ),
        .rrst_n         ( rrst_n         ),
        .wptr           ( wptr           ),
        .rq2_wptr       ( rq2_wptr       )
    );

    fifo_mem#(
        .ADDR_WIDTH( ADDR_WIDTH ),
        .DATA_WIDTH( DATA_WIDTH )
    )u_fifo_mem(
        .wclk           ( wclk           ),
        .winc           ( winc           ),
        .wfull          ( wfull          ),
        .waddr          ( waddr          ),
        .wdata          ( wdata          ),
        // .rclk           ( rclk           ),
        .raddr          ( raddr          ),
        .rdata          ( rdata          )
    );



endmodule //asyn_fifo