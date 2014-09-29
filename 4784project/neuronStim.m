function [  ] = neuronStim( mode )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%input: mode 0 = no current input to system
%   mode 1 = pulse current input
%   mode 2 = unit step current input
if mode>2
    fprintf('Invalid input.\n')
    return
elseif mode<0
    fprintf('Invalid input.\n')
    return
end

%constants
gk = 36; %mS/cm2
gna = 120; %mS/cm2
gl = 0.3; %mS/cm2
Ek = -12; %mV
Ena = 115; %mV
El = 10.6; %mV
Vrest = -70; %mV
deltax=.001; 

%general loop vars
Vm = 0;%Vrest;
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
        if mode~=0 
            I=50;%E-2; %V/s
        end
    else 
        if mode==1
            I=0;
        end
    end
    %potassium
    alphan = 0.01*((10-Vm)/(exp((10-Vm)/10)-1));
    betan = 0.125*exp(-Vm/80);
    dndt = (alphan*(1-n))-(betan*n);
    dVkdt = Ik/Cm;
    Ik = (n^4)*gk*(Vm-Ek);
    n = n + deltax*dndt; %Euler's
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
    conna(round(it/deltax)) = (m^3)*gna*h; %sodium conductance
    
    %general
    Il = gl*(Vm-El); 
    Iion = I-Ik-Ina-Il;
    dVmdt = Iion/Cm;
    Vm = Vm + deltax*dVmdt;
    vmx(round(it/deltax)) = it;
    vmy(round(it/deltax)) = Vm;
end

subplot(2, 1, 1);
plot(vmx, vmy-70, 'k');
title('Membrane Potential');
xlabel('time (ms)');
ylabel('V (mV)');

subplot(2, 1, 2);
plot(vmx, conk, 'r', vmx, conna, 'b');
title('Channel Conductances');
xlabel('time (ms)');
ylabel('conductance (S/cm^2)');
legend('g_K', 'g_N_a');

end

