ConValue = 2;

% Severe Hepatocellular
%Heart Rate 
 mva = 65;
 mvb = 85;
 Range1 = round((mvb-mva).*rand()+mva);

%Systolic / Diastolic Blood Pressure
 mvc = 120;
 mvd = 140;
 mve = 70;
 mvf = 80;
 Range2a = round((mvd-mvc).*rand()+mvc);
 Range2b = round((mvf-mve).*rand()+mve);
 Range2 = Range2a/Range2b;
% O2
 mvg = 98;
 mvh = 98;
 Range3 = round((mvh-mvg).*rand()+mvg);

% RR
 mvi = 12;
 mvj = 20;
 Range4 = round((mvj-mvi).*rand()+mvi);

% Temp
 mvk = 35.5;
 mvl = 37;
 Range5 = ((mvl-mvk).*rand()+mvk);

 
 %ALT
 mvm= 850;
 mvn= 1100;
 Text1 = round((mvn-mvm).*rand()+mvm);

 %AST
 mvo= 600;
 mvp= 800;
 Text2 = round((mvp-mvo).*rand()+mvo);

 %ALP
 mvq= 30;
 mvr= 145;
 Text3 = round((mvr-mvq).*rand()+mvq);

 %GGT
 mvs= 85;
 mvt= 150;
 Text4 = round((mvt-mvs).*rand()+mvs);

 
 Text5 = 0;