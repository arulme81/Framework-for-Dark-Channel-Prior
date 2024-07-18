

function dark_channel = darkChannelPrior(image, mask)
    narginchk(1, 2);

    if nargin == 1
        % Input is an image (single channel or RGB)
        if size(image, 3) == 3
            % If RGB image, calculate the dark channel across all channels
            dark_channel = min(image, [], 3);
        else
            % If a single channel image, the dark channel is the same channel
            dark_channel = image;
        end
    else
        % Input is an image and a mask
        if size(image, 3) ~= 3
            error('Input image must be an RGB image.');
        end

        if ~isequal(size(image(:,:,1)), size(mask))
            error('Image and mask dimensions must match.');
        end

        % Convert the mask to a logical array
%         mask = logical(mask);

        % Apply the mask to each channel using logical indexing
        channel1 = image(:,:,1);
        channel2 = image(:,:,2);
        channel3 = image(:,:,3);

        channel1(mask) = 0;
        channel2(mask) = 0;
        channel3(mask) = 0;

        % Combine the three channels into an RGB image
        region = cat(3, channel1, channel2, channel3);

        % Calculate the dark channel across all channels within the masked region
        dark_channel = min(region, [], 3);
    end
end