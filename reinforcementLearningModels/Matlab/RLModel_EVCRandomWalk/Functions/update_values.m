function [board_values,board_efforts] = update_values(x,y,x2,y2,board_values,board_costs,board_efforts,update_value,update_cost,parameters)
if x2==parameters.target(1) && y2==parameters.target(2)
    reward = 1;
else
    reward = 0;
end
cost = board_costs(x2,y2);

%Determine Prediction Error
RPE = parameters.learning_rate*((reward*(parameters.step*parameters.effort_cost))+(parameters.discount*update_value)-board_values(x,y));
CPE = parameters.learning_rate*(cost+(parameters.costdiscount*exp(-update_cost))-board_efforts(x,y));

%Update Board Values
board_values(x,y) = board_values(x,y)+RPE;
board_efforts(x,y) = board_efforts(x,y)+CPE;

%Constrain values between -1 and 1
if board_values(x,y) > 1
    board_values(x,y) = 1;
elseif board_values(x,y) < -1;
    board_values(x,y) = -1;
else
    %Leave it alone
end

if board_efforts(x,y) > 1
    board_efforts(x,y) = 1;
elseif board_efforts(x,y) < -1;
    board_efforts(x,y) = -1;
else
    %Leave it alone
end


end


