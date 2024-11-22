
import SocketIO
import  UIKit

class SocketManagerHelper {
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    // Singleton pattern for easy access
    static let shared = SocketManagerHelper()
    
    private init() {
        // Default empty initializer
    }
    
    // Function to set up the socket connection with custom authentication token
    func setupSocket(withAuthToken authToken: String) {
        // Set up the connection URL for the server (without the namespace part)
        let url = URL(string: "https://devapi.heywow.app")!
        
        // Set up the socket manager with custom headers (authorization)
        manager = SocketManager(socketURL: url, config: [
            .log(true),                    // Enable logging for debugging
            .compress,                     // Enable compression to reduce message size
            .forceWebsockets(true),        // Force WebSocket instead of HTTP polling
            .extraHeaders([                // Add custom headers here
                "Authorization": "Bearer \(authToken)"
            ])
        ])
        
        // Access the socket for a specific namespace
        socket = manager.socket(forNamespace: "/socket/chat")
        
        // Handle socket connection events
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected to /socket/chat namespace")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected from /socket/chat namespace")
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("Socket error: \(data)")
        }
        
        socket.on(clientEvent: .reconnectAttempt) { data, ack in
            print("Reconnecting...")
        }

        // Handle receiving messages from the server
        socket.on("message") { data, ack in
            if let message = data[0] as? String {
                print("Received message: \(message)")
            }
        }
        
        // Start the socket connection (after setup)
        connectSocket()
    }
    
    // Function to explicitly connect the socket after setup
    private func connectSocket() {
        // Connect the socket
        socket.connect()
    }

    // Function to emit messages to the server
    func sendMessage(_ message: String) {
        socket.emit("sendMessage", ["message": message])
    }
    
    // Function to disconnect the socket (if needed)
    func disconnectSocket() {
        socket.disconnect()
    }
}
