function [ongoing,x,y,board_state] = update_state(x,y,x2,y2,board_state,parameters)

if x2==parameters.target(1) && y2==parameters.target(2)
    ongoing = 0;
else
    ongoing = 1;
end

board_state(x2,y2) = 1;
board_state(x,y) = 0;
x=x2;y=y2;
end