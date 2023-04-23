
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
    // input  wire wrst_n,
    input  wire winc,
    input  wire wfull,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [DATA_WIDTH-1:0] wdata,

    // input  wire rclk,
    // input  wire rrst_n,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output wire [DATA_WIDTH-1:0] rdata
);

    assign wclken = winc && ~wfull;

    `ifdef XILINX
        blk_mem_gen_0 fifo_mem (
            .clka  ( wclk   ),    // input wire clka
            .wea   ( wclken ),    // input wire [ 0 : 0] wea
            .addra ( waddr  ),    // input wire [ 3 : 0] addra
            .dina  ( wdata  ),    // input wire [32 : 0] dina
            .clkb  ( rclk   ),    // input wire clkb
            .addrb ( raddr  ),    // input wire [ 3 : 0] addrb
            .doutb ( rdata  )     // output wire [32 : 0] doutb
        );
    `else
        reg  [DATA_WIDTH-1:0] fifo_mem [2**ADDR_WIDTH-1:0];
        
        integer i;
        initial begin
            for(i=0; i<2**ADDR_WIDTH; i=i+1)
                fifo_mem[i] <= {DATA_WIDTH{1'b0}};
        end

        always @(posedge wclk ) begin
            if(wclken) fifo_mem[waddr] <= wdata;
        end

        assign rdata = fifo_mem[raddr];
    `endif

endmodule //fifo_mem