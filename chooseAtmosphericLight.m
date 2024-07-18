
function atmospheric_light = chooseAtmosphericLight(region)
    [rows, cols, ~] = size(region);
    reshaped_region = double(reshape(region, rows * cols, 3));

    % Repeat the white color vector to match the size of reshaped_region
    white_color = repmat([255, 255, 255], rows * cols, 1);

    % Calculate the Euclidean distance to white color [255, 255, 255]
    distance_to_white = sqrt(sum((reshaped_region - white_color).^2, 2));

    % Find the index of the pixel with the minimum distance
    [~, min_idx] = min(distance_to_white);

    % Choose the atmospheric light based on the minimum distance
    atmospheric_light = reshaped_region(min_idx, :);
    
end

