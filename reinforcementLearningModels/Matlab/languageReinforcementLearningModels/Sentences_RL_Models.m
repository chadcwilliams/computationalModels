%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Written by Chad C. Williams, PhD student in the Krigolson Lab, 2019%%
%%Written for the manuscript with codename 'Sentences'               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Clear the environment and console, randomize the random number generator
clear all; clc; rng('Shuffle');

%Setup
xmin= [0.001,.001,-1]; %There are the minimum bounds allowed for learning rate, temperature, and initial weight
xmax=[1,10,1]; %There are the maximum bounds allowed for learning rate, temperature, and initial weight
x0= (xmax+xmin)/2; %There are the first guess for learning rate, temperature, and initial weight

%Load text file with participant empirical data to determine best fit between the models and participant data
p_data = importdata('Sentences_Statistics_JoCN.txt'); %Load participant data
p_Accuracy = p_data.data(:,17:21); %Pull accuracy for all participants (for trials 1-5)
p_ReactionTime = p_data.data(:,23:27); %Pull reaction time for all participants (for trials 1-5)
p_RewardPositivity = p_data.data(:,5:9); %Pull reward positivity amplitudes for all participants (for trials 1-5)

%Options for the fmincon variable. Removes fmincon display messages, ensures that each step honours the bounds as determined above, and displays error message if it crashes.
options = optimset('Display','off','AlwaysHonorConstraints','bounds','FunValCheck','on'); 

%Run Model
for step = 1:28 %Simulate 29 times to correspond with 29 participants
    disp(' '); %Clean up console
    disp('----------------------------------'); %Organize console
    disp(' '); %Clean up console
    disp(['Subject: ',num2str(step)]); %Display which step it is on
    
    disp(' '); %Clean up console
    disp('Model 2'); %Display which model it is on
    f2 = @(x) Sentences_Model_2(x,p_Accuracy(step,:),p_ReactionTime(step,:),p_RewardPositivity(step,:),step); %Create function handle for model 2
    [X1(step,:),LL1(step)] = fmincon(f2,x0(1),[],[],[],[],xmin(1),xmax(1),[],options); %Run model 2 and determine least fits
    disp(num2str(X1(step,:))); %Display final parameters for this step and model
    
    disp(' '); %Clean up console
    disp('Model 3'); %Display which model it is on
    f3 = @(x) Sentences_Model_3(x,p_Accuracy(step,:),p_ReactionTime(step,:),p_RewardPositivity(step,:),step); %Create function handle for model 3
    [X2(step,:),LL2(step)] = fmincon(f3,x0(1:2),[],[],[],[],xmin(1:2),xmax(1:2),[],options); %Run model 3 and determine least fits
    disp(num2str(X2(step,:))); %Display final parameters for this step and model
    
    disp(' '); %Clean up console
    disp('Model 4'); %Display which model it is on
    f4 = @(x) Sentences_Model_4(x,p_Accuracy(step,:),p_ReactionTime(step,:),p_RewardPositivity(step,:),step); %Create function handle for model 4
    [X3(step,:),LL3(step)] = fmincon(f4,x0(1:3),[],[],[],[],xmin(1:3),xmax(1:3),[],options); %Run model 4 and determine least fits
    disp(num2str(X3(step,:))); %Display final parameters for this step and model
end

%Insert fixed values for the models
X1(:,2) = 5.0; %Model 2 fixed value for temperature
X1(:,3) = 0.0; %Model 2 fixed value for initial weight
X2(:,3) = 0.0; %Model 2 fixed value for initial weight

%Create structure of fits
fits.model2.parameters = X1; %Create model 2 parameters
fits.model3.parameters = X2; %Create model 3 parameters
fits.model4.parameters = X3; %Create model 4 parameters
fits.model2.LL = LL1; %Insert model 2 fits
fits.model3.LL = LL2; %Insert model 3 fits
fits.model4.LL = LL3; %Insert model 4 fits

%Save parameters and fits as a mat file
save('Sentences_ModelFitOutcome.mat','fits');