function [action] = select_action(response_values,parameters)

probabilities(1,:) = response_values;

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
end