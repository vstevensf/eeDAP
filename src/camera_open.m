% first called from function StartTheTestButtonPressed(hObject, eventdata, handles)
% within src/Administrator_Input_Screen.m
% also called within src/GUI.m, src/Stage_Allighment.m,...
% utilities/Camera_stage_review/Camera_stage_review.m, utilities/Camera_stage_review/camera_open.m
function cam=camera_open(cam_kind,cam_format,defaultR,defaultB)
% returns a structure populated with info based on the camera type
% this is saved in the MyData structure described in Administrator_Input_Screen.m and GUI.m
try

    % the following are from Matlab's image acquisition toolbox

    % imaqtool: launches an interactive GUI to allow you to explore,
    %   configure, and acquire data from your installed and supported image
    %   acquisition devices
    
    % imaqhwinfo: a structure that contains information about the image
    %   acquisition adaptors available on the system. An adaptor is the
    %   interface between MATLAB� and the image acquisition devices
    %   connected to the system. The adaptor's main purpose is to pass
    %   information between MATLAB and an image acquisition device via its
    %   driver.

    % imaqhwinfo(adaptorname): returns out, a structure that contains
    %   information about the adaptor specified by the text string
    %   adaptorname. The information returned includes adaptor version and
    %   available hardware for the specified adaptor.

    % imaqfind: matlab function to find image acquisition objects

    % http://www.mathworks.com/help/imaq/configuring-image-acquisition-object-properties.html
    
    % delete any currently running (stale) video inputs
    objects = imaqfind;
    delete(objects);
    % if type of camera is USB
    if strcmp( cam_kind,'USB')
       cam_adaptor = 'pointgrey';
    % if the camera is connected by Firewire (an Apple version of IEEE 1394 interface that allows high-speed data transferring between devices)
    elseif strcmp( cam_kind,'Firewire')
       cam_adaptor = 'dcam';
    end

    % Create the video object to communicate with the camera 
    % this is the live display of what's in the "camera's eye" on the computer screen
    % checks if "cam_format" is an existing variable in the workspace (return = 1 if exists)
    % cam_format is a variable defined in the dapsi file
    if exist('cam_format','var')
        % A videoinput object represents a connection between MATLAB® and a particular image acquisition device.
        % vid = videoinput(adaptor,deviceID,format)
        % vid = videoinput(adaptor,deviceID,format) creates a video input object vid, 
        % where format is a character vector that specifies a particular video format supported 
        % by the device or the full path of a device configuration file (also known as a camera file). 
        % To get a list of the formats supported by a particular device, view the DeviceInfo structure for the device 
        % that is returned by imaqhwinfo. Each DeviceInfo structure contains a SupportedFormats field. 
        % If format is not specified, the device's default format is used. 
        % When the video input object is created, its VideoFormat property contains the format name or device configuration file that you specify.
        cam = videoinput(cam_adaptor,1,cam_format) %#ok<NOPRT>
    else
        % vid = videoinput(adaptor,deviceID)
        % creates a video input object vid, where deviceID is a numeric scalar value that identifies a particular device available 
        % through the specified adaptor, adaptor. Use imaqhwinfo(adaptor) to determine the devices available through the specified adaptor. 
        % If deviceID is not specified, the first available device ID is used. You can also use a device's name in place of deviceID. 
        % If multiple devices have the same name, the first available device is used.
        cam = videoinput(cam_adaptor,1) %#ok<NOPRT>
    end

    imaqhwinfo(cam)
    % This example returns information about all the devices accessible through a particular adaptor.
    % info = imaqhwinfo('winvideo')
    % info = 
    %     AdaptorDllName: [1x73 char]
    %     AdaptorDllVersion: '2.1 (R2007a)'
    %     AdaptorName: 'winvideo'
    %     DeviceIDs: {[1]}
    %     DeviceInfo: [1x1 struct]

    % adding more attributes to the struct with info about this type of camera adaptor (USB vs Firewire)
    cam.Tag = 'Microscope Camera Object';
    cam.TriggerRepeat = 0;
    cam.FramesPerTrigger = 10;
    cam.FrameGrabInterval = 1;
    dim = cam.VideoResolution;
    
    % Camera iamge must be at least 640 x 480
    if dim(1) < 640 || dim(2) < 480
        desc = 'Camera image must be at least 640x480' %#ok<NOPRT>
        h_errordlg = errordlg(desc,'Insufficient Camera Size','modal');
        uiwait(h_errordlg)
        close all force
    end

    % Camera image must be rgb
    if ~strcmp(cam.ReturnedColorSpace,'rgb');
        desc = 'Camera image must be rgb' %#ok<NOPRT>
        h_errordlg = errordlg(desc,'Insufficient Camera Size','modal');
        uiwait(h_errordlg)
        close all force
    end
    
    % Set value of a video source object property.
    cam_src = getselectedsource(cam); % Return currently selected video source object
    cam_src.Tag = 'Microscope Camera Source';
    if strcmp( cam_kind,'USB')
       cam_src.WhiteBalanceRBMode = 'Off';
%        defaultR = 587;
%        defaultB = 710;
       cam_src.WhiteBalanceRB = [defaultR defaultB];
%        colorDone = 0;
%        waitingBar = waitbar (0.5,'Adjusting color');
%        while colorDone == 0 
%            img=camera_take_image(cam);
%            [x,y,z] = size(img);
%            R = mean(mean((img((ceil(x/2)-10:ceil(x/2)+10),(ceil(y/2)-10:ceil(y/2)+10),1))));
%            G = mean(mean((img((ceil(x/2)-10:ceil(x/2)+10),(ceil(y/2)-10:ceil(y/2)+10),2))));
%            B = mean(mean((img((ceil(x/2)-10:ceil(x/2)+10),(ceil(y/2)-10:ceil(y/2)+10),3))));
%            if abs(R-G)>5 || abs(B-G)>5 || abs(R-B)>5
%                defaultR = log2(G/R) * 256 + defaultR;
%                defaultB = log2(G/B) * 256 + defaultB;
%                cam_src.WhiteBalanceRB = [defaultR defaultB];
%            else
%                colorDone = 1;
%                close(waitingBar);
%            end
%        end
       
    end
catch ME
    error_show(ME)
end
end