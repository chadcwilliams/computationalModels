function [action, update_value, update_cost] = select_action(x,y,board_values,board_efforts,parameters)

%Determine all action values
response_values = nan(1,4);
response_costs = nan(1,4);
if x-1~=0
    response_values(1,1) = board_values(x-1,y);
    response_costs(1,1) = board_efforts(x-1,y);
end
if x+1~=21
    response_values(1,2) = board_values(x+1,y);
    response_costs(1,2) = board_efforts(x+1,y);
end
if y-1~=0
    response_values(1,3) = board_values(x,y-1);
    response_costs(1,3) = board_efforts(x,y-1);
end
if y+1~=21
    response_values(1,4) = board_values(x,y+1);
    response_costs(1,4) = board_efforts(x,y+1);
end

response_EVC = response_values - (exp(response_costs)-1);

%Determine value probabilities via SoftMax
probabilities(1,:) = response_EVC;
if strcmp(parameters.responseSolutions,'SoftMax')
    probabilities(2,:) = softmax_nan(probabilities(1,:),parameters);
elseif strcmp(parameters.responseSolutions,'Greedy')
    probabilities(2,:) = probabilities(1,:);
    if rand<parameters.epsilon
        probabilities(2,~isnan(probabilities(2,:))) = 1;
    end
else
    disp('This Response Solution is Unrecognized');
end

% Action Selection
[~,loc] = find(probabilities(2,:)==max(probabilities(2,:)));
actions = Shuffle(loc);
action = actions(1);

%Output update value
if strcmp(parameters.learningSolutions,'SARSA');
    update_value = response_values(1,action);
    update_cost = response_costs(1,action);
elseif strcmp(parameters.learningSolutions,'Q')
    update_value = max(response_values(1,:));
    update_cost = max(response_costs(1,:));
else
    disp('This Learning Solution is Unrecognized');
end
end