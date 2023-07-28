function y = rotateImage(x, angle)
    % Rotates the binary image x by the given angle and returns the rotated
    % image y

    M = [cosd(-angle) -sind(-angle) 0;
         sind(-angle) cosd(-angle) 0;
         0 0 1];
    y = imwarp(imcomplement(x), affine2d(M));
    y = imcomplement(y);
end
