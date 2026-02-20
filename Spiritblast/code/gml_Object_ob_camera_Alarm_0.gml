// Try to connect to Room Factory
if rf_connected
    exit;

print("Connection attempt", rf_attempts, "/", rf_maxattempts)

// If the port ends up being something other than 7250 then this won't work
var connect = network_connect(rf_socket, "127.0.0.1", 7250)
if (connect >= 0)
{
    print("Successfully connected with Room Factory!")
    rf_serversocket = connect
    rf_connected = true
    exit;
}

if (++rf_attempts > rf_maxattempts)
{
    print("Failed to connect after", rf_attempts - 1, "attempts")
    exit;
}

alarm[0] = 20