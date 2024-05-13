`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2023 01:51:56 PM
// Design Name: 
// Module Name: hockey
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

module hockey(

    input clk,
    input rst,
    
    input BTN_A,
    input BTN_B,
    
    input [1:0] DIR_A,
    input [1:0] DIR_B,
    
    input [2:0] Y_in_A,
    input [2:0] Y_in_B,
   
    /*output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   */
	
	output reg [2:0] X_COORD,
	output reg [2:0] Y_COORD
    );
    
    reg [2:0] next_x_coord;
    reg [2:0] next_y_coord;

    reg A_hit; // a paddle hit
    reg B_hit; // b paddle hit

    reg GOAL_A; // a goal
    reg GOAL_B; // b goal

    reg dirX; // direction of X, 0 for left, 1 for right
    reg [1:0] dirY; // direction of Y, 0 for straight, 1 for up, 2 for down

    reg [2:0] SCOREA;
    reg [2:0] SCOREB;

    //timer for the game
    reg [23:0] timer;

    reg disp; // show the score

    reg [1:0] turn; // 1 for A, 2 for B, 0 for IDLE

    // start the game
    reg start;

    // end game
    reg end_game;

    reg dirY_y;

    
    
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            X_COORD <= 0;
            Y_COORD <= 0;
            SCOREA <= 0;
            SCOREB <= 0;
            A_hit <= 0;
            B_hit <= 0;
            GOAL_A <= 0;
            GOAL_B <= 0;
            timer <= 0;
            turn <= 0;
            start <= 0;
            end_game <= 0;
        end
        else if (start) begin
            X_COORD <= next_x_coord;
            Y_COORD <= next_y_coord;
        end
        else if (BTN_A && ~end_game) begin
            Y_COORD <= Y_in_A;
            X_COORD <= 0;
            start <= 1;
            turn <= 1;
            dirX <= 0;
            dirY <= DIR_A;
            disp <= 1;
        end
        else if (BTN_B && ~end_game) begin
            Y_COORD <= Y_in_B;
            X_COORD <= 4;
            start <= 1;
            turn <= 2;
            dirX <= 1;
            dirY <= DIR_B;
            disp <= 1;
        end
    end

    // timer
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            timer <= 0;
        end
        else if (start) begin
            timer <= timer + 1;
        end

        if (timer == 5) begin
            if (turn == 1) begin
                GOAL_B <= 1;
                $display("Timer A");
            end
            else if (turn == 2) begin
                GOAL_A <= 1;
                $display("Timer B");
            end
        end
    end

    // A paddle hit
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            A_hit <= 0;
        end
        else if (turn == 1) begin
            if (X_COORD == 0) begin
                if (Y_COORD == Y_in_A) begin
                    A_hit <= 1;
                    dirX <= 0;
                    dirY <= DIR_A;
                    turn <= 2;
                    timer <= 0;
                    start <= 1;
                end
                else begin
                    A_hit <= 0;
                    GOAL_B <= 1;
                    turn <= 0;
                    start <= 0;
                end
            end
        end
    end

    // B paddle hit
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            B_hit <= 0;
        end
        if (turn == 2) begin
            if (X_COORD == 4) begin
                if (Y_COORD == Y_in_B) begin
                    B_hit <= 1;
                    dirX <= 1;
                    dirY <= DIR_B;
                    turn <= 1;
                    timer <= 0;
                    start <= 1;
                end
                else begin
                    B_hit <= 0;
                    GOAL_A <= 1;
                    turn <= 0;
                    start <= 0;
                end
            end
        end
    end
   

    // A score
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            SCOREA <= 0;
        end
        else if (GOAL_A) begin
            SCOREA <= SCOREA + 1;
            turn <= 0;
            GOAL_A <= 0;
            disp <= 1;
            start <= 0;
        end
    end

    // B score
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            SCOREB <= 0;
        end
        else if (GOAL_B) begin
            SCOREB <= SCOREB + 1;
            turn <= 0;
            GOAL_B <= 0;
            disp <= 1;
            start <= 0;
        end
    end

    always @* begin
      // Determine next X-coordinate
      if (X_COORD < 4 && dirX == 0) begin
        next_x_coord = X_COORD + 1;
      end else if (X_COORD == 4) begin
        next_x_coord = X_COORD - 1;
        dirX = 1;
      end else if (X_COORD > 0 && dirX == 1) begin
        next_x_coord = X_COORD - 1;
      end else if (X_COORD == 0) begin
        next_x_coord = X_COORD + 1;
        dirX = 0;
      end
  
      
      // Determine next Y-coordinate based on DIRECTION
      case (dirY)
        2'b00: // Straight
          next_y_coord = Y_COORD;
        2'b01: // Down
          if (Y_COORD < 4 && dirY_y == 0) begin
            next_y_coord = Y_COORD + 1;
          end else if (Y_COORD == 4) begin
            next_y_coord = Y_COORD - 1;
            dirY_y = 1;
          end else if (Y_COORD > 0 && dirY_y == 1) begin
            next_y_coord = Y_COORD - 1;
          end else if (Y_COORD == 0) begin
            next_y_coord = Y_COORD + 1;
            dirY_y = 0;
          end
        2'b10: // Up
          if (Y_COORD > 0 && dirY_y == 0) begin
            next_y_coord = Y_COORD - 1;
          end else if (Y_COORD == 0) begin
            next_y_coord = Y_COORD + 1;
            dirY_y = 1;
          end else if (Y_COORD < 4 && dirY_y == 1) begin
            next_y_coord = Y_COORD + 1;
          end else if (Y_COORD == 4) begin
            next_y_coord = Y_COORD - 1;
            dirY_y = 0;
          end
      endcase
    end




    // display the score
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            disp <= 0;
        end
        else if (disp) begin
            disp <= 0;
            //LEDX <= SCOREA;
            //LEDY <= SCOREB;
        end
    end

    // End game when one player reaches 3 points
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            start <= 0;
            end_game <= 0;
        end
        else if (SCOREA == 3 || SCOREB == 3) begin
            start <= 0;
            disp <= 1;
            end_game <= 1;
        end
    end

endmodule

