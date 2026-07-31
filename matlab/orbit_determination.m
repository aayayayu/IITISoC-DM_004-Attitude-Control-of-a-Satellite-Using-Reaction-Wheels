%parameters
%j2 = 1.0826271e-3;
%syms x;
%syms y;
%syms z;
% j3 = -2.5358868e-6;
% j4 = -1.6246180e-6;
% Re = 6.37814e+3;
% % R = [x y z];
% Ze = Re/norm(R);
% Zr = R(3)/norm(R);
% fxy2 = 3.0*j2*(5.0*(Zr.^2)-1.0);
% fxy3 = 5.0*j3*Ze*(7.0*(Zr.^3) - 3.0*Zr);
% fxy4 = 3.75*j4*(Ze.^2)*(21.0*(Zr.^4) - 14.0*(Zr.^2) + 10.0);
% fz2 = 3.0*j2*(5.0*(Zr.^2)-3.0);
% fz3 = j3*Ze*(Zr*(35.0*(Zr.^3) - 30.0*Zr) + norm(R));
% fz4 = 1.25*j4*(Ze.^2)*(63.0*(Zr.^4) - 70.0*(Zr.^2) + 15.0);
% mu = 3.9860064e+5;
% ag_k = (mu*(Re.^2))/(2.0*(norm(R).^5));
% ag = ag_k*[R(1)*(fxy2+fxy3+fxy4) R(2)*(fz2+fz3+fz4) R(3)*(fz2+fz4)+fz3];
% R_d2 = (-mu/(norm(R)^3)) * R + ag;
%--------------------------------------------------------------------------

function [positions] = rk4_trajectory()
% Initial Conditions
r0 = [6878.1; 0.0; 0.0];% Initial position [x, y, z]
v3=2;
v2 = sqrt(58.402793-(v3.^2));
v0 = [0.0; v2; v3];   % Initial velocity [vx, vy, vz]

% Pack state vector Y = [x; y; z; vx; vy; vz]
Y = [r0; v0];

% Simulation Parameters
dt = 0.05;              % Time step size
num_steps = 800000;       % Number of iteration steps

% Pre-allocate matrix to store position trajectory for speed
positions = zeros(num_steps, 3);

% RK4 Integration Loop
for step = 1:num_steps
    positions(step, :) = Y(1:3)';  % Store current positio
    % Compute RK4 Slopes
    k1 = system_derivatives(Y);
    k2 = system_derivatives(Y + 0.5 * dt * k1);
    k3 = system_derivatives(Y + 0.5 * dt * k2);
    k4 = system_derivatives(Y + dt * k3);

    % Update State Vector
    Y = Y + (dt / 6.0) * (k1 + 2*k2 + 2*k3 + k4);
end
[F, G, H] = sphere(60); 

% 2. Create a new figure window
figure;

% 3. Plot the surface mesh

% Plot the 3D Trajectory
plot3(positions(:,1), positions(:,2), positions(:,3), 'b-', 'LineWidth', 1.5);  
% Set axis limits for better visualization
axis equal;
xlim([-1.5*6.378140000000000e+03, 1.5*6.378140000000000e+03]);
ylim([-1.5*6.378140000000000e+03, 1.5*6.378140000000000e+03]);
zlim([-1.5*6.378140000000000e+03, 1.5*6.378140000000000e+03]);
grid on;
xlabel('X Position');
ylabel('Y Position');
zlabel('Z Position');
hold on;
surf(6.378140000000000e+03*F, 6.378140000000000e+03*G, 6.378140000000000e+03*H);
hold off;
title('trajectory of cubesat');
end

%% Helper Function: Full System Derivatives
function dYdt = system_derivatives(Y)
r = Y(1:3);  % Position vector [x, y, z]
v = Y(4:6);  % Velocity vector [vx, vy, vz]

a = compute_acceleration(r);  % Compute field force / acceleration

% Return state derivative dY/dt = [velocity; acceleration]
dYdt = [v; a];
end

%% Helper Function: Compute Acceleration Field E(r)
function a = compute_acceleration(r)
x = r(1);
y = r(2);
z = r(3);

r_mag = norm(r);  % Equivalent to sqrt(x^2 + y^2 + z^2)

% Singularity protection near origin
if r_mag < 1e-10
    a = [0.0; 0.0; 0.0];
    return;
end

% Acceleration components
ax = (2075563653333155*x*((52488413070555911503345263255325*((3*z)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2) - (7*z^3)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^(3/2)))/(649037107316853453566312041152512*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2)) - (353728435743029710669450146054667301758162497183*((21*z^4)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^2 - (14*z^2)/(abs(x)^2 + abs(y)^2 + abs(z)^2) + 10))/(1427247692705959881058285969449495136382746624*(abs(x)^2 + abs(y)^2 + abs(z)^2)) + (37445521951804425*z^2)/(2305843009213693952*(abs(x)^2 + abs(y)^2 + abs(z)^2)) - 7489104390360885/2305843009213693952))/(256*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(5/2)) - (3423953425929339*x)/(8589934592*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(3/2));
ay = - (3423953425929339*y)/(8589934592*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(3/2)) - (2075563653333155*y*((10497682614111182300669052651065*((abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2) - (z*((30*z)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2) - (35*z^3)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^(3/2)))/(abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2)))/(649037107316853453566312041152512*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2)) + (117909478581009903556483382018222433919387499061*((63*z^4)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^2 - (70*z^2)/(abs(x)^2 + abs(y)^2 + abs(z)^2) + 15))/(1427247692705959881058285969449495136382746624*(abs(x)^2 + abs(y)^2 + abs(z)^2)) - (37445521951804425*z^2)/(2305843009213693952*(abs(x)^2 + abs(y)^2 + abs(z)^2)) + 22467313171082655/2305843009213693952))/(256*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(5/2));
az = - (2075563653333155*((10497682614111182300669052651065*((abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2) - (z*((30*z)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2) - (35*z^3)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^(3/2)))/(abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2)))/(649037107316853453566312041152512*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(1/2)) + z*((117909478581009903556483382018222433919387499061*((63*z^4)/(abs(x)^2 + abs(y)^2 + abs(z)^2)^2 - (70*z^2)/(abs(x)^2 + abs(y)^2 + abs(z)^2) + 15))/(1427247692705959881058285969449495136382746624*(abs(x)^2 + abs(y)^2 + abs(z)^2)) - (37445521951804425*z^2)/(2305843009213693952*(abs(x)^2 + abs(y)^2 + abs(z)^2)) + 22467313171082655/2305843009213693952)))/(256*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(5/2)) - (3423953425929339*z)/(8589934592*(abs(x)^2 + abs(y)^2 + abs(z)^2)^(3/2));

a = [ax; ay; az];
end
ECI_orbit_positions_2 = rk4_trajectory();
