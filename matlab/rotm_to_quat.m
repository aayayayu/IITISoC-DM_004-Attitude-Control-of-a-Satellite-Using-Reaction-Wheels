function [] = rotm_to_quat(rot)
q1 = rotm2quat(rot);
temp = q1;
q1 = [-temp(2),-temp(3),-temp(4),temp(1)]
