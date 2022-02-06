import subprocess

def _run(input:str):
        subprocess.run(input, shell=True) 
                
class Commands:
    
    def __init__(self):
        """ Commands Class """
         
    def cd(self, input): 
        _run(f'cd {input}')
    
    def mkdir(self, input):
        _run(f'mkdir {input}')
    
    def rm(self, input=None):
        if input: _run(f'rm -rdf {input}') 
        else: _run('rm -rdf {*,.*}')
    
    def tar(self, input):
        _run(f'tar -xzf {input} -C tmp/ --strip-components=1')
    
    def bash(self, input):
        _run(f'bash {input}')
            
