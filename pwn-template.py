#!/usr/bin/env python3

from pwn import *
from time import sleep
import os

{bindings}

context.binary = {bin_name}

r2_port = 3137

rr2 = """
#!/usr/bin/rarun2
program=%s
listen=%s
"""

r2s = """
db main
dc
aa
Vpp
"""


def write_rr2(name):
    with open(name+".rr2", "w") as f:
        f.write(rr2 % (name, r2_port))
        f.close()

def write_r2s(name):
    with open(name+"-script.r2", "w") as f:
        f.write(r2s)
        f.close()

def conn():
    if args.PROC:
        return process({proc_args})
    elif args.REMOTE:
        return remote("addr", 1337)
    else:
        write_rr2(exe.file.name)
        write_r2s(exe.file.name)
        command = " ".join(["gnome-terminal -- ","radare2", "-d", exe.file.name, "-i", "%s-script.r2" % exe.file.name, "-e", "dbg.profile=%s.rr2" % exe.file.name])
        os.system(command)
        sleep(3)
        
        return remote("localhost", r2_port)


def main():
    r = conn()

    # good luck pwning :)

    r.interactive()


#if __name__ == "__main__":
main()
