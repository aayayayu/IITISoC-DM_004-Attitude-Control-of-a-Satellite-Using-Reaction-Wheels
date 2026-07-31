function [estimated_m_vector_b] = magnetometer_sensor(r,theta,phi,days,Y,M,D,h,m,s,matrix)
% Inputs
% r Geocentric radius
% theta Latitude measured in degrees positive from equator
% phi Longitude measured in degrees positive east from Greenwich
% days Decimal days since January 1, 2000

% Outputs - magnetic field strength in local tangential coordinates
% Br B in radial direction
% Bt B in theta direction
% Bp B in phi direction
% Checks to see if located at either pole to avoid singularities
if (theta>-0.00000001 && theta<0.00000001)
    theta=0.00000001;
elseif(theta<180.00000001 && theta>179.99999999)
    theta=179.99999999;
end
JD = 367*Y - floor((7/4)*(Y+floor((M+9)/12))) + floor(275*M/9) + D + 1721013.5;
Tut1 = (JD-2541545.0)/36525;
theta_gmst = 24110.54841+ 8640184.812866*Tut1+ 0.093104*(Tut1).^2 - 6.2*(10.^-6)*(Tut1.^3) + 1.002737909350795*(3600*h + 60*m+s);
theta_gmst = theta_gmst - 86400*(floor(theta_gmst/86400));
theta_gmst = theta_gmst/240;
% display(theta_gmst)
LST = phi + theta_gmst;
LST = mod(LST,360);
% LST Local sidereal time of location (in degrees)
% The angles must be converted from degrees into radians
theta=(90-theta)*pi/180;
phi = phi*pi/180;
LST=LST*pi/180;
lat = theta;
a=6.37814e+3; % Reference radius used in IGRF
% This section of the code simply reads in the g and h Schmidt
% quasi-normalized coefficients
gn    = zeros(0, 1);
gm    = zeros(0, 1);
gvali = zeros(0, 1);
gsvi  = zeros(0, 1);
hn    = zeros(0, 1);
hm    = zeros(0, 1);
hvali = zeros(0, 1);
hsvi  = zeros(0, 1);
fidG = fopen('igrfSg.txt', 'r');
if fidG ~= -1
    dataG = fscanf(fidG, '%f %f %f %f', [4, Inf])';
    fclose(fidG);
    
    gn    = dataG(:, 1);
    gm    = dataG(:, 2);
    gvali = dataG(:, 3);
    gsvi  = dataG(:, 4);
end

fidH = fopen('igrfSh.txt', 'r');
if fidH ~= -1
    dataH = fscanf(fidH, '%f %f %f %f', [4, Inf])';
    fclose(fidH);
    
    hn    = dataH(:, 1);
    hm    = dataH(:, 2);
    hvali = dataH(:, 3);
    hsvi  = dataH(:, 4);
end
% [gn, gm, gvali, gsvi] = textread('igrfSg.txt','%f %f %f %f');
% [hn, hm, hvali, hsvi] = textread('igrfSh.txt','%f %f %f %f');
N=max(gn);
g=zeros(N,N+1);
h=zeros(N,N+1);
for x=1:length(gn)
    g(gn(x),gm(x)+1) = gvali(x) + gsvi(x)*days/365;
    h(hn(x),hm(x)+1) = hvali(x) + hsvi(x)*days/365;
end
% Initialize each of the variables
% Br B in the radial driection
% Bt B in the theta direction

% Bp B in the phi direction
% P The associated Legendre polynomial evaluated at cos(theta)
% The nomenclature for the recursive values generally follows
% the form P10 = P(n-1,m-0)
% dP The partial derivative of P with respect to theta
Br=0; Bt=0; Bp=0;
P11=1; P10=P11;
dP11=0; dP10=dP11;
P20=0;dP20=0;
for m=0:N
    for n=1:N
        if m<=n
            % Calculate Legendre polynomials and derivatives recursively
            if n==m
                P2 = sin(theta)*P11;
                dP2 = sin(theta)*dP11 + cos(theta)*P11;
                P11=P2; P10=P11; P20=0;
                dP11=dP2; dP10=dP11; dP20=0;
            elseif n==1
                P2 = cos(theta)*P10;
                dP2 = cos(theta)*dP10 - sin(theta)*P10;
                P20=P10; P10=P2;
                dP20=dP10; dP10=dP2;
            else
                K = ((n-1)^2-m^2)/((2*n-1)*(2*n-3));
                P2 = cos(theta)*P10 - K*P20;
                dP2 = cos(theta)*dP10 - sin(theta)*P10 - K*dP20;
                P20=P10; P10=P2;
                dP20=dP10; dP10=dP2;
            end
            % Calculate Br, Bt, and Bp
            Br = Br + (a/r)^(n+2)*(n+1)*...
                ((g(n,m+1)*cos(m*phi) + h(n,m+1)*sin(m*phi))*P2);
            Bt = Bt + (a/r)^(n+2)*...
                ((g(n,m+1)*cos(m*phi) + h(n,m+1)*sin(m*phi))*dP2);
            Bp = Bp + (a/r)^(n+2)*...
                (m*(-g(n,m+1)*sin(m*phi) + h(n,m+1)*cos(m*phi))* P2);
        end
    end
end

Br = Br;
Bt = -Bt;
Bp = -Bp / sin(theta);


% Coordinate transformation
Bx = (Br*cos(lat)+Bt*sin(lat))*cos(LST) - Bp*sin(LST);
By = (Br*cos(lat)+Bt*sin(lat))*sin(LST) + Bp*cos(LST);
Bz = (Br*sin(lat)+Bt*cos(lat));
ECI_m_vector = [Bx By Bz];
absolute_m_vector_b = matrix*transpose(ECI_m_vector);
%display(absolute_m_vector_b)
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
estimated_m_vector_b = estimated_Abi*transpose(ECI_m_vector);

% Normalize the sun vector to obtain unit vector
% estimated_m_vector_b = estimated_m_vector_b / norm(estimated_m_vector_b);
estimated_m_vector_b = 1e-9.*estimated_m_vector_b';
