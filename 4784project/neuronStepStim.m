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
deltax=0.001;

%potassium loop vars
alphan = 0;
betan = 0;
n = 0;
dndt = 0;
Ik = 0;
dVkdt = 0;
poty = []; %Ek array
conk = []; %gk array

%sodium loop vars
alpham = 0;
betam = 0;
alphah = 0;
betah = 0;
m = 0;
h = 0;
dmdt = 0;
dhdt = 0;
Ina = 0;
dVnadt = 0;
sody = []; %Ena array
conna = []; %gk array

%general
Vm = Vrest;
dVmdt = 0;
Cm = 1; %uF/cm^2
vmx = [];
vmy = [];
I=0;
for it=deltax:deltax:10
    if it<5 %apply 5uA/cm^2 for 0.5ms
        I=.5;
    else 
        I=0;
    end
    %potassium
    alphan = 0.01*((10-Vm)/exp((10-Vm)/10)-1);
    betan = 0.125*exp(-Vm/80);
    dndt = (alphan*(1-n))-(betan*n);
    dVkdt = Ik/Cm;
    Ik = (n^4)*gk*(Vm-Ek);
    n = n + deltax*dndt; %Euler's
    Ek = Ek + deltax*dVkdt;
    poty(round(it/deltax)) = Ek;
    conk(round(it/deltax)) = (n^4)*gk;

    %sodium
    alpham = 0.1*((25-Vm)/exp((25-Vm)/10)-1);
    betam = 4*exp(-Vm/18);
    alphah = 0.07*exp(-Vm/20);
    betah = 1/(exp((30-Vm)/10)+1);
    dmdt = alpham*(1-m)-betam*m;
    dhdt = alphah*(1-h)-betah*h;
    dVnadt = Ina/Cm;
    Ina = (m^3)*gna*h*(Vm-Ena);
    m = m + deltax*dmdt; %Euler's
    h = h + deltax*dhdt; 
    Ena = Ena + deltax*dVnadt;
    sody(round(it/deltax)) = Ena;
    conna(round(it/deltax)) = (m^3)*gna*h;
    
    %general
    Il = gl*(Vm-El);
    Iion = I-Ik-Ina-Il;
    Vm = Vm + deltax*dVmdt;
    dVmdt = Iion/Cm;
    vmx(round(it/deltax)) = it;
    vmy(round(it/deltax)) = Vm;
end

subplot(2, 1, 1);
plot(vmx, vmy, 'k');
title('Membrane Potential');
xlabel('time (ms)');
ylabel('V (V)');

subplot(2, 1, 2);
plot(vmx, conk, 'r', vmx, conna, 'b');
title('Channel Conductances');
xlabel('time (ms)');
ylabel('conductance (S/cm^2)');
legend('g_K', 'g_N_a');

end

