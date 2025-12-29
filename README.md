# Comparative Study: Fuzzy Control vs. Neural Network Control

## Overview
This project investigates and compares the performance of two advanced control strategies (**Fuzzy Logic Control** and **Neural Network Control**) applied to a first-order RC circuit. Both strategies rely on a "expert" Proportional-Integral (PI) controller for baseline performance data and training.

The study evaluates the efficacy of these methodologies in terms of stability, response time, and robustness, implementing simulations in **MATLAB/Simulink** and **LabVIEW**, with physical validation using a DAQ and oscilloscope.

## Project Authors
* **Leandro Llontop Herrera**
* **Juan Contreras Avendaño**
* **Fidel Castro Suazo**
* **Franck Condori Sinches**

*Escuela Profesional de Ingeniería Mecatrónica, Universidad Nacional de Ingeniería, Perú.*

## Repository Structure

### Documentation
* `Paper_IA_LAB04.pdf`: The detailed research paper describing the mathematical modeling, design process, and experimental results.
* `LICENSE`: MIT License governing the use of this software.

### MATLAB/Simulink Implementation
* **Scripts:**
    * `Scripts_Control_Redes_Neuronales/Entrenamiento.m`: MATLAB script used to generate PI control data, train the Neural Network (using `fitnet`), and simulate the response.
* **Simulink Models:**
    * `Scripts_Control_Difuso/pidRC.slx`: Simulation of the PI controller.
    * `Scripts_Control_Difuso/justfuzzy.slx`: Simulation of the standalone Fuzzy Controller.
    * `Scripts_Control_Redes_Neuronales/Simulación PI.slx`: Simulation used for PI data acquisition.
* **Fuzzy Systems:**
    * `Scripts_Control_Difuso/man8.fis`: The Fuzzy Inference System (Mamdani type) file containing membership functions and rules.

### LabVIEW Implementation
* `Scripts_Control_Difuso/LabView.rar`: Archive containing the LabVIEW Virtual Instruments (VIs) for the Fuzzy System Designer and physical implementation.

## Technical Details

### 1. Plant Modeling
The system controls an RC circuit modeled as a first-order transfer function:

$$H(s) = \frac{1}{s + 1}$$

*(Assuming $$ \tau = RC = 1 $$)*.

### 2. Control Strategies

#### A. Expert PI Controller
Used to generate training data for the Neural Network and heuristic rules for the Fuzzy Controller.
* **Target Specs:** Settling time $t_s \approx 0.8s$, Damping $$\zeta = 0.9285$$.
* **Parameters (from script):** $$K_p = 8.1$$, $$K_i = 42.25$$.

#### B. Fuzzy Logic Control
Designed to handle uncertainty using linguistic rules.
* **Type:** Mamdani.
* **Inputs:** Error ($e$) and Derivative of Error ($$de/dt$$).
* **Output:** Control Signal ($$u$$).
* **Membership Functions:** Gaussian distributions (defined in `man8.fis`).

#### C. Neural Network Control
Acts as a function approximator trained via Backpropagation (Levenberg-Marquardt).
* **Architecture:**
    * Inputs: 2 (Error, Integral of Error).
    * Hidden Layer: 3 Neurons (Tansig activation).
    * Output Layer: 1 Neuron (Linear activation).
* **Training Data:** Derived from the PI controller's response to a step input.

## Usage Instructions

### Prerequisites
* MATLAB with Simulink, Fuzzy Logic Toolbox, and Deep Learning Toolbox.
* LabVIEW (with Control Design and Simulation Module).

### Running the Neural Network Training
1.  Open MATLAB.
2.  Navigate to `Scripts_Control_Redes_Neuronales/`.
3.  Run `Entrenamiento.m`.
    * This will simulate the closed-loop PI system.
    * Calculate Error and Integral of Error.
    * Train the network (`fitnet`).
    * Plot the comparison between the PI controller and the trained Neural Network.

### Running the Fuzzy Simulation
1.  Open MATLAB and launch the **Fuzzy Logic Designer** (`fuzzyLogicDesigner`).
2.  Import `man8.fis` to view rules and surfaces.
3.  Open `Scripts_Control_Difuso/justfuzzy.slx` in Simulink to run the simulation.

## Results Summary
* **Neural Network:** Demonstrated superior adaptability and precision, closely replicating the "expert" PI behavior after training.
* **Fuzzy Logic:** Proved excellent for simplicity and ease of implementation, though performance depends heavily on the subjective definition of linguistic rules.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
