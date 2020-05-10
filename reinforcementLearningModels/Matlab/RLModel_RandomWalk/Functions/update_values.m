function board_values = update_values(x,y,x2,y2,board_values,update_value,parameters)
if x2==parameters.target(1) && y2==parameters.target(2)
    reward = 1;
else
    reward = 0;
end

%Determine Prediction Error
PE = parameters.learning_rate*(reward+(parameters.discount*update_value)-board_values(x,y));

%Update Board Values
board_values(x,y) = board_values(x,y)+PE;

%Constrain values between -1 and 1
if board_values(x,y) > 1
    board_values(x,y) = 1;
elseif board_values(x,y) < -1;
    board_values(x,y) = -1;
else
    %Leave it alone
end

end


