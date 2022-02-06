from _master.commands import Commands

# Match ^.*\b(x|y|z)\b.*$
# Not Match ^(?:(?!\x|y|z\b).)*$

SRC = "/mnt/linux_dist/root/sources"
TMP = f'{SRC}/tmp'

class InstallBinary(Commands):

    def __init__(self, tarF:str):
        self.tarF = tarF
        super().__init__()
    
    def begin(self):
        self.cd(SRC)
        self.tar(self.tarF)
        self.cd(TMP)
    
    def stage2(self):
        pass
    
    def end(self):
        self.cd(TMP)
        self.rm()