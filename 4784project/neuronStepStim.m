function [  ] = neuronStepStim( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%constants
gk = 36;
gna = 120;
gl = 0.3;
Ek = -12;
Ena = 115;
El = 10.6;
Vrest = -70;
deltax=0.1;

%potassium
alphan=0;
betan=0;
n=0;
dndt=0;
Vm=Vrest;
Ik=0;
dVkdt=0;
Cm = 1; %uF/cm^2
potx = [];
poty = [];
for(it=deltax:deltax:10)
    alphan = 0.1*((10-Vm)/exp((10-Vm)/10)-1);
    betan = 0.125*exp(-Vm/80);
    dndt = alphan*(1-n)-betan*n;
    dVkdt = Ik/Cm;
    Ik = (n^4)*gk*(Vm-Ek);
    n = n + deltax*dndt; %Euler's
    Ek = Ek + deltax*dVkdt;
    potx(round(it/deltax)) = it;
    poty(round(it/deltax)) = Ek;
end


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

