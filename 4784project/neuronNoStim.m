function [ ] = neuronNoStim(  )
%NEURONNOSTIM Summary of this function goes here
%   Detailed explanation goes here

%constants
gk = 36;
gna = 120;
gl = 0.3;
Ek = -12;
Ena = 115;
El = 10.6;
Vrest = -70;

subplot(2, 1, 1);
plot(0:.01:1, Vrest, '-.');
title('Resting Membrane Potential');
xlabel('time (s)');
ylabel('V (V)');

subplot(2, 1, 2);
plot(0:.01:1, (gna/gk), '--');
title('Sodium vs Potassium Channel Conductance');
xlabel('time (s)');


end

