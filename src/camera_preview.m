% called in src/Administrator_Input_Screen.m, src/GUI.m, src/Stage_Allighment.m
function hFig = camera_preview(vid, settings)
%--------------------------------------------------------------------------
% Preview the view of the camera and display to the user
%--------------------------------------------------------------------------
try
    
    % Get properties of the camera image
    % get(req,PropertyName) returns value of a specific property. 
    % Use a cell array of property names to return a cell array with multiple property values.

    % vid is struct with information about the camera + video display of microscope view

    % number of color bands
    nBands = get(vid, 'NumberOfBands');
    % equivalent to width and height of video resolution
    vidRes = get(vid, 'VideoResolution'); 

    % image width and height
    imWidth = vidRes(1);
    imHeight = vidRes(2);

    % Create a figure window. This example turns off the default
    % toolbar and menubar in the figure.
    hFig = figure('Toolbar','none',...
        'Menubar', 'none',...
        'NumberTitle','Off',...
        'Name','Preview with cross hairs',...
        'Units','pixels',...
        'Position',[0,0,imWidth,imHeight]);

    % Create an image in the figure and get the handle
    hImage = image( uint8(zeros(imHeight, imWidth, nBands) ));

    % gca = current axes --> set to 0
    set(gca, 'Units', 'pixels', 'Position', [0, 0, imWidth, imHeight]);

    % Attach the settings structure to the image
    set(hImage, 'UserData', settings)
    
    % Set up the update preview window function.
    setappdata(hImage,'UpdatePreviewWindowFcn',@preview_with_cross);
    
    % preview(obj,himage) displays live video data for video input object obj in the image object specified by the handle himage. 
    % preview scales the image data to fill the entire area of the image object but does not modify the values of any image object properties.
    preview(vid, hImage);
    
catch ME
    show_error(ME)
end

end

function preview_with_cross(obj, event, himage)
try
    % Example update preview window function.
    
    % obj = Handle to the video input object being previewed
    % event = A data structure containing the following fields:
    %    Data = Current image frame specified as an H-by-W-by-B array,
    %           where H is the image height and W is the image width, as
    %           specified in the ROIPosition property, and B is the number
    %           of color bands, as specified in the NumberOfBands property
    %    Resolution = Text string specifying the current image width and
    %           height, as defined by the ROIPosition property
    %    Status = String describing the status of the video input object
    %    Timestamp = String specifying the time associated with the current
    %           image frame, in the format hh:mm:ss:ms
    % himage = Handle to the image object in which the data is to be displayed

    % The image is stored in event.Data
    temp_image = event.Data;
    % myData.settings is stored in himage property UserData
    settings = get(himage, 'UserData');
    % The camera mask is stored in settings.cam_mask
    temp_image = reticle_apply_mask(temp_image, settings.cam_mask);
    
    % Display image data.
    set(himage, 'CDataMapping','direct');
    set(himage, 'CData', temp_image);
    
catch ME
    error_show(ME)
end


end