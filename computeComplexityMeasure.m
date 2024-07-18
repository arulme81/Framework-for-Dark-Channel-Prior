function complexityMeasure = computeComplexityMeasure(image)
    % Compute a complexity measure based on edge detection

    % Convert the image to grayscale if it's an RGB image
    if size(image, 3) == 3
        grayscaleImage = rgb2gray(image);
    else
        grayscaleImage = image;
    end

    % Apply the Sobel operator for edge detection
    edges = edge(grayscaleImage, 'Sobel');

    % Compute the percentage of edge pixels in the image
    edgePercentage = sum(edges(:)) / numel(edges);

    % Normalize the edge percentage to be between 0 and 1
    complexityMeasure = edgePercentage;

    % You can customize this function based on your specific requirements
end