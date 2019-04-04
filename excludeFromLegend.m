function excludeFromLegend(h, varargin)
% exclude plots from the legend entries


% default behavior is to exclude all plots in handles array
inds = 1:length(h);

% do not exclude handles that have exceptions
if length(varargin)==2
    if strfind(lower(varargin{1}), 'except')
        inds(varargin{2}) = [];
    end
end

% exclude the plots from the legend
for i = inds
    set(get(get(h(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end 
