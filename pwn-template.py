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
        r2_command = f"radare2 -i {exe.file.name}-script.r2 -r {exe.file.name}.rr2 -d {exe.file.name}"
        if args.TMUX or "PWN_TMUX" in os.environ:
            # open in new tmux pane
            command = f"tmux splitw -h -F '#{{pane_pid}}' -P '{r2_command}'"
        else:
            # open in new window
            command = f"gnome-terminal -- {r2_command}"
        os.system(command)
        sleep(2) # Wait for r2 to start up so we can connect
        
        return remote("localhost", r2_port)


def main():
    r = conn()

    # good luck pwning :)

    r.interactive()


if __name__ == "__main__":
    main()

