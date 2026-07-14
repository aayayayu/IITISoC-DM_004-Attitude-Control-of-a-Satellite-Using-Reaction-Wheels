function[R_s] = Sun_vector_ECI(Y,M,D,h,m,s)
% Inputs
% 
% Outputs
% Sx
% Sy
% Sz
JD = 367*Y - floor((7/4)*(Y+floor((M+9)/12))) + floor(275*M/9) + D + 1721013.5 + h/24 + m/1440 + s/86400;
Tut1 = (JD-2541545.0)/36525;
L = 280.4606184 + 36000.77005361*Tut1;
g = 357.5277233 + 35999.05034*Tut1;
Lambda = L+1.914666471*sin(g) + 0.019994643*sin(2*g);
epsilon = 23.439291 - 0.0130042*Tut1;
R_s = [cos(Lambda),cos(epsilon)*sin(Lambda),sin(epsilon)*sin(Lambda) ];
%Rsx = cos(Lambda);
%Rsy = cos(epsilon)*sin(Lambda);
%Rsz = sin(epsilon)*sin(Lambda);