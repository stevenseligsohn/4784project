function [  ] = neuronStepStim( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%constants
gk = 36; %mS/cm2
gna = 120; %mS/cm2
gl = 0.3; %mS/cm2
Ek = -12; %mV
Ena = 115; %mV
El = 10.6; %mV
Vrest = -70; %mV
deltax=0.001; 

%general loop vars
Vm = Vrest;
dVmdt = 0;
Cm = 1; %uF/cm^2
vmx = [];
vmy = [];
I=0;

%potassium loop vars
alphan = 0.01*((10-Vm)/(exp((10-Vm)/10)-1));
betan = 0.125*exp(-Vm/80);
n = alphan/(alphan+betan);
dndt = (alphan*(1-n))-(betan*n);
Ik = 0;
dVkdt = 0;
poty = []; %Ek array
conk = []; %gk array

%sodium loop vars
alpham = 0.1*((25-Vm)/(exp((25-Vm)/10)-1));
betam = 4*exp(-Vm/18);
alphah = 0.07*exp(-Vm/20);
betah = 1/(exp((30-Vm)/10)+1);
m = alpham/(alpham+betam);
h = alphah/(alphah+betah);
dmdt = alpham*(1-m)-betam*m;
dhdt = alphah*(1-h)-betah*h;
Ina = 0;
dVnadt = 0;
sody = []; %Ena array
conna = []; %gk array

for it=deltax:deltax:100 %ms
    if it<.5 %apply 5uA/cm^2 for 0.5ms
        %I=500; %V/s
    else 
        %I=0;
    end
    %potassium
    alphan = 0.01*((10-Vm)/(exp((10-Vm)/10)-1));
    betan = 0.125*exp(-Vm/80);
    dndt = (alphan*(1-n))-(betan*n);
    dVkdt = Ik/Cm;
    Ik = (n^4)*gk*(Vm-Ek); 
    n = n + deltax*dndt; %Euler's
    %Ek = Ek + deltax*dVkdt;
    %poty(round(it/deltax)) = Ek;
    conk(round(it/deltax)) = (n^4)*gk; %potassium conductance

    %sodium
    alpham = 0.1*((25-Vm)/(exp((25-Vm)/10)-1));
    betam = 4*exp(-Vm/18);
    alphah = 0.07*exp(-Vm/20);
    betah = 1/(exp((30-Vm)/10)+1);
    dmdt = alpham*(1-m)-betam*m;
    dhdt = alphah*(1-h)-betah*h;
    dVnadt = Ina/Cm;
    Ina = (m^3)*gna*h*(Vm-Ena); 
    m = m + deltax*dmdt; %Euler's
    h = h + deltax*dhdt; 
    %Ena = Ena + deltax*dVnadt;
    %sody(round(it/deltax)) = Ena;
    conna(round(it/deltax)) = (m^3)*gna*h; %sodium conductance
    
    %general
    Il = gl*(Vm-El); 
    Iion = I-Ik-Ina-Il;
    Vm = Vm + deltax*dVmdt;
    dVmdt = Iion/Cm;
    vmx(round(it/deltax)) = it;
    kder(round(it/deltax)) = dVkdt;
    nader(round(it/deltax)) = dVnadt;
    vmder(round(it/deltax)) = dVmdt;
    Icurr(round(it/deltax)) = Iion;
    potcurr(round(it/deltax)) = Ik;
    sodcurr(round(it/deltax)) = Ina;
    calcurr(round(it/deltax)) = Il;
    vmy(round(it/deltax)) = Vm;
end

subplot(3, 1, 1);
plot(vmx, vmy, 'k', vmx, kder, vmx, nader, vmx, vmder);
title('Membrane Potential');
xlabel('time (ms)');
ylabel('V (mV)');
legend('Vm', 'dVkdt', 'dVnadt', 'dVmdt');

subplot(3, 1, 2);
plot(vmx, conk, 'r', vmx, conna, 'b');
title('Channel Conductances');
xlabel('time (ms)');
ylabel('conductance (S/cm^2)');
legend('g_K', 'g_N_a');

subplot(3, 1, 3);
plot(vmx, Icurr, vmx, potcurr, vmx, sodcurr, vmx, calcurr);
title('Ion Current');
xlabel('time (ms)');
ylabel('I (mA)');
legend('Iion', 'Ik', 'Ina', 'Il');

end

