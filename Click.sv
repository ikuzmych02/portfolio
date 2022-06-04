// to make sure the input is only 
// true once for each time the buttons are pressed
module Click(clock, reset, in, out);
    input logic clock, reset, in;
    output logic out;
    // to make declare the states
    enum { off, on, hold } ps, ns;
    // to make sure the button is only true once
    always_comb begin 
        case(ps)
        
        off: begin out = 0;
              if (in) ns = off;
              else ns = on;
              end
        on:     begin out = 1;
                if (~in) ns = hold;
                else ns = off;
                end
        hold: begin out = 0;
               if (~in) ns = hold;
               else ns = off;
                end
       
        endcase
    end
    // to make sure buttons don't output anything durring reset
    always_ff  @(posedge clock) begin
        if (reset) 
            ps <= off;
        else 
            ps <= ns;
    end
endmodule