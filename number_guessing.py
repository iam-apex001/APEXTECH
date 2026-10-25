import random
import shutil
import subprocess   
subprocess.run(["clear"])
randnum = random.randrange(1,101)
YELLOW = "\033[93m"
RESET = "\033[0m"
GREEN = "\033[92m"


text = """__Welcome to APEX number guessing game___
Enter to continue"""

width = shutil.get_terminal_size().columns

for line in text.splitlines():
        print(YELLOW + line.center(width) + RESET)
input("    ~ ")
print('''
    [*] Enter S to Start
    [*] Enter Q to quit 
 ''')

def run():
     print('''
     My number is __ can you guess that number?
       ''')
     ask = True
     count = 0
     while ask :
          userguess =int(input('    ~ '))
          count += 1
          if userguess > randnum :
               print("    ~ Too high")
          elif userguess < randnum :
                print("    ~ Too low")
          else :
                print(GREEN + "    ~ Correct the answer is " + str(randnum) + " it took you " + str(count) + " attempts")
                break
                
          

startup_inp = input("    ~ ").upper()
if startup_inp == "S":
    run()
elif startup_inp == "Q":
    print("program closed")
