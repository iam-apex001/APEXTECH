from neonize.client import NewClient
from neonize.events import ConnectedEv, PairStatusEv
from time import sleep
import threading

PHONE = "2347043267307" # Your number, no '+' sign
SESSION_FILE = "bot_session.sqlite3"

client = NewClient(SESSION_FILE)

@client.event(ConnectedEv)
def on_connected(client, event):
    print("✅ Bot connected successfully!")

@client.event(PairStatusEv)
def on_pair(client, event):
    print("📱 Paired successfully!")

if __name__ == "__main__":
    # 1. Start the client in a background thread
    threading.Thread(target=client.connect, daemon=True).start()

    # 2. Try to get the pairing code, with a retry loop
    print("⏳ Waiting for client to initialize...")
    for attempt in range(10):
        sleep(3) # Wait 3 seconds before trying
        try:
            print("Attempting to generate pairing code...")
            pairing_code = client.PairPhone(PHONE, show_push_notification=True)
            print(f"📱 Your 8-digit pairing code is: {pairing_code}")
            break # Exit the loop once successful
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: {e}. Retrying...")

    # Keep the script running
    while True:
        sleep(1)