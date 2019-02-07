from gym.envs.registration import register
import os
import fileinput

FD = os.path.dirname(os.path.realpath(__file__));

register(
    id='Eplus-demo-v1',
    entry_point='eplus_env.envs:EplusEnv',
    kwargs={'eplus_path':FD + '/envs/EnergyPlus-8-6-0/', # The EnergyPlus software path
            'weather_path':FD + '/envs/weather/pittsburgh_TMY3.epw', # The epw weather file
            'bcvtb_path':FD + '/envs/bcvtb/', # The BCVTB path
            'variable_path':FD + '/envs/eplus_models/demo_5z/learning/cfg/variables_v0.cfg', # The cfg file
            'idf_path':FD + '/envs/eplus_models/demo_5z/learning/idf/5ZoneAutoDXVAV_v0.idf', # The idf file
            'env_name': 'Eplus-demo-v1',
            });

