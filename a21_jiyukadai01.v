module a21_jiyukadai01(CLK,RSTn,xOut,yOut);

    input CLK;
    input RSTn;
    output [2:0] xOut;
    output [3:0] yOut;

    reg [2:0] x;
    reg [3:0] y;
    reg [2:0] boxRows[0:3];
    reg [2:0] nowBox;

    reg [14:0] prescaler;
    wire carryout;

    always @ (posedge CLK or negedge RSTn) begin
      if (RSTn == 1'b0)
        prescaler <= 0;
      else if (prescaler == 'd10000 )
        prescaler <= 0;
      else
        prescaler <= prescaler + 1
    
    end
    assign carryout = (prescaler == 'd10000)? 1 : 0;

    always @ (posedge CLK or negedge RSTn) begin
      if (RSTn == 1'b0)begin
        x <= 0;
        y <= 4'15;
        boxRows[0] <= 0;
        boxRows[1] <= 2;
        boxRows[2] <= 3;
        boxRows[3] <= 1;

      end
        
      else if (carryout == 1) begin
        if (x%2 == 0)begin
        x <= x + 1;
        y <= y;
       end
       else begin
        

       if (y%4 != 0)
        x <= x-1;
        else begin
            case (y)
                'd0 : nowBox <= 0;
                'd4 : nowBox <= 3;
                'd8 : nowBox <= 2;
                'd12: nowBox <= 1; 
            endcase

            case (boxRows[nowBox])
                'd0: x <= 0;
                'd1: x <= 2;
                'd2: x <= 4;
                'd3: x <= 6;
                'd4: x <= 0;  
                default: 
            endcase
        end

        if (y != 0)
            y <= y - 1;
        else
            y <= 15; 
       
       end
      end
       


    
    end



endmodule