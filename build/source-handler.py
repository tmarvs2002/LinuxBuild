import json
import re
import os
import subprocess

PKG_LIST = '/mnt/linux_dist/build/pkg-list.json'
PKG_CONFIG_LIST = '/mnt/linux_dist/build/pkg-config-list.json'
CONFIGS = '/mnt/linux_dist/build/config_scripts'
SOURCES = '/mnt/linux_dist/root/sources'

path_ref = {
    'source': SOURCES,
    'cross_toolchain': f'{CONFIGS}/cross_toolchain',
    'temporary_tools': f'{CONFIGS}/temporary_tools',
    'additional_temporary_tools': f'{CONFIGS}/additional_temporary_tools',
    'basic_system_software': f'{CONFIGS}/basic_system_software'
}

def setup():
    # Check Folders Exist
    for dir in path_ref.values():
        if os.path.isdir(dir): continue
        subprocess.run(f'mkdir -p {dir}', shell=True)
        print(f"Created Directory: {dir}")     


class JSON_Operations:
    
    def __init__(self, overwite:bool=True, silent:bool=False):
        self.all_operations = []
        self.overwite = overwite
        self.silent = silent
        print(f'Overwrite: {self.overwite}')
        print(f'Silent Mode: {self.silent}')
        for method in dir(self):
            if method[0:3] == 'OPP':      
                self.all_operations.append(
                    eval(f"self.{method}")
                )
    
    def _output(self, message:str):
        if not self.silent: print('\n' + message)
    
    def _format(self, name:str, version:str=None, path:str=None):
        _name = ""
        for char in name:
            if re.match("[A-z]|-|[0-9]", char): _name += char
            elif char == " ": _name += "-"
        if version: _version = "_"
        else: _version = version = ""
        for char in version:
            if char == ".": char = "-"
            _version += char
        
        _path = path_ref[path]
        title = _name + _version
        title = title.lower()
        return f'{_path}/{title}'
    
    def _command(self, input:str):
        subprocess.run(input, shell=True)
    
    def OPP_addStages(self, loaded):
        packages = loaded['packages']
        tmp_src = {}
        
        for p in packages:
            _name = p['name']; _src = p['source']
            tmp_src[_name] = _src
        
        stage_list_file = open(PKG_CONFIG_LIST, 'r+')
        loaded_stages = json.load(stage_list_file)

        for stage_name, configs in loaded_stages.items():
            for config in configs:        
                if 'altName' in config: name = config['altName']
                else: name = config['name']
                for s in tmp_src.keys():
                    if name in s:
                        config['source'] = tmp_src[s]
                
                conf_file = self._format(config['name'], None, stage_name)
                conf_file = f'{conf_file}.sh'
                
                if not os.path.isfile(conf_file):
                    self._command(f'touch {conf_file}')
                    
                config['config'] = conf_file               
        
        stage_list_file.seek(0)
        json.dump(loaded_stages, stage_list_file, indent=4)
        stage_list_file.close()
            
            
                   
    def OPP_addSource(self, loaded):
        packages = loaded['packages']
        patches = loaded['patches']     
        pkg_and_patch = packages + patches
        
        path = path_ref['source']
        for i in pkg_and_patch:               
            name = i['name']
            if 'source' in i \
            and not self.overwite: 
                self._output(f'Already Exists: {name}')
                continue
            source_name = os.path.basename(i['download'])
            i['source'] = f'{path}/{source_name}'
            self._output(f'Source Added: {source_name}')        
        
        print(f"Source and Config filepaths added to {PKG_LIST}")
        
        
    def OPP_downloadPackage(self, loaded):
        wget_fmt = 'wget {} -O {}'
        packages = loaded['packages']
        patches = loaded['patches']
        pkg_and_patch = packages + patches
        
        for i in pkg_and_patch:
            i['source'] = i['source']
            if os.path.isfile(i['source']): continue
            _input = wget_fmt.format(i['download'], i['source'])
            self._command(_input)
                
        print(f"Successfully Downloaded all from {PKG_LIST}")
    
        
class JSON_Handler:
    
    def __init__(self):
        operations = JSON_Operations()
        operations_list = operations.all_operations
        for operation in operations_list:
            self.load(); operation(loaded=self.loaded); self.write()
    
    def load(self):
        self.file = open(PKG_LIST, 'r+')
        self.loaded = json.load(self.file)
    
    def write(self):
        self.file.seek(0)
        json.dump(self.loaded, self.file, indent=4)
        self.file.close()
         


def run():
    setup()
    JSON_Handler()

if __name__ == '__main__':
    run()