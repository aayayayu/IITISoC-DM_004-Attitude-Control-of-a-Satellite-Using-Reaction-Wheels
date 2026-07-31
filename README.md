# IITISoC-DM_004-Attitude-Control-of-a-Satellite-Using-Reaction-Wheels
## ADCS for LEO Cubesats
The aim of this project is to design a realistically feasible cubesat and reaction wheels and then implement and simulate the ADCS loop for two cases:

-To go from an arbitary orientation to desired orientation and maintain that orientation

-To recover from unexpected external disturbances

## Reaction wheels 

Reaction wheels are entirely internal, consume very little power, and offer extremely fine pointing control. They are the preferred choice for missions demanding high accuracy from large space telescopes to small student-built CubeSats. They work on the principle of conservation of angular momentum.

## Control loop

<img width="833" height="500" alt="Screenshot 2026-06-30 071853" src="https://github.com/user-attachments/assets/8196664a-cca0-43e6-8cf6-6890e880d23c" />

Reference block: Converts geodetic coordinates to EC/EF frame and EC/EFframe to GCI frame and their respective attitude matrices to their quaternion parameterization.

Controller block: Converts quaternion representations to speed inputs for reaction wheels.

Plant block: Model of motor and wheels.

Disturbances block: Model real world external torque agents like solar radiation pressure.

Sensors block: Estimates state and gives the error in form of quaternion representation.

---

## Project Structure

```
IITISoC-DM_004-Attitude-Control-of-a-Satellite-Using-Reaction-Wheels
│
├── Assets/
├── Design/
│   ├── Finished_model/
│   └── Models/
├── Research_books/
└── README.md
```

### Assets
Contains images, diagrams, and other visual resources used throughout the project documentation.

### Design
Contains the complete CAD design of the CubeSat and its individual components.

#### Finished_model
Contains the complete CubeSat assembly model. This folder includes the fully assembled satellite after integrating all structural, electronic, and attitude control components, allowing visualization and verification of the final mechanical design.

#### Models
Contains the individual CAD models used to build the final assembly, including:

- Antenna
- Battery Pack
- CubeSat Base
- Frame
- Frame Sheet
- Solar Panels
- Payload Camera
- MCU
- Three-Axis Housing
- Reaction Wheel Mounting Plate
- Flywheel
- Motor
- Motor Housing

These individual parts are designed separately and later assembled to create the complete CubeSat model.

### Research_books
Contains reference books and study material used during the design and development of the Attitude Determination and Control System (ADCS), CubeSat structure, reaction wheels, and control algorithms.
