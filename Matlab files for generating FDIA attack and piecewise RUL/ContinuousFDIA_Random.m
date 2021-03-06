%Random noise generation for continuous period
clc,
clear all;
close all;

%path to the test data
N = readtable('PM_test.txt','ReadVariableNames',false);
T= removevars(N,{'Var27'});

% define initial engine ID
engineId=1;

% define the engine ID untill which point the attack should happen
engineIdEnd=37;

%define cycle start (Define the period of the attack)
cycleStart=1; %piece wise RUL it is the same

% define the sensors whre the noise has to be added
%sensors=[2;7;8;11;14;20;21]; 
sensors=[2;3;4;7;8;9;11;12;13;14;15;17;20;21];
%sensors=[2;8;14];

%Define the bounds for the noise to be added
bound1=-0.05; %high
bound2=-0.04; %low

%FGSM GRU-21-25 LSTM 24-30 CNN-40 -43
%BIM GRU -35-40 LSTM 38-40 CNN-50 -60

for l=engineId:engineIdEnd
Table = T(T.Var1==l & T.Var2 > cycleStart,:);

    for i=1:size(sensors, 1)
        s = sensors(i,1:1);
        %generate N random numbers in the interval (a,b) with the formula r = a + (b-a).*rand(N,1).
        noise =bound1 + (bound2-bound1)*rand(1,1);
        Table{:,s+5} = round(Table{:,s+5}*(100+noise)/100,2);
    end

    T(T.Var1==l & T.Var2 > cycleStart,:)=Table;

end

emptyCol = cell(size(T, 1),1);
T=[T emptyCol emptyCol];

%write to a text file
writetable(T,'Attacked_data.txt','WriteVariableNames', false,'Delimiter',' ')  
