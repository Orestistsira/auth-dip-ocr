function angle = findRotationAngle(x)
    % Returns the angle we have to rotate the binary image x in order to be
    % vertically alligned

    % Blur image
    x_blurred = imgaussfilt(x, 9);
    
    figure
    imshow(x_blurred);

    % Calculate DFT
    X = fft2(x_blurred);
    X_shifted = fftshift(X);
    X_log = log(1 + abs(X_shifted));

    % Normalize to [0, 1] and keep only the very bright frequencies
    X_log = (X_log - min(X_log(:))) / (max(X_log(:)) -  min(X_log(:)));
    X_log = X_log * 255;
    
    % Find the maximum frequency of change corresponding to the change in
    % brightness from line to line
    [rows, cols] = size(X_log);
    mid_row = ceil(rows/2);
    mid_col = ceil(cols/2);

    % Keep only the bottom half of the Fourier trasform image
    X_log_quad = X_log(mid_row+5:end, 1:end);
    [~, max_index] = max(X_log_quad(:));
    [max_row, max_col] = ind2sub(size(X_log_quad), max_index);
    max_row = max_row + mid_row - 1;
    angle = atan2d(max_row - mid_row, max_col - mid_col);
    angle = 90 - angle;

    % Perform a serial search around the initial estimate to precisely locate the corner
    best_angle = angle;
    max_proj_sum = -10000;
    for a = angle-5:0.1:angle+5
        % Rotate blurred image
        rotated = rotateImage(x_blurred, a);

        % Sum rows and compare it with max
        proj = sum(rotated, 2);
        proj_sum = sum(abs(diff(proj)));
        if proj_sum > max_proj_sum
            best_angle = a;
            max_proj_sum = proj_sum;
        end
    end

    angle = best_angle;
    
end