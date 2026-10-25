import socket
import os

SERVER_IP = "192.168.1.10"   # Change this to receiver's IP address
PORT = 5001

filename = "test.jpg"

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((SERVER_IP, PORT))

client.send(filename.encode())

with open(filename, "rb") as file:
    while True:
        data = file.read(4096)
        if not data:
            break
        client.send(data)

print("File sent successfully!")

client.close()
