`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2023 01:52:14 PM
// Design Name: 
// Module Name: hockey_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module hockey_sim();

    parameter HP = 5;       // Half period of our clock signal
    parameter FP = (2*HP);  // Full period of our clock signal
    
    parameter TP = (4*FP);  // time between turns

    reg clk, rst, BTN_A, BTN_B;
    reg [1:0] DIR_A;
    reg [1:0] DIR_B;
    reg [2:0] Y_in_A;
    reg [2:0] Y_in_B;

    wire [2:0] X_COORD, Y_COORD;

    // Our design-under-test is the hockey module
    hockey dut(clk, rst, BTN_A, BTN_B, DIR_A, DIR_B, Y_in_A, Y_in_B, X_COORD, Y_COORD);

    // This always statement automatically cycles between clock high and clock low in HP (Half Period) time.
    always #HP clk = ~clk;

    initial begin
        // Initialize all inputs
        clk = 0; 
        rst = 0;
        BTN_A = 0;
        BTN_B = 0;
        DIR_A = 0;
        DIR_B = 0;
        Y_in_A = 0;
        Y_in_B = 0;

        // Apply reset
        #FP;
        rst = 1;
        #FP;
        rst = 0;

        // Test scenario
        // Example: Simulate a scenario where Player A hits the ball
        #FP;
        #FP;
        BTN_A = 1; // Player A hits the button
        Y_in_A = 4; // Set Y-coordinate input for Player A
        DIR_A = 2'b10; // Direction for Player A
        #FP; BTN_A = 0;
        #TP;
		BTN_B = 1;
		DIR_B = 2;
		Y_in_B = 1;
		#FP;
		BTN_B = 0;
        #FP;
        BTN_B = 1;
        DIR_B = 0;
        Y_in_B = 2;
        #FP;
        BTN_B = 0;
        #TP;
        BTN_A = 1;
        DIR_A = 2;
        Y_in_A = 1;
        #FP;
        BTN_A = 0;
        #FP;
        BTN_A = 1;
        DIR_A = 0;
        Y_in_A = 2;
        #FP;
        BTN_A = 0;
        #TP;
        BTN_B = 1;
        DIR_B = 2;
        Y_in_B = 1;
        #FP;
        BTN_B = 0;
        #FP;
        #FP;
        BTN_B = 1;
        DIR_B = 1;
        Y_in_B = 1;
        #FP;
        BTN_B = 0;
        #TP;
        BTN_A = 1;
        Y_in_A = 3;
        DIR_A = 0;
        #FP;
        BTN_A = 0;
        #TP;
		
    end

endmodule