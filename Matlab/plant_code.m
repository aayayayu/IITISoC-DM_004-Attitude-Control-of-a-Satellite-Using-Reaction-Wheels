% BLDC Motor Control - Tuning 
% Nick Bonafede 
% 4/29/2020 
clc; clear; 
mdl = 'plant_working'; 
open_system(mdl); 

L_s = 0.0671; % Armature inductance [mH] 
T_s = 15.6; % Stall torque [mN*m] 
W_m = 57100; % No-load speed [rpm] 
V_r = 24; % Rated DC supply voltage [V] 
I_nl = 67.3; % No load current [mA] 
V_nl = 18; % Volatge at no load current [V] 

J_r = 0.0691; % Rotor inertia [g*cm^2] 
J_w = 9.35; % Wheel inertia [g*cm^2] 

Ts  = 5e-5; % Fundamental sample time [s] 
Tsc = 2e-4; % Sample time for control loop [s] 

Vdc = 18; % Maximum DC link voltage [V] 
Wnom = 30000; % Nominal motor speed, autotuning [rpm] 

Kp = 7.645098216374462e-05; % Proportional gain 
Ki = 3.392662859671413e-04; % Integrator gain 

Tb = 50; % Target bandwidth 

test = 1; % Step input 
tune = 0; % Tuning flag
open_system([mdl '/RPM']); 
tune = 1; 
sim(mdl, 2); 
simout_rpm0 = ans.simout_rpm;
%Kp = ans.SpeedLoopGains(1); 
%Ki = ans.SpeedLoopGains(2);
sim(mdl, 2);
simout_rpm1 = ans.simout_rpm;
figure(1) 
plot(simout_rpm0.time,simout_rpm0.data(:,1)/1000,'k-','LineWidth',1) 
hold on 
plot(simout_rpm0.time,simout_rpm0.data(:,2)/1000,'r-','LineWidth',.5) 
plot(simout_rpm1.time,simout_rpm1.data(:,2)/1000,'b-','LineWidth',.5) 
hold off 
grid on 
axis([.9 2 25 35]) 
xlabel('Time [sec]') 
ylabel('Speed [x1000 rpm]') 
%title('Controller Tuning Experiment') 
legend('Reference','Before Tuning','After Tuning') 
saveas(gcf,'4_Tuning/TuningExperiment.png')
figure(2) 
plot(simout_rpm0.time,simout_rpm0.data(:,1)/1000,'--k','LineWidth',1) 
hold on 
plot(simout_rpm0.time,simout_rpm0.data(:,2)/1000,'-r','LineWidth',1) 
plot(simout_rpm1.time,simout_rpm1.data(:,2)/1000,'-b','LineWidth',1) 
hold off 
grid on 
axis([0 1 0 55]) 
xlabel('Time [sec]') 
ylabel('Speed [x1000 rpm]') 
%title('Tuning Results') 
legend('Reference','Before Tuning','After Tuning') 
