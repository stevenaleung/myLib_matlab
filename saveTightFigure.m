function saveTightFigure(h, outfilename)
% SAVETIGHTFIGURE(OUTFILENAME) Saves the current figure without the white
%   space/margin around it to the file OUTFILENAME. Output file type is
%   determined by the extension of OUTFILENAME. All formats that are
%   supported by MATLAB's "saveas" are supported. 
%
%   SAVETIGHTFIGURE(H, OUTFILENAME) Saves the figure with handle H. 
%
% E Akbas (c) Aug 2010
% * Updated to handle subplots and multiple axes. March 2014. 
%
% -- edits --
% 2015-08-06 SAL    - create tighter figures if axes labels don't exist


%% find all the axes in the figure
haxes = findall(h, 'type', 'axes');

%% compute the tightest box that includes all axes
tightestBox = [Inf Inf -Inf -Inf]; % left bottom right top
for i=1:length(haxes)
    set(haxes(i), 'units', 'centimeters');
    
    % http://www.mathworks.com/help/matlab/creating_plots/automatic-axes-resize.html
    p = get(haxes(i), 'position');
    ti = get(haxes(i), 'tightinset'); % margins in [left bottom right top] direction
    
    adjustPos = [0 0 0 0];
    if ~isempty(get(get(haxes(i), 'xlabel'), 'string')) || ~isempty(get(haxes(i), 'xtick'))
        adjustPos(1) = -ti(1);
        adjustPos(3) = ti(3);
    end
    if ~isempty(get(get(haxes(i), 'ylabel'), 'string')) || ~isempty(get(haxes(i), 'ytick'))
        adjustPos(2) = -ti(2);
        adjustPos(4) = ti(4);
    end
    if strcmp(get(haxes(i),'tag'), 'Colorbar')
        adjustPos(3) = ti(3);
    end
    % sidenote: image left/bottom position changes when add colorbar, but
    % position property does not update to reflect new position
    if ~isempty(get(get(haxes(i), 'title'), 'string'))
        adjustPos(4) = ti(4);
    end
    
    % get position as left, bottom, right, top
    pos = [p(1) p(2) p(1)+p(3) p(2)+p(4)] + adjustPos;
    
    tightestBox(1) = min(tightestBox(1), pos(1));
    tightestBox(2) = min(tightestBox(2), pos(2));
    tightestBox(3) = max(tightestBox(3), pos(3));
    tightestBox(4) = max(tightestBox(4), pos(4));
end

%% move all axes to bottom-left of figure
for i=1:length(haxes)
    if strcmp(get(haxes(i),'tag'), 'legend')
        continue
    end
    p = get(haxes(i), 'position');
    set(haxes(i), 'position', [p(1)-tightestBox(1) p(2)-tightestBox(2) p(3) p(4)]);
end

%% resize figure to fit tightly
set(h, 'units', 'centimeters');
p = get(h, 'position');

width = tightestBox(3)-tightestBox(1);
height =  tightestBox(4)-tightestBox(2); 
set(h, 'position', [p(1) p(2) width height]); % only need to change width and height

%% set papersize
% saveas will still add white space around figure unless paper size is adjusted
set(h,'PaperUnits','centimeters');
set(h,'PaperSize', [width height]);
set(h,'PaperPositionMode', 'manual');
set(h,'PaperPosition',[0 0 width height]);

%% save
% default to png if file extention not specified
[~, name, ext] = fileparts(outfilename);
if isempty(ext)
    outfilename = strcat(name, '.png');
end
saveas(h, outfilename);
