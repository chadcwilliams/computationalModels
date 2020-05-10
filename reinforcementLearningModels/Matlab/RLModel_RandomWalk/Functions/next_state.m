function [x2,y2] = next_state(x,y,action)
%Determine next state
x2=x;y2=y;
if action == 1
    x2=x-1;
elseif action == 2
    x2=x+1;
elseif action == 3
    y2=y-1;
else
    y2=y+1;
end
end