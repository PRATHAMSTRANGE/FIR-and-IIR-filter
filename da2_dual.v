`timescale 1ns / 1ps

module da2_dual(
    input clk,
    input rst,
    input SCLK,                      // Serial clock input
    input update,                   // Trigger to update output values
    input [1:0] chmode0,            // Channel 0 mode
    input [1:0] chmode1,            // Channel 1 mode
    input [11:0] value0,            // Channel 0 12-bit DAC value
    input [11:0] value1,            // Channel 1 12-bit DAC value
    output [1:0] SDATA,             // Serial data output to DA2
    output reg SYNC,                // SYNC signal to DA2
    output reg working              // Indicates whether data is being transferred
    // output reg start             // Optional: can be used as trigger
);

// Internal registers and wires
reg count;
reg contCount;
reg [3:0] counter;
reg [15:0] SDATAbuff0, SDATAbuff1;
wire [15:0] SDATAbuff_cont0, SDATAbuff_cont1;

// Format the data packets: {2'b00, mode, 12-bit value}
assign SDATAbuff_cont0 = {2'b00, chmode0, value0};
assign SDATAbuff_cont1 = {2'b00, chmode1, value1};

// Send MSB of each buffer on SDATA[1:0]
assign SDATA = {SDATAbuff1[15], SDATAbuff0[15]};

// Shift data on rising edge of SCLK or reset on SYNC
always @(posedge SCLK or posedge SYNC) begin
    if (SYNC) begin
        SDATAbuff0 <= SDATAbuff_cont0;
        SDATAbuff1 <= SDATAbuff_cont1;
    end else begin
        if (count) begin
            SDATAbuff0 <= {SDATAbuff0[14:0], 1'b0};
            SDATAbuff1 <= {SDATAbuff1[14:0], 1'b0};
        end
    end
end

// Generate `count` signal (data shift enable)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 1'b0;
    end else begin
        case (count)
            1'b0: count <= SCLK & contCount;
            1'b1: count <= (counter != 4'd0) | contCount;
        endcase
    end
end

// Generate `contCount` to keep track of transfer state
always @(posedge clk or posedge SYNC) begin
    if (SYNC) begin
        contCount <= 1'b1;
    end else begin
        contCount <= working & contCount & (counter != 4'd15);
    end
end

// Generate `working` signal to indicate ongoing transfer
always @(posedge clk or posedge rst) begin
    if (rst) begin
        working <= 1'b0;
    end else begin
        case (working)
            1'b0: working <= SYNC;
            1'b1: working <= (counter != 4'd0) | contCount;
        endcase
    end
end

// Generate `SYNC` pulse to start transmission
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SYNC <= 1'b0;
    end else begin
        case (SYNC)
            1'b0: SYNC <= update & ~(contCount | count);
            1'b1: SYNC <= 1'b0;
        endcase
    end
end

// Count number of bits transmitted using counter
always @(negedge SCLK or posedge SYNC) begin
    if (SYNC) begin
        counter <= 4'd0;
    end else begin
        counter <= counter + {3'd0, count}; // Increment only when count is 1
    end
end

endmodule
