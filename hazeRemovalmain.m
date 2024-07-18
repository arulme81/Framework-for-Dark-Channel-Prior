clc
close all 
[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick an Image File');

input_image = imread([pathname,filename]);
    input_image = double(input_image) / 255;
threshold = 50;

    % Step 1: Divide the image into four equal rectangular regions
    [rows, cols, ~] = size(input_image);
    regions = cell(2, 2);

    for i = 1:2
        for j = 1:2
            start_row = floor((i - 1) * rows / 2) + 1;
            end_row = floor(i * rows / 2);
            start_col = floor((j - 1) * cols / 2) + 1;
            end_col = floor(j * cols / 2);

            regions{i, j} = input_image(start_row:end_row, start_col:end_col, :);
          
        end
          
    end

    % Initialize variables for atmospheric light and selected region
    % atmospheric_light = [255, 255, 255];  % Initialize with white color
    selected_region = input_image;
  
    % Step 5: Repeat this process until the size of the selected region is smaller than the pre-specified threshold
    while size(selected_region, 1) > threshold && size(selected_region, 2) > threshold 
        % Step 2: Find out the average pixel values separated by the standard deviation of the pixel values within the region
        scores = zeros(2, 2);

        for i = 1:2
            for j = 1:2
                region = regions{i, j};
%                   region = selected_region{i, j};
                scores(i, j) = mean(region(:)) / std(double(region(:)));
                   
            end
        end

        % Step 3: Select the region with the highest score
        [max_score, max_idx] = max(scores(:));
        [max_row, max_col] = ind2sub(size(scores), max_idx);



    % Debug print the size of selected_region
    disp(['Selected Region Size: ', num2str(size(selected_region, 1)), ' x ', num2str(size(selected_region, 2))]);

        % Step 4: Again divide the highest score region into four equal regions
        sub_regions = cell(2, 2);
       

        for i = 1:2
            for j = 1:2
                sub_rows = floor(size(regions{max_row, max_col}, 1) / 2);
                sub_cols = floor (size(regions{max_row, max_col}, 2) / 2);
                start_row = floor((i - 1) * sub_rows) + 1;
                end_row = floor(i * sub_rows);
                start_col = floor((j - 1) * sub_cols) + 1;
                end_col = floor(j * sub_cols);
               
                sub_regions{i, j} = regions{max_row, max_col}(start_row:end_row, start_col:end_col, :);
              
                 
            end
        end
       
        
       


        % Step 6: Within the selected region, choose the color vector minimizing the distance to (255,255,255)
%         atmospheric_light = chooseAtmosphericLight(sub_regions{max_row, max_col});
        
        % Update selected region for the next iteration
         selected_region = sub_regions{max_row, max_col};
%          disp('atmospheric_light');

%          disp(atmospheric_light);
%          figure (1)
%         subplot(1,2,2)
%         imshow(selected_region)
%         title('selected_region4')
%          
        disp('selected_region 4');
        disp(size(selected_region));
%         
[rows1, cols1, ~] = size(selected_region); 
          
          for i = 1:2
                for j = 1:2
                    start_row1 = floor((i - 1) * rows1 / 2) + 1;
                    end_row1 = floor(i * rows1 / 2);
                    start_col1 = floor((j - 1) * cols1 / 2) + 1;
                    end_col1 = floor(j * cols1 / 2);

                    regions{i, j} = selected_region(start_row1:end_row1, start_col1:end_col1, :);              
                      
                end

           end



    end
    atmospheric_light = chooseAtmosphericLight(selected_region);
%         atmospheric_light = [255,255,255];
        disp('atmospheric_light');
         disp(atmospheric_light);

    % Step 8: Segment the haze image into sky and non-sky region using a filter
    sky_mask = yourSkySegmentationFunction(input_image);

    disp('Size of input_image:');
disp(size(input_image));
disp('Size of sky_mask:');
disp(size(sky_mask));
disp('Size of input_image(~sky_mask, :, :):');
disp(size(~sky_mask));
    
    
    
    % Step 9: Find out dark channel prior and black channel prior
%      dark_channel_non_sky = darkChannelPrior(input_image(~sky_mask, :));
% dark_channel_non_sky = darkChannelPrior(input_image(~sky_mask, :, :));
    % dark_channel_non_sky = darkChannelPrior(input_image,(~sky_mask));
    dark_channel_non_sky = darkChannelPrior(input_image,~sky_mask);
    
    
    dark_channel_sky = darkChannelPrior(input_image, sky_mask);
    

    
    
    % Step 10: Find out transmission map of the non-sky region by dark channel prior and sky region by bright channel prior
transmission_map_non_sky =1 - (0.95 * dark_channel_non_sky);  % Adjust the parameter

transmission_map_sky =1 - (0.95 * calculateBrightChannelPrior(input_image)); 


% transmission_map_sky = calculateBrightChannelPrior(input_image);
% Implement a function to find bright channel prior for sky


  
    
%  transmission_map_non_sky = max(transmission_map_non_sky, 0.001);

    % Combine transmission maps
       
    transmission_map = zeros(size(input_image, 1), size(input_image, 2));
    
   
    transmission_map(~sky_mask) = transmission_map_non_sky(~sky_mask);
    transmission_map(sky_mask) = transmission_map_sky(sky_mask);
%     transmission_map(~sky_mask) = transmission_map_non_sky(1:numel(find(~sky_mask)));
% Debug Info
disp('Debug Info:');
disp(['Sky Mask Size: ', num2str(size(sky_mask))]);
disp(['Transmission Map Sky Size: ', num2str(size(transmission_map_sky))]);
disp(['Transmission Map Non-Sky Size: ', num2str(size(transmission_map_non_sky))]);
disp(['Transmission Map Size: ', num2str(size(transmission_map))]);
   
% transmission_map=uint8(transmission_map);    

    % Step 11: Using the atmospheric light and transmission map, find out the dehaze image
    dehazed_image = zeros(size(input_image));

    for i = 1:3
        dehazed_image(:, :, i) = (input_image(:, :, i) - atmospheric_light(i)) ./ transmission_map_sky + atmospheric_light(i);
%           dehazed_image(:, :, i) = double(input_image(:, :, i) - atmospheric_light(i)) ./ transmission_map_sky + atmospheric_light(i);
          % dehazed_image(:, :, i) = double(input_image(:, :, i) - atmospheric_light) ./ max(transmission_map, 0.1) + atmospheric_light;
    end

   
% dehazed_image=im2uint8(dehazed_image);
dehazed_image = uint8(dehazed_image * 255);
figure (1)
subplot(2,2,1)
imshow(transmission_map_non_sky)
title('transmission map non sky')
subplot(2,2,2)
imshow(transmission_map_sky)
title('transmission map sky')
subplot(2,2,3)
imshow(input_image)
title('input_image')
subplot(2,2,4)
imshow(dehazed_image)
title('Dehaze')

figure(2)
imshow(input_image)

figure(3)
imshow(dehazed_image)

