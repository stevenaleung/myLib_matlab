function createDir(dirPath)

% createDir
%   Create a directory if it does not exist
%
% -- inputs --
% dirPath           path of the target directory
%
% -- edit history --
% SAL 2015-08-22    created

if ~exist(dirPath, 'dir')
    mkdir(dirPath);
end
