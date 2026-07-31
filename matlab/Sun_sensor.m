function[estimated_sun_vector_b] = Sun_sensor(Y,M,D,h,m,s,matrix)
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
ECI_sun_vector = transpose([cos(Lambda),cos(epsilon)*sin(Lambda),sin(epsilon)*sin(Lambda) ]);
absolute_sun_vector_b = matrix*ECI_sun_vector;
s = 3;
estimated_Abi = zeros(s, s); % Initialize the estimated_Abi matrix
for c = 1:s
    for r = 1:s
        a = -0.00;
        b = 0.00;
        n = 1;
        t = a + (b-a).*rand(n,1);
        estimated_Abi(r,c) = matrix(r,c)-t;
    end
end

estimated_sun_vector_b = estimated_Abi*ECI_sun_vector;

% Normalize the sun vector to obtain unit vector
estimated_sun_vector_b = estimated_sun_vector_b / norm(estimated_sun_vector_b);
estimated_sun_vector_b = estimated_sun_vector_b';

