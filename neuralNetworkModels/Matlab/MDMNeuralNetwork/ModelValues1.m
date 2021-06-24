ConValue = 1;

% Cholestatic Intrahepatic
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
 mvm= 10;
 mvn= 40;
 Text1 = round((mvn-mvm).*rand()+mvm);

 %AST
 mvo= 8;
 mvp= 32;
 Text2 = round((mvp-mvo).*rand()+mvo);

 %ALP
 mvq= 200;
 mvr= 300;
 Text3 = round((mvr-mvq).*rand()+mvq);

 %GGT
 mvs= 100;
 mvt= 200;
 Text4 = round((mvt-mvs).*rand()+mvs);
 
 Text5 = 0;