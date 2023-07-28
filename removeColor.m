function output_img = removeColor(img)
    % Remove any colored pixels from the image if any

    % extract red, green, and blue channels
    red_Channel = img(:, :, 1);
    green_Channel = img(:, :, 2);
    blue_Channel = img(:, :, 3);
    
    red_pixels = red_Channel > green_Channel & red_Channel > blue_Channel;
    blue_pixels = blue_Channel > green_Channel & blue_Channel > red_Channel;
    green_pixels = green_Channel > blue_Channel & green_Channel > red_Channel;
    
    img(repmat(red_pixels, [1 1 3])) = 255;
    img(repmat(blue_pixels, [1 1 3])) = 255;
    %img(repmat(green_pixels, [1 1 3])) = 255;
    
    output_img = img;
end
