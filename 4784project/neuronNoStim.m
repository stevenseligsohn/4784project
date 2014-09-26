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
plot(0:0.001:1, Vrest, 'k');
title('Resting Membrane Potential');
xlabel('time (s)');
ylabel('V (V)');

subplot(2, 1, 2);
hp = plot(0:.001:1, gna, 'r', 0:.001:1, gk, 'b');
title('Sodium vs Potassium Channel Conductance');
xlabel('time (s)');
ylabel('conductance (S/cm^2)');
hold on;
legend(hp, 'g_N_a', 'g_K');

end

