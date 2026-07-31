function rotm  = Quat_to_rotm(q)
% Normalize the quaternion
q = q / norm(q);
% Extract the components of the quaternion
q1 = q(1,1);
q2 = q(2,1);
q3 = q(3,1);
q4 = q(4,1);

% Compute the rotation matrix
rotm = [1 - 2*(q2^2 + q3^2), 2*(q1*q2 + q3*q4), 2*(q1*q3 - q2*q4);
    2*(q1*q2 - q3*q4), 1 - 2*(q1^2 + q3^2), 2*(q2*q3 + q1*q4);
    2*(q1*q3 + q2*q4), 2*(q2*q3 - q1*q4), 1 - 2*(q1^2 + q2^2)];