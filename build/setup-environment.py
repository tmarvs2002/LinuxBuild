import os
import subprocess

LFS = '/mnt/linux_dist/root'
BUILD = '/mnt/linux_dist/build'
ENV = f'{BUILD}/environment.sh'

def executeCommand(input:str):
    return subprocess.run(input, shell=True)

executeCommand(f'sudo -E bash {ENV}')