function saveTightFigure(h, outfilename)
% saveTightFigure 
%   Saves the current figure without the white space/margin around it to the
%   file OUTFILENAME. Output file type is determined by the extension of
%   OUTFILENAME. All formats that are supported by MATLAB's "saveas" are
%   supported.
%   http://www.mathworks.com/help/matlab/creating_plots/automatic-axes-resize.html
%
% -- edits --
% 2010-08    E Akbas    created
% 2014-03    E Akbas    updated to handle subplots and multiple axes
% 2015-08-06 SAL        create tighter figures if axes labels don't exist
% 2015-12-26 SAL        refactored function

h = tightFig(h);

%% save
% default to png if file extention not specified
[~, ~, ext] = fileparts(outfilename);
if isempty(ext)
    outfilename = strcat(outfilename, '.png');
end
saveas(h, outfilename);

