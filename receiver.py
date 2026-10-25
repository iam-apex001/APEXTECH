import socket
import os

HOST = "0.0.0.0"
PORT = 5001

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((HOST, PORT))
server.listen(1)

print(f"Waiting for file on port {PORT}...")

conn, addr = server.accept()
print("Connected by:", addr)

filename = conn.recv(1024).decode()

with open("received_" + filename, "wb") as file:
    while True:
        data = conn.recv(4096)
        if not data:
            break
        file.write(data)

print("File received successfully!")

conn.close()
server.close()
