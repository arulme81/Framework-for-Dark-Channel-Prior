function gabor_response = gaborFilterBank(image)
    % Create a Gabor filter bank and apply filters to the image
    orientations = [0, 45, 90, 135];  
    scales = [4, 8, 12];  
    gabor_response = cell(numel(orientations), numel(scales));

    for i = 1:numel(orientations)
        for j = 1:numel(scales)
            wavelength = scales(j);
            orientation = orientations(i);
            
            % Create a Gabor filter
            gabor_filter = gabor(wavelength, orientation);
            
            % Apply the Gabor filter to the image
            gabor_response{i, j} = abs(imgaborfilt(image, gabor_filter));
        end
    end
    
end

