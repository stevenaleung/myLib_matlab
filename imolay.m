function f = imolay(images, slice, range, varargin)
% create a GUI to view all frames of an image
%
% -- inputs --
% frames            image to be plotted
%                   dimensions: [X Y Z]
%
% im2               2nd image to be plotted
%                   same dimensions as frames: [X Y Z]
%                   -> use [] if do not have 2nd image
%
% range             pixel intensities to be shown. [lower upper]
% slice             starting slice to view
% varargin          {1} diplay filename on figure
%
% -- outputs --
% f                     GUI handle
%
% -- edits --
% 2014-03-13 SAL
% 2014-05-23 SAL - added input parameter 'slice'
% 2014-06-13 SAL - changed order of inputs
%                - changed 'images' to contain all images
% 2014-07-14 SAL - fixed slider start position

frames = images{1};
if length(images) == 2
    im2 = images{2};
end

% find number of frames 
numframes = size(frames, 3);

% create new GUI and name it if input is specified
f = figure;
if ~isempty(varargin)
    set(f, 'name', varargin{1}, 'numbertitle', 'off');
end

% figure axis window size
xl = [1 size(frames, 2)];
yl = [1 size(frames, 1)];

% starting slice to view
if ~exist('slice', 'var')
    viewframe = 1;
else
    viewframe = slice;
end

% creates range variable if input was not specified
if ~exist('range', 'var')
    range = [];
end

% create slider bar and set callback function
step = 1/(numframes-1);
sliderHandle = uicontrol('parent', f, 'style', 'slider', 'min', 0, ...
    'max', 1, 'sliderstep', [step, step], 'value', step*viewframe-step);
set(sliderHandle, 'callback', @sliderCallback);

% store data in the GUI 
setappdata(f, 'frames', frames);
setappdata(f, 'range', range);
setappdata(f, 'sliderHandle', sliderHandle);
setappdata(f, 'viewframe', viewframe);
setappdata(f, 'xl', xl);
setappdata(f, 'yl', yl);
if exist('im2', 'var')
    setappdata(f, 'im2', im2);
    subplot(1, 2, 1);
end

showImg(f);


% shows images given zoom and frame information
function showImg(f)
figure(f);
frames = getappdata(f, 'frames');
range = getappdata(f, 'range');
viewframe = getappdata(f, 'viewframe');
xl = getappdata(f, 'xl');
yl = getappdata(f, 'yl');
sliderHandle = getappdata(f, 'sliderHandle');

if isappdata(f, 'im2');
    im2 = getappdata(f, 'im2');
    subplot(1, 2, 2);
    if islogical(im2)
        imshow(im2(:, :, viewframe));
    else
        imshow(im2(:, :, viewframe), range);
    end
    title(['frame ' num2str(viewframe)]);
    set(gca, 'ylim', yl);
    set(gca, 'xtick', [], 'ytick', []);
    % keep the same zoom window as previous frame
    set(gca, 'xlim', xl);
    subplot(1, 2, 1);
end
imshow(frames(:, :, viewframe), range);
title(['frame ' num2str(viewframe)]);
set(gca, 'xtick', [], 'ytick', []);
% keep the same zoom window as previous frame
set(gca, 'xlim', xl);
set(gca, 'ylim', yl);

% display toolbar 
set(gcf, 'toolbar', 'figure');

% put focus on slider. can move slider with arrow buttons upon creation
uicontrol(sliderHandle);


% callback function when slider bar is moved
function sliderCallback(hObject, handles)
f = gcf;
value = get(hObject, 'value');
sliderstep = get(hObject, 'sliderstep');

% determine frame number that slider bar is set to
sliderLocation = round(value * sliderstep(1)^-1)+1;
setappdata(f, 'viewframe', sliderLocation);

% save zoom window size
xl = xlim;
yl = ylim;
setappdata(f, 'xl', xl);
setappdata(f, 'yl', yl);

% update images
showImg(f);