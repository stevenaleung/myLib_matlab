function excludeFromLegend(h)
% exclude the data associated with handle h from the legend entries

set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
