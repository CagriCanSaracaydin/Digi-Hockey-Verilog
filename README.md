## Digital Hockey Game Simulation

### Overview
This repository contains the Verilog source code and associated testbenches for a digital hockey game simulation. This project aims to implement a robust simulation environment to mimic a digital air hockey game, exploring concepts of digital logic design and system integration in a fun and interactive way.

### Features
- **Modular Design**: The main module, `hockey`, encapsulates the core game logic, handling player inputs, puck movement, scoring, and game states.
- **Testbench (`hockey_sim`)**: A comprehensive testbench is provided to simulate various game scenarios including boundary conditions, player interactions, and typical game flow.
- **Parameterized Settings**: Clock frequency and game dynamics can be adjusted through Verilog parameters, offering flexibility and ease of testing under different system configurations.
- **Interactive Gameplay**: Simulates real-time player actions and game responses, including directional control and scoring mechanics.

### Usage
To run the simulation:
1. Clone the repository.
2. Open the project in your preferred Verilog simulation tool (e.g., ModelSim, Vivado, Icarus Verilog).
3. Compile the `hockey.v` and `hockey_sim.v` files.
4. Run the testbench to observe the simulation. Adjust test parameters as needed to explore different aspects of the game logic.
