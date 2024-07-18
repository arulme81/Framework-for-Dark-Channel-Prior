clc
close all 
[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick an Image File');

image = imread([pathname,filename]);

% function dynamicScales = chooseDynamicScales(image)
  
    % For example, you can use edge detection, texture analysis, or other methods

    % Compute a measure of image complexity
    complexityMeasure = computeComplexityMeasure(image);

    % Define a rule to dynamically select scales based on the complexity measure
    if complexityMeasure < 0.5
        dynamicScales = [2, 4, 6];  % Low complexity, use small scales
    else
        dynamicScales = [8, 12, 16];  % High complexity, use larger scales
    end
% end