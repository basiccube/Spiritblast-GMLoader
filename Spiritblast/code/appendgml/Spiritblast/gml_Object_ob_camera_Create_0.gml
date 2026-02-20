rf_socket = -4
rf_serversocket = -4
rf_connected = false
rf_attempts = 1
rf_maxattempts = 5

rf_startConnection = function()
{
    if (alarm[0] >= 0)
        exit;
    
    if rf_connected
    {
        print("Already connected to Room Factory!")
        exit;
    }

    print("Attemping connection with Room Factory...")
    if (rf_socket < 0)
        rf_socket = network_create_socket(network_socket_tcp)
    
    if (rf_socket >= 0)
    {
        rf_attempts = 1
        alarm[0] = 5
    }
    else
        print("Failed to create socket!")
}

rf_stopConnection = function()
{
    if !rf_connected
    {
        print("Not currently connected to Room Factory.")
        exit;
    }

    print("Stopping connection")
    rf_connected = false

    if (rf_socket >= 0)
    {
        network_destroy(rf_socket)
        rf_socket = -4
    }

    if (rf_serversocket >= 0)
    {
        network_destroy(rf_serversocket)
        rf_serversocket = -4
    }
}