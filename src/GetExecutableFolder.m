% this function is used in Administrator_Input_screen.m and within camera stage review
function [executableFolder] = GetExecutableFolder() 
try
    if isdeployed 
			% User is running an executable in standalone mode. 
            % calls upon OS to run "set PATH" as environment when downloaded eeDAP.exe file
			[status, result] = system('set PATH');

            % match regex case insensitive
			executableFolder = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
% 			fprintf(1, '\nIn function GetExecutableFolder(), currentWorkingDirectory = %s\n', executableFolder);
    else
			% User is running an m-file from the MATLAB integrated development environment (regular MATLAB).
			executableFolder = pwd; 
    end
% MException object: includes stack trace information and error message
catch ME
     errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
                ME.stack(1).name, ME.stack(1).line, ME.message);

    % blocks execution and creates warning dialog box
     uiwait(warndlg(errorMessage));
end
return;
end
