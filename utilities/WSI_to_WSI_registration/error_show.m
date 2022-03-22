function error_show(ME)

% This function helps identify errors.
% ME is a Matlab Exception structure with the following fields:
%     identifier
%     message
%     cause
%     stack (array of structures)
%         file (file name where error occured)
%         name (function name where error occured)
%         line (where error occured)
%
%         The stack field of the MException object identifies the line
%         number, function, and filename where the error was detected. If
%         the error occurs in a called function, the stack field contains
%         the line number, function name, and filename not only for the
%         location of the immediate error, but also for each of the calling
%         functions.

% The developer can step back to the function where the error originated
% and have the corresponding workspace available to troubleshoot the error.

% The function should be used as follows:
%     try
%          [function content]
%
%     catch ME
%          error_show(ME);
%     end

    % creates temp array of size of the stack
    temp = size(ME.stack);

    % displays the message and error ID, cause
    desc = ['ERROR: ', ME.message];
    disp(desc);
    disp(['ME.identifier: ', ME.identifier]);
    disp(['ME.cause: ', char(ME.cause)]);

    % displays the stack calls of the error
    for iME=1:temp(1)-1
        disp([...
            'Line: ',num2str(ME.stack(iME).line),...
            ', Function: ', ME.stack(iME).name]);
    end
    
    % function call stack
    % displays the line numbers and file names of the function calls 
    % that led to the current pause condition, listed in the order in which they execute
    dbstack()

    % error dialog box
    h_errordlg = errordlg(desc,'Application error','modal');
    uiwait(h_errordlg)
    keyboard

end