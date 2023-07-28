function x_resized = resizeToCommon(x)
    % Resize picture to dimensions that match with test image

    [M, ~] = size(x);
    
    if M > 6000
        x_resized = imresize(x, 0.3); 
    elseif M > 3000
        x_resized = imresize(x, 0.6); 
    elseif M < 1000
        x_resized = imresize(x, 2); 
    else
        x_resized = x;
    end
end