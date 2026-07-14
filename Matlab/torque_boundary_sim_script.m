% BLDC Motor Control - Torque Boundary 
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

Tb = 50; % Target bandwidth [rad/s] 

test = 2; % Max-Max input 
tune = 0; % Tuning OFF

open_system([mdl '/RPM']); 
sim(mdl, 3.5); 
simout_rpm10 = ans.simout_rpm; 
simout_torque10 = ans.simout_torque;

figure(10) 
subplot(2,1,1) 
plot(simout_rpm10.time,simout_rpm10.data(:,1)/1000,'--k','LineWidth',1) 
hold on 
plot(simout_rpm10.time,simout_rpm10.data(:,2)/1000,'-r','LineWidth',1) 
hold off 
grid on 
axis([0 3.5 -55 55]) 
xlabel('Time [sec]') 
ylabel('Speed [rpm x 1000]') 
%title('Torque Bounds: Experiment') 
legend('Reference','Response') 
subplot(2,1,2) 
plot(simout_torque10.time,simout_torque10.data(:,1)*1e3,'-r','LineWidth',1) 
grid on 
axis([0 3.5 -30 30]) 
xlabel('Time [sec]') 
ylabel('Torque [mN*m]') 
saveas(gcf,'4_Torque/TorqueExperiment.png') 

figure(11) 
plot(simout_rpm10.data(:,2)/1000,simout_torque10.data(:,1)*1e3,'-r','LineWidth',1) 
hold off 
hold on 
plot(50.9*[-1 1 1 -1 -1],1.2*[1 1 -1 -1 1],'--k','LineWidth',1) 
grid on 
axis([-60 60 -30 30]) 
xlabel('Speed [x1000 rpm]') 
ylabel('Torque [mN*m]') 
%title('Torque Bounds: Results') 
legend('Motor Bounds','Operational Range') 
saveas(gcf,'4_Torque/TorqueResults.png')