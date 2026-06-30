# IITISoC-DM_004-Attitude-Control-of-a-Satellite-Using-Reaction-Wheels
## ADCS for LEO Cubesats
The aim of this project is to design a realistically feasible cubesat and reaction wheels and then implement and simulate the ADCS loop for two cases:

-To go from an arbitary orientation to desired orientation and maintain that orientation

-To recover from unexpected external disturbances

## Reaction wheels 

Reaction wheels are entirely internal, consume very little power, and offer extremely fine pointing control. They are the preferred choice for missions demanding high accuracy — from large space telescopes to small student-built CubeSats. They work on the principle of conservation of angular momentum.

## Control loop

<img width="833" height="500" alt="Screenshot 2026-06-30 071853" src="https://github.com/user-attachments/assets/8196664a-cca0-43e6-8cf6-6890e880d23c" />

Reference block: Converts geodetic coordinates to EC/EF frame and EC/EFframe to GCI frame and their respective attitude matrices to their quaternion parameterization.

Controller block: Converts quaternion representations to speed inputs for reaction wheels.

Plant block: Model of motor and wheels.

Disturbances block: Model real world external torque agents like solar radiation pressure.

Sensors block: Estimates state and gives the error in form of quaternion representation.
