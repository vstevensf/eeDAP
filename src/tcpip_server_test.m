% server side accepting an array of ten integers
% to test TCP IP connection between a client and server computer
% run this script on the server computer reading data

% TODO: ipv4 vs ipv6 vs local IP

% % you can use the following to extract more information
% % about the local Windows IP configuration
% [~, result] = system('ipconfig');
% disp(result)
% % regex from https://www.mathworks.com/matlabcentral/fileexchange/63737-get-computer-mac-address
% % this finds the address (IPV4) -- but simpler version starting line 27
% [start_index, end_index] = regexp(result, 'IPv4 Address.*?:\s*((?:\d{1,3}\.){3}\d{1,3})');
% ipv4_total = extractBetween(result, start_index, end_index)
% % ipv4 contains the IPv4 address of the current (server) computer
% [ipv4, ~] = regexp(ipv4_total, '((?:\d{1,3}\.){3}\d{1,3})', 'match', 'split')
% % celldisp(ipv4)
% % disp(string(ipv4))
% ipv4 = string(ipv4)
% disp(ipv4)
% % gets the address resolution protocol of current (server) computer
% % [status, result] = system('arp -a')

% https://www.mathworks.com/help/instrument/communicate-between-a-tcpip-client-and-server-in-matlab.html


clear;
% find hostname and address
[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
address = resolvehost(hostname,"address");
disp(hostname);
disp(address);

% IP accress identifies the computer
% network port identifies the application or service running on the
% computer
% IP addr + port number = socket

% create the server
% using address and port 4000
% callback function = connectionFcn -- writes data when a TCP/IP client
% connects to the server
% clear server;

server = tcpserver(address,4000,"ConnectionChangedFcn",@connectionFcn);


% callback function that reads data each time the specified bytes of data
% are available; store read data in the UserData property of tcpserver
% object
% in this case, triggers each time 7688 bytes of data are received
configureCallback(server,"byte",7688,@readDataFcn);

disp(server);

% connection callback function to write binary data
function connectionFcn(src, ~)
    if src.Connected
        disp("Client connection accepted by server.")
        data = membrane(1);
        write(src,data(:),"double");
    end
end

% data available callback function to read BytesAvailableFcnCount # of
% bytes of data
function readDataFcn(src, ~)
    disp("Data was received from the client.")
    src.UserData = read(src,src.BytesAvailableFcnCount/8,"double");
    disp(src.UserData);
    reshapedServerData = reshape(src.UserData,31,31);
    surf(reshapedServerData);
end

