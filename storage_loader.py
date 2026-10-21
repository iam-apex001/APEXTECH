import secrets
import os
import time
x = secrets.token_hex(10_000_000)
folder = "/storage/emulated/0/BUG"
print("...bug started...")
i = 0
start = time.time()
try :
    while True:
        i += 1
        os.makedirs(folder, exist_ok = True)
        with open(f"{folder}/myfile{i}.txt", "w") as f:
            f.write(x)
except KeyboardInterrupt:
    print("bug ended due to keyboard interruption")
end = time.time()
print(f"Time run : {end - start:.2f} seconds")