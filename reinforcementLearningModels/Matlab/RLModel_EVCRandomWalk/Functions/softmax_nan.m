function [output] = softmax_nan(response_values,parameters)

num_locs = find(~isnan(response_values));
probabilities = exp(response_values(num_locs)/parameters.temperature)/sum(exp(response_values(num_locs)/parameters.temperature));
probabilities = cumsum(probabilities);

response_values(num_locs) = probabilities;
responses_selected = response_values>=rand(1);

first_selected = find(responses_selected,1);

output = [0,0,0,0];
output(first_selected) = 1;
end
