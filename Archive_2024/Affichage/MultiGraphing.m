clear all, close all, clc

%%
%Define points to be graphed

Tmax = 90;

% pt_param = [2 2 2;                %nt
%     22.504 25.902 30.419;         %Lt
%     0.19257 0.19288 0.13893]      %Rsh

%pt_param = [ 1 1 1; pt_param]

indiv = 0 %Whether to group graphs by point (0) or by type (1)
N = size(pt_param,2);
%%
%Simulate points
for i = 1:N
pt_ctr = i;

%Parametres circuit
Ve = 5e3;
R = 4e-2;
L = 6e-4;
C = 1.4e-3;
%i = (Ve - sqrt(Ve^2 - 4*R*P))/(2*R);



%Parametres simulation
Ts = 1e-4;
t0 = 0.1;
Tsim = 1;


%Parametres supraconducteur
Rsh = 55e-3;
Lt = 233;
nt = 1;
Ic = 300;
Tc = 92;
tw = 4;
ts = Ts;
n0 = 21;

    Rsh = pt_param(3,pt_ctr);
    Lt = pt_param(2,pt_ctr);
    nt = pt_param(1,pt_ctr);

%Parametres de puissance
Ps = (R+Rsh)*C/L*Ve^2;


P = 4e6; %Ps*0.7102


%%
simtype = 1;

if simtype == 1
    load_system('Sim_avec_ScPF')
    SimIn = Simulink.SimulationInput('Sim_avec_ScPF');
elseif simtype == 0
    load_system('Sim0')
    SimIn = Simulink.SimulationInput('Sim0');
end
out(i) = sim(SimIn);



end

%%
%Define axes

yl = zeros(6,2) - 0.001;
yl(1,2) = max([out.Vcpl.signals.values],[],'all');
yl(2,2) = max([out.Icpl.signals.values],[],'all');
yl(3,2) = max([max([out.i_ScFCL.signals.values],[],'all') max([out.Ish.signals.values],[],'all')]);
yl(4,2) = max([out.RScFCL.signals.values],[],'all');
yl(5,2) = max([out.T_out.signals.values],[],'all') - 77;
yl(6,2) = max([max([[out.RScFCL.signals.values].*[out.i_ScFCL.signals.values].^2],[],'all') max([out.CPcoil.signals.values],[],'all')]);

yl(1,1) = min([out.Vcpl.signals.values],[],'all');
yl(2,1) = min([out.Icpl.signals.values],[],'all');
yl(3,1) = min([min([out.i_ScFCL.signals.values],[],'all') min([out.Ish.signals.values],[],'all')]);
%yl(5,1) = 76.999;

yl(:,2) = yl(:,2) * 1.1;
yl(5,:) = yl(5,:) + 77
%%
%Graph data

if indiv
for i = 1:N
figure(i)
hold on
%figure

tmax = Tsim;
Tax = out(i).Vcpl.time;



subplot(3,2,1)
plot(Tax, out(i).Vcpl.signals.values);
stabV = Is_stable(out(i).Vcpl.signals.values, 1e-3,'b')
title("V_{CPL}")
xlabel('Time')
ylabel('Voltage (V)')
xlim([0 tmax])
ylim(yl(1,:))
grid on




subplot(3,2,2)
plot(Tax, out(i).Icpl.signals.values,'b');
stabI = Is_stable(out(i).Icpl.signals.values, 1e-3)
title("i_{CPL}")
xlabel('Time')
ylabel('Current (A)')
xlim([0 tmax])
ylim(yl(2,:))
grid on


    subplot(3,2,3)
    hold on
    plot(Tax, out(i).i_ScFCL.signals.values,'b');
    plot(Tax, out(i).Ish.signals.values,'g');
    title("i_{ScFCL} and i_{sh}")
    xlabel('Time')
    ylabel('Current (A)')
    legend("i_{ScFCL}","i_{sh}")
    xlim([0 tmax])
    ylim(yl(3,:))
    grid on


    subplot(3,2,4)
    plot(Tax, out(i).RScFCL.signals.values,'m');
    title("R_{ScFCL}")
    xlabel('Time')
    ylabel('Resistance (Ω)')
    xlim([0 tmax])
    ylim(yl(4,:))
    grid on

    
    subplot(3,2,5)
    plot(Tax, out(i).T_out.signals.values);
    title("T_{supra}")
    xlabel('Time')
    ylabel('Temperature (K)')
    xlim([0 tmax])
    ylim(yl(5,:))
    grid on


    subplot(3,2,6)
    hold on
    plot(Tax, (out(i).RScFCL.signals.values).*(out(i).i_ScFCL.signals.values.^2),'c');
    plot(Tax, out(i).CPcoil.signals.values,'m');
    title("Power loss and cooling")
    xlabel('Time')
    ylabel('Power (W)')
    legend("P_{ScFCL}","CP_{coil}")
    xlim([0 tmax])
    ylim(yl(6,:))
    grid on

    shg


hold off
end

else


hold on
%figure

tmax = Tsim;
Tax = out(i).Vcpl.time;



figure(1)
    
    
    for i = 1:N

    subplot(2,N,i)
    plot(Tax, out(i).Vcpl.signals.values,'b');
    stabV = Is_stable(out(i).Vcpl.signals.values, 1e-3)
    title("V_{CPL}")
    xlabel('Time')
    ylabel('Voltage (V)')
    xlim([0 tmax])
    ylim(yl(1,:))
    grid on
    
    
    
    
    subplot(2,N,N+i)
    plot(Tax, out(i).Icpl.signals.values,'b');
    stabI = Is_stable(out(i).Icpl.signals.values, 1e-3)
    title("i_{CPL}")
    xlabel('Time')
    ylabel('Current (A)')
    xlim([0 tmax])
    ylim(yl(2,:))
    grid on
    
    end
shg

figure (2)

    for i = 1:N

    subplot(2,N,i)
    hold on
    plot(Tax, out(i).i_ScFCL.signals.values,'b');
    plot(Tax, out(i).Ish.signals.values,'g');
    title("i_{ScFCL} and i_{sh}")
    xlabel('Time')
    ylabel('Current (A)')
    legend("i_{ScFCL}","i_{sh}")
    xlim([0 tmax])
    ylim(yl(3,:))
    grid on


    subplot(2,N,N+i)
    plot(Tax, out(i).RScFCL.signals.values,'m');
    title("R_{ScFCL}")
    xlabel('Time')
    ylabel('Resistance (Ω)')
    xlim([0 tmax])
    ylim(yl(4,:))
    grid on

    end
shg

figure(3)
    for i = 1:N

    subplot(2,N,i)
    plot(Tax, out(i).T_out.signals.values);
    title("T_{supra}")
    xlabel('Time')
    ylabel('Temperature (K)')
    xlim([0 tmax])
    ylim(yl(5,:))
    grid on


    subplot(2,N,N+i)
    hold on
    plot(Tax, (out(i).RScFCL.signals.values).*(out(i).i_ScFCL.signals.values.^2),'c');
    plot(Tax, out(i).CPcoil.signals.values,'m');
    title("Power loss and cooling")
    xlabel('Time')
    ylabel('Power (W)')
    legend("P_{ScFCL}","CP_{coil}")
    xlim([0 tmax])
    ylim(yl(6,:))
    grid on

    end



shg
hold off

end
