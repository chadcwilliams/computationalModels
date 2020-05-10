function [response_values] = update_values(action,trial,response_values,actualPayouts,parameters)
if rand*100<actualPayouts{1,1}(action,trial)
    reward = 1;
else
    reward = 0;
end

%Determine Prediction Error
PE = parameters.learning_rate*(reward-response_values(action));

%Update
response_values(action) = response_values(action)+PE;

%Constrain values between -1 and 1
if response_values(action) > 1
    response_values(action) = 1;
elseif response_values(action) < -1;
    response_values(action) = -1;
else
    %Leave it alone
end
end

