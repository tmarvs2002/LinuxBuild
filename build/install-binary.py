import os
import subprocess
import json
import time

PKG_CONFIG_LIST = '/mnt/linux_dist/build/pkg-config-list.json'
SOURCES = '/mnt/linux_dist/root/sources'
INSTALLER = '/mnt/linux_dist/build/install-binary.sh'
BUILD_DIR = f'{SOURCES}/tmp'


class InstallBinaries:
    
    def __init__(self, stage:str):
        self.loadConfigData(stage)
        self.installBinary()
    
    def _executeCommands(self, commands:list):
        for c in commands: subprocess.run(c, shell=True)
    
    def loadConfigData(self, stage:str):
        file = open(PKG_CONFIG_LIST, 'r')
        file_data = json.load(file)
        for stg, cnf in file_data.items():
            if stg == stage:
                self.conf_list = cnf
                print("Stage Configuration Files Loaded")
                break
    
    def installBinary(self):
        for binary in self.conf_list:
            n = binary['name']
            print(f"Installing: {n}")         
            time.sleep(3)   
            self.installationSteps(binary['source'], binary['config'])
            print(f'Successfully Installed: {n}')
            time.sleep(3)
    
    def installationSteps(self, source:str, config:str):
        os.chdir(SOURCES)
        self._executeCommands([
            f'mkdir -p {BUILD_DIR}',
            f'tar -xf {source} -C {BUILD_DIR} --strip-components=1'
        ])
        
        self._executeCommands([f'bash {INSTALLER} {config}'])
        self._executeCommands([f'sudo rm -rdf {BUILD_DIR}'])


def run():
    stage_names = ['cross_toolchain', 'temporary_tools']
    for stage in stage_names:
        InstallBinaries(stage)

if __name__ == '__main__':
    run()