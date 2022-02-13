import subprocess
from sys import argv, exit
import os
import json
import subprocess

BUILD = subprocess.getoutput("echo $BUILD")
LFS = subprocess.getoutput("echo $LFS")

PACKAGES = f'{BUILD}/packages.json'
CONFIGURATION = f'{BUILD}/configuration.json'
SOURCES = f'{LFS}/sources'
EXTRACTION = f'{SOURCES}/tmp'


class Installer:
    
    def __init__(self):
        self.params = argv[2:]
        self.__getattribute__(argv[1])()
    
    def _json_data(self, file_name:str):
        json_file = open(file_name, 'r')
        return json.load(json_file)

    def _executeCommands(self, commands:list):
        for c in commands: subprocess.run(c, shell=True)
    
    def package_download(self):
        json_data = self._json_data(PACKAGES)
        wget_fmt = 'wget {} -O {}'       
        data = (i for val in json_data.values() for i in val)
        for i in data:
            if os.path.isfile(i['path']): continue
            _input = wget_fmt.format(i['download'], i['path'])
            subprocess.run(_input, shell=True)
    
    def package_configuration(self):
        p = self.params
        stage = p[0]; pkg = int(p[1])
        json_data = self._json_data(CONFIGURATION)
        try:
            target = json_data[stage][pkg]
            self._executeCommands([f'rm -rdf {EXTRACTION}'])
        except IndexError:
            exit(-1)
        self._executeCommands([
            f'mkdir {EXTRACTION}',
            f'tar -xf {LFS}{target["path"]} -C {EXTRACTION} --strip-components=1'
        ])
        print(target['config'])
        

if __name__ == '__main__':
    Installer()