%Tom Ferguson wrote the following code

function actualPayouts = initalize_payouts(nBandits,nTrials)
% From the Daw paper
decayParameter = 0.9836;
decayCenter = 50;
diffusionNoiseSD = 2.8;
payoutSD = 4;

% Compute mean payouts
meanPayouts = {};
for b = 1:length(nBandits)
    theseMus = nan(nBandits(b),nTrials);
    % theseMus(:,1) = round(50 + 4*randn(nBandits,1));
    theseMus(:,1) = 100*rand(nBandits(b),1);
    for i = 2:nTrials
        theseMus(:,i) = decayParameter*theseMus(:,i-1) + (1-decayParameter)*decayCenter + diffusionNoiseSD*randn(nBandits(b),1);
    end
    theseMus(theseMus < 1) = 1;
    theseMus(theseMus > 100) = 100;
    meanPayouts{b} = theseMus;
end

actualPayouts = {};
for b = 1:length(nBandits)
    theseMeanPayouts = meanPayouts{b};
    thisNoise = payoutSD.*randn(nBandits(b),nTrials);
    theseActualPayouts = round(theseMeanPayouts + thisNoise);
    theseActualPayouts(theseActualPayouts<1) = 1;
    theseActualPayouts(theseActualPayouts>100) = 100;
    actualPayouts{b} = theseActualPayouts;
end
end