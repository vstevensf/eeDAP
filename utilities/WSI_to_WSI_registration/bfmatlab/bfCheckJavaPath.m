function [status, version] = bfCheckJavaPath(varargin)
% bfCheckJavaPath check Bio-Formats is included in the Java class path
%
% SYNOPSIS  bfCheckJavaPath()
%           status = bfCheckJavaPath(autoloadBioFormats)
%           [status, version] = bfCheckJavaPath()
%
% Input
%
%    autoloadBioFormats - Optional. A boolean specifying the action to take
%    if no Bio-Formats JAR file is in the Java class path. If true, looks
%    for and adds a Bio-Formats JAR file to the dynamic Java path.
%    Default - true
%
% Output
%
%    status - Boolean. True if a Bio-Formats JAR file is in the Java class
%    path.
%
%
%    version - String specifying the current version of Bio-Formats if
%    a Bio-Formats JAR file is in the Java class path. Empty string else.

% OME Bio-Formats package for reading and converting biological file formats.
%
% Copyright (C) 2012 - 2015 Open Microscopy Environment:
%   - Board of Regents of the University of Wisconsin-Madison
%   - Glencoe Software, Inc.
%   - University of Dundee
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 2 of the
% License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

% Input check
ip = inputParser;
ip.addOptional('autoloadBioFormats', true, @isscalar);
ip.parse(varargin{:});

% Check if a Bio-Formats JAR file is in the Java class path
% Can be in either static or dynamic Java class path
jPath = javaclasspath('-all');
bfJarFiles = {'bioformats_package.jar', 'loci_tools.jar'};
% numel = number of array elements
hasBFJar =  false(numel(bfJarFiles), 1);  % creates array of 0s
for i = 1: numel(bfJarFiles);
    isBFJar =  @(x) ~isempty(regexp(x, ['.*' bfJarFiles{i} '$'], 'once'));
    hasBFJar(i) = any(cellfun(isBFJar, jPath));
end

% Check conflicting JARs are not loaded
status = any(hasBFJar);
if all(hasBFJar),
    warning('bf:jarConflict', ['Multiple Bio-Formats JAR files  found'...
        'in the Java class path. Please check.'])
end

if ~status && ip.Results.autoloadBioFormats,
    jarPath = getJarPath(bfJarFiles);
    assert(~isempty(jarPath), 'bf:jarNotFound',...
        'Cannot automatically locate a Bio-Formats JAR file');

    % Add the Bio-Formats JAR file to dynamic Java class path
    javaaddpath(jarPath);
    status = true;
end

if status
    % Read Bio-Formats version
    % is_octave() definition in eeDAP/src/bfmatlab/private/is_octave.m
    if is_octave()
        version = char(java_get('loci.formats.FormatTools', 'VERSION'));
    else
        version = char(loci.formats.FormatTools.VERSION);
    end
else
    version = '';
end

function path = getJarPath(files)


% Assume the jar is either in the Matlab path or under the same folder as
% this file
for i = 1 : numel(files)
    path = which(files{i}); % displays full pathname
    if isempty(path)
        % mfilename returns a character vector containing the file name of the file in which the function call occurs

        % [filepath,name,ext] = fileparts(filename) returns the path name, file name, and extension for the specified file.
        % fileparts only parses the specified filename. It does not verify that the file exists.
        
        % fullfile builds a full file specification from the specified folder and file names
        path = fullfile(fileparts(mfilename('fullpath')), files{i});
    end
    if ~isempty(path) && exist(path, 'file') == 2
        return
    end
end
