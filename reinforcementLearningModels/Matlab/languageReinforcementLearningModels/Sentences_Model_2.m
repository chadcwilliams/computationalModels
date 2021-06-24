%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Written by Chad C. Williams, PhD student in the Krigolson Lab, 2019%%
%%Written for the manuscript with codename 'Sentences'               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function R = Sentences_Model_2(x,p_Accuracy,p_ReactionTime,p_RewardPositivity,step)
try
    PE = []; RPE = []; %Clear variables
    learning_rate = x(1); %Learning rate determined by fmincon function
    temperature = 5; %Temperature is fixed at 5.0
    weights = 0; %Initial weights fixed at 0.0
    stim = 1:60; %Stimuli IDs
    stim(2,1:60) = 2; %Times stim viewed (start at 2 because 1 is actually the initial weights
    stim(3,1:60) = 2; %Times stim viewed (start at 2 because 1 is actually the initial weights
    value(1:60,1:100,1:60) = NaN; %Create value matrix
    value(1:60,1,1:60) = weights; %Determine initial value weight for that run
    prediction_error(1:60,1:100,1:60) = NaN; %Create prediction error matrix
    Reward_PE(1:60,1:100,1:60) = NaN; %Create RPE matrix
    accuracy(1:60,1:100) = NaN; %Create accuracy matrix
    trial = 2; %Begin at trial 1
    for block = 2:20 %Begins at block two, because the first block includes 6 new words (proceeding blocks contain 3 new/ 3 old)
        block_stims = stim(1,((block-1)*3)+1:((block-1)*3)+3); %Determine three new 'words'
        distractor_stims = Shuffle(1:block_stims(1)-1); %Determine three old/learned 'words' randomly
        block_stims(4:6) = distractor_stims(1:3); %Combine new and selected old words
        learning = 1; %Throws into trial loop, once model accuracy is sufficient (>=90%), then this turns to zero to finish simulation
        acc_trial = 1; %Will track trials within a block
        while learning
            other_responses = []; response_options = [];val_max_idx = []; %Remove used variables
            
            %Determine which word is being presented
            current_stim = block_stims(ceil(rand()*6)); %Randomly select one of the stims
            
            %Determine the three distractor responses
            other_responses = block_stims; %Assign all possible options
            other_responses(other_responses == current_stim) = []; %Remove current response (so it is not duplicated)
            response_options = Shuffle(other_responses); %Shuffle all possible distractor reponses
            response_options(4:5) = []; %Select the first three as distractors by removing the last two
            response_options(end+1) = current_stim; %Add correct response
            
            %Create vector of current weights for the stimulus and four presented words
            for response_counter = 1:4
                response_options(2,response_counter) = value(current_stim,trial-1,response_options(1,response_counter)); %Determine the values of each response respective to current stim
            end
            
            %Soft Max
            response_options(2,:) = exp(response_options(2,:)/temperature) / sum(exp(response_options(2,:)/temperature));
            
            %Create variable of SoftMax values
            soft_max(trial,1:4) = response_options(2,:); %Pull all four likelihoods of selection
            soft_max(trial,5) = stim(2,current_stim)-1; %Determine how many times this stimulus has been seen - has to ignore initial weight column
            soft_max_R(trial,1:4) = response_options(2,:); %Pull all four likelihoods of selection
            soft_max_R(trial,5) = stim(3,current_stim)-1; %Determine how many times this stimulus has been correct - has to ignore initial weight column
            
            %Determine number of times seen in relation to others
            for count = 1:4
                stim_count(count) = stim(2,response_options(1,count)); %Vector of how many times each variable is seen
            end
            
            %Determine which response has highest SoftMax value
            val_max_mag = max(response_options(2,:)); %Find max SoftMax value of responses
            val_max_idx = find(response_options(2,:) == val_max_mag); %Determine all indexes with this max
            val_max_idx = Shuffle(val_max_idx); %Shuffle max (randomly determine which response with equal max values)
            
            %Determine accuracy of response
            if response_options(1,val_max_idx(1)) == current_stim %If response was correct
                current_reward = 1; %Reward value if correct response given
                winloss = 1; %A tracker of correct or incorrect - here it is correct
            else %If response was incorrect
                current_reward = -1; %Reward value if incorrect response given
                winloss = 0; %A tracker of correct or incorrect - here it is incorrect
            end
            block_accuracy(acc_trial) = winloss; %Tracks accuracy within a block to determine learning
            
            %Adjust stimulus-response values via prediction errors and learning rate
            prediction_error(current_stim,stim(2,current_stim),response_options(1,val_max_idx(1))) = (current_reward - value(current_stim,trial-1,response_options(1,val_max_idx(1)))); %Compute prediction error - Reward minus the value of the current stim-response - Tracks all prediction errors
            Reward_PE(current_stim, stim(3,current_stim),response_options(1,val_max_idx(1))) = (current_reward - value(current_stim,trial-1,response_options(1,val_max_idx(1)))); %Compute prediction error - Reward minus the value of the current stim-response - Tracks prediction errors on correct trials
            value(:,trial,:) = value(:,trial-1,:); %Pull value column from last trial (so that any values that are not involved in this trial are left the same)
            value(current_stim,trial,response_options(1,val_max_idx(1))) = value(current_stim,trial-1,response_options(1,val_max_idx(1))) + (learning_rate*prediction_error(current_stim,stim(2,current_stim),response_options(1,val_max_idx(1)))); %Update value of the current stim-response
            
            if winloss %Lower value of all non-correct responses
                %The following commented lines are if I want to de-value the all non-relevant stim-response if the trial was correct - did not change results, so removed to simplify the model
                non_stim = 1:60; %List all possible stimuli
                non_stim(current_stim) = []; % Clear current stim
                value(current_stim,trial,non_stim) = value(current_stim,trial-1,non_stim) - (learning_rate*prediction_error(current_stim,stim(2,current_stim),response_options(1,val_max_idx(1)))); %Update value of all non-responses
                value(non_stim,trial,current_stim) = value(non_stim,trial-1,current_stim) - (learning_rate*prediction_error(current_stim,stim(2,current_stim),response_options(1,val_max_idx(1)))); %Update value of all non-stims
                stim(3,current_stim) = stim(3,current_stim) + 1; %Increase count of how many times this stimulus has successfully been responded to
            end
            accuracy(current_stim,stim(2,current_stim)) = winloss; %Track accuracy per word
            stim(2,current_stim) = stim(2,current_stim) + 1; %Increase times viewed for the stimulus
            
            %Determine whether participant learned in this 'block' (last ten trials)
            if ~mod(acc_trial,10) && sum(block_accuracy(acc_trial-9:acc_trial)) >= 9
                learning = 0; %If 90% or higher accuracy, block ends
            end
            trial = trial + 1; %Increase trial count within this simulation
            acc_trial = acc_trial + 1; %Increase trial count within this block
        end
    end
    
    %If there are trailing zeros in the matrices, they are replaced with nan so not to include them in the following calculations
    for counter = 1:60
        value(value(counter,stim(2,counter)+1:end,:) == 0) = nan;
        prediction_error(prediction_error(counter,stim(2,counter)+1:end,:) == 0) = nan;
        Reward_PE(Reward_PE(counter,stim(3,counter)+1:end,:) == 0) = nan;
        accuracy(accuracy(counter,stim(2,counter)+1:end) == 0) = nan;
    end
    
    loc = 1;
    for counter = 1:60
        PE(loc,:) = prediction_error(counter,:,counter); %Determine all prediction errors for all trials
        RPE(loc,:) = Reward_PE(counter,:,counter); %Determine all prediction errors for all correct trials
        loc = loc+1;
    end
    
    trials_to_view = 5; %Can show more trials if wanted. 
    GA_PE(1,:) = nanmean(PE(:,2:trials_to_view+1)); %Grand average (across words, not trials) the first five trials of prediction errors in this simulation (the matrix begins at 2 because column 1 is initial parameters, not a model step)
    GA_RPE(1,:) = nanmean(RPE(:,2:trials_to_view+1)); %Grand average (across words, not trials) the first five 'correct' trials of prediction errors in this simulation (the matrix begins at 2 because column 1 is initial parameters, not a model step)
    GA_accuracy(1,:) = nanmean(accuracy(:,2:trials_to_view+1)); %Grand average (across words, not trials) the first five trials of accuracy in this simulation (the matrix begins at 2 because column 1 is initial parameters, not a model step)
    
    for counter = 1:5
        %Reaction time created as a difference between the SoftMax of the current response and the average of all other possible trial responses
        idx = []; %clear index variable
        idx = find(soft_max(:,5)==counter); %Determine the first five trials
        GA_RT(1,counter) = 1-(mean(mean(soft_max(idx,4) - soft_max(idx,1:3)))); %Grand average (across words, not trials) the first five trials of reaction time in this simulation (the matrix begins at 2 because column 1 is initial parameters, not a model step)
    
            
        idx = []; %clear index variable
        idx = find(soft_max_R(:,5)==counter); %Determine the first five  correct trials
        GA_RT_R(1,counter) = 1-(mean(mean(soft_max_R(idx,4) - soft_max_R(idx,1:3)))); %Grand average (across words, not trials) the first correct five trials of reaction time in this simulation (the matrix begins at 2 because column 1 is initial parameters, not a model step)
    end
    
    gof = corrcoef(GA_accuracy',p_Accuracy'); %Determine accuracy model and data correlation
    good(1) = gof(2,1); %Put accuracy correlation into a matrix
    gof = corrcoef(GA_RT',p_ReactionTime'); %Determine reaction time model and data correlation
    good(2) = gof(2,1); %Put accuracy correlation into a matrix
    gof = corrcoef(GA_RPE',p_RewardPositivity'); %Determine reward positivity model and data correlation
    good(3) = gof(2,1); %Put accuracy correlation into a matrix
    R = -sum(abs(good)); %Sum the absolute correlations, and turn it negative for the fMINcon function
    
catch ME
    disp(ME.message); %Display message if it crashes
end