function c = getContour(x)
    % Returns the contour descriptor of a reverse binary image letter x
    
    b_im = getBorderImage(x);
    
    %figure
    %imshow(b_im);
    
    % find contour until no other border found
    b = {};
    [b, found_start] = getMooresBorder(b_im, b);

    while found_start
        [b, found_start] = getMooresBorder(b_im, b);
    end
    
    c = b;
end