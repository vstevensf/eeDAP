
% Address — Server name or IP address.
% 
% Port — Server port, specified as a number between 1 and 65535, inclusive.
% 
% Connect Timeout — Allowed time in seconds to connect to the server, 
% specified as a numeric value. This parameter specifies the maximum time to
% wait for a connection request to the specified server to succeed or fail.
% 
% Transfer Delay — Allow delayed acknowledgement from server. If this 
% parameter is enabled, Nagle's algorithm is on and the client sends small 
% segments of collected data in a single packet when acknowledgement (ACK) 
% arrives from the server. If this parameter is disabled, 
% Nagle's algorithm is off and the client immediately sends data to the network.

%--------------------------------------

% t = tcpclient(address,port,Name,Value)
% t = tcpclient(address,port,Name,Value) creates a connection and sets 
% additional Properties using one or more name-value pair arguments. 
% Set the Timeout, ConnectTimeout, and EnableTransferDelay properties 
% using name-value pair arguments. Enclose each property name in quotes, 
% followed by the property value.
% 
% Example: t = tcpclient("144.212.130.17",80,"Timeout",20,"ConnectTimeout",30) 
% creates a TCP/IP client connection to the TCP/IP server on port 80 at IP 
% address 144.212.130.17. It sets the timeout period to 20 seconds and the 
% connection timeout to 30 seconds.

% client = tcpclient(server.ServerAddress,server.ServerPort,"Timeout",5);
% TODO: how to retrieve the server IP addr and port number... database?
clear;
client = tcpclient("10.168.225.227",4000);
disp(client);
pause(1);

% read data sent by the server
rawData = read(client,961,"double");
reshapedData = reshape(rawData,31,31);
surf(reshapedData);
% clear client;