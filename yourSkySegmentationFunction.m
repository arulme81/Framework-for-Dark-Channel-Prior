

function sky_mask = yourSkySegmentationFunction(input_image)
    % Convert input image to grayscale
    grayscale_image = rgb2gray(input_image);

    % Texture analysis using Gabor filter
    gabor_response = gaborFilterBank(grayscale_image);

    % Compute intensity-based mask using Otsu's method
    intensity_threshold = graythresh(grayscale_image);
    disp('intensity threshold')
    disp(intensity_threshold)
    intensity_mask = grayscale_image > intensity_threshold;

    % Sum the responses along the third dimension to get a 2D matrix
    sum_response = sum(cat(3, gabor_response{:}), 3);

    % Normalize combined_mask to be in the range [0, 1]
    combined_mask = (sum_response - min(sum_response(:))) / (max(sum_response(:)) - min(sum_response(:)));

    % Resize intensity_mask to match the size of combined_mask
    intensity_mask = imresize(intensity_mask, size(combined_mask));

    % Combine texture and intensity masks
    combined_mask = combined_mask .* intensity_mask;

    % Debugging: Print and inspect values
  

    % Adaptive thresholding using Otsu's method on the combined mask
    adaptive_threshold = graythresh(combined_mask);
   

    % Sky Mask Generation
    sky_mask = combined_mask > adaptive_threshold;
 
end




