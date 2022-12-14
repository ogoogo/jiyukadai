module b01_jiyukadai(CLK,RSTn,xOut,yOut,colorOut,BTN0,BTN1,BTN2,BTN3);

    input CLK;
    input RSTn;
    input BTN0;
    input BTN1;
    input BTN2;
    input BTN3;
    output [2:0] xOut;
    output [3:0] yOut;
    output [2:0] colorOut;

    reg [2:0] x;
    reg [3:0] y;
    reg [2:0] boxRows[0:4];
    reg [2:0] nowBox;
    reg [1:0] boxCycle;

    reg [14:0] prescaler;
    wire carryout;

    reg [21:0] prescaler2;
    wire carryout2;
    reg [48:0] otoExist;
    reg [7:0] otoSize;
    
    reg [1:0] box0Number;
    reg nowON;

    reg [2:0] color;

    reg [1:0] zeroColor;

    always @ (posedge CLK or negedge RSTn) begin
      if (RSTn == 1'b0)
        prescaler <= 0;
      else if (prescaler == 'd10000 )
        prescaler <= 0;
      else
        prescaler <= prescaler + 1;
    
    end
    assign carryout = (prescaler == 'd10000)? 1 : 0;

    always @ (posedge CLK or negedge RSTn) begin
      if (RSTn == 1'b0)begin
        x <= 0;
        y <= 4'd15;
        boxRows[0] <= 0;
        boxRows[1] <= 2;
        boxRows[2] <= 3;
        boxRows[3] <= 1;
        boxRows[4] <= 2;
        boxCycle <= 2;

      end
        
      else if (carryout == 1) begin
        if (x%2 == 0)begin
        x <= x + 1;
        y <= y;
       end
       else begin
        

       if (y == 0 && y%4 != boxCycle)
        x <= x-1;
       else begin
          if (y == 0)
            nowBox = 0;
          else begin
            case (y/4)
                'd0 : nowBox = 4;
                'd1 : nowBox = 3;
                'd2 : nowBox = 2;
                'd3: nowBox = 1; 
            endcase
          end
            

          case (boxRows[nowBox])
                'd0: x <= 0;
                'd1: x <= 2;
                'd2: x <= 4;
                'd3: x <= 6;
                'd4: x <= 0;  
  
          endcase
        end

        if (y != 0)
            y <= y - 1;
        else
            y <= 15; 
       
       end
      end
    
    
       


    
    end

    always @ (posedge CLK or negedge RSTn) begin
      if (RSTn == 1'b0)
        prescaler2 <= 0;
      else if (prescaler2 == 'd3000000 )
        prescaler2 <= 0;
      else
        prescaler2 <= prescaler2 + 1;
    
    end
    assign carryout2 = (prescaler2 == 'd3000000)? 1 : 0;

    always @(posedge CLK or negedge RSTn) begin
      if (RSTn == 1'b0)
        boxCycle <= 0;
      else if (boxCycle == 3)begin
        boxCycle <= 0;
        boxRows[0] <= boxRows[1];
        boxRows[1] <= boxRows[2];
        boxRows[2] <= boxRows[3];
        boxRows[3] <= boxRows[3];
        zeroColor <= 0
      end
        
      else if (carryout2 == 1)
        boxCycle<= boxCycle + 1;
      else
        boxCycle<=boxCycle;

      if (BTN0 == 1)begin
        if (boxRows[0]==0 and otoExist[box0Number]==1)begin
          zeroColor <= 1
        end
      end
      if (BTN1 == 1)begin
        if (boxRows[0]==1 and otoExist[box0Number]==1)begin
          zeroColor <= 1
        end
      end
      if (BTN2 == 1)begin
        if (boxRows[0]==2 and otoExist[box0Number]==1)begin
          zeroColor <= 1
        end
      end
      if (BTN3 == 1)begin
        if (boxRows[0]==3 and otoExist[box0Number]==1)begin
          zeroColor <= 1
        end
      end

    end

    // 0???box?????????
  always @ (posedge CLK or negedge RSTn) begin
    if (RSTn == 1'b0)begin
       boxCycle <= 0;
       otoExist <= otoSource;
       otoSize <= otoSizeSource;
       color <= 000
    end
    else begin
      nowOn <= otoExist[box0Number + nowBox];
      if (nowON == 0)
        color <= 000
      else 
        color <= 111
      
      if (nowBox == 0)begin
        if (zeroColor==1)
          color <= 001;
      end

    end

    
      
    

  end

  

    assign xout = x;
    assign yout = y;
    assign colorOut = color;



endmodule