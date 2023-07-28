function b = getBorderImage(x)
    % Returns the image of the contour from the letter reversed binary 
    % image x

    % Opening transform
    se = strel('disk', 2);
    x_open = imopen(x, se);
    
    % Find contour
    se = strel('disk', 1);
    x_eroded = imerode(x_open, se);
    b = x_open - x_eroded;
    b = bwmorph(b, 'thin', Inf);
end