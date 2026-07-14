clc; clear; 
mdl = 'plant'; 
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

test = 1; % Step input
tune = 0; % Tuning flag