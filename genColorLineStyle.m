function [color, lineStyle] = genColorLineStyle(ind)



%% available colors and line styles
colors = get(groot, 'defaultAxesColorOrder');
lineStyles = {'-'; '--'; ':'; '-.'};

%% cycle through the styles
numColors = size(colors, 1);

colorInd = mod(ind-1, numColors)+1;
lineStyleInd = floor(ind/numColors)+1;

% line style is incremented only after using all the colors
color = colors(colorInd, :);
lineStyle = lineStyles{lineStyleInd};
