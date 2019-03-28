# Gym-Eplus
### This environment has been only tested in Ubuntu 16.04 OS.
###
This environment wraps the EnergyPlus-v-8-6 into the OpenAI gym environment interface.
### Installation
EnergyPlus is platform dependent. So this repository does not include the EnergyPlus software. Please download
the EnergyPlus-v-8-6 from https://energyplus.net/downloads, extract it, and place it to the directory 
eplus_env/envs/EnergyPlus-8-6-0. 

The environment depends on BCVTB-1.6.0 (https://simulationresearch.lbl.gov/bcvtb). There 
is no need to re-install it since this repository already had it. But BCVTB-1.6.0 is compiled
with Java-1.8. Make sure you have Java-1.8 on your OS. 

```sh
$ virtualenv virt_env --python=python3
$ source virt_env/bin/activate
$ pip install gym
$ pip install -e Gym-Eplus/
```

### Usage
#### Overview
Gym-Eplus is implemented based on EnergyPlus ExternalInterface function. The EnergyPlus model should be configured
based on the guidelines here (https://simulationresearch.lbl.gov/bcvtb/releases/latest/doc/manual/tit-EnePluCon.xhtml).
#### Create a new environment
A new environment should be registered in eplus_env/__init__.py file.
#### EnergyPlus simulation output
EnergyPlus logs its own output. The output will be stored under the directory $pwd/Eplus-env-{environment name}-res{x}/Eplus-env-sub_run{x}/output. The "sub_run" directory is the directory for each episode (each EnergyPlus simulation run period) that the environment runs.

#### Public attributes
* start_year: EnergyPlus simulation start year, int.
* start_mon: EnergyPlus simulation start month, int.
* start_day: EnergyPlus simulation start day of the month, int.
* start_weekday: EnergyPlus simulation start weekday, int. 0 is Monday. 
* env_name: The environment name.

### Example

```python
import gym;
import eplus_env;

env = gym.make('Eplus-demo-v1');
curSimTime, ob, isTerminal = env.reset(); # Reset the env (creat the EnergyPlus subprocess)
while not isTerminal:
    action = [20, 20];
    curSimTime, ob, isTerminal = env.step(action);
curSimTime, ob, isTerminal = env.reset(); # Start a new episode (creat a new EnergyPlus subprocess)
while not isTerminal:
    action = [20, 20];
    curSimTime, ob, isTerminal = env.step(action);
env.end_env(); # Safe termination of the environment after use. 
```
### Related Publications
1. Zhiang Zhang and Khee Poh Lam. 2018. Practical implementation and evaluation of deep reinforcement learning control for a radiant heating system. In Proceedings of the 5th Conference on Systems for Built Environments (BuildSys '18). ACM, New York, NY, USA, 148-157. DOI: https://doi.org/10.1145/3276774.3276775
