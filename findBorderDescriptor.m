function R = findBorderDescriptor(c, N)
    % Returns the size N descriptor of a letter, given an image of the
    % letter's contour

    [~, n] = size(c);
    r = {};
    R = {};

    for j=1:1:n
        border = c{j};
        r{j} = complex(border(:, 1), border(:, 2));
        
        % interp
        m = 1:1:length(r{j});
        m_new = linspace(1, length(r{j}), N);  
        r{j} = interp1(m, r{j}, m_new);
        
        % DFT
        R{j} = abs(fft(r{j}(2:end)));
    end
   
end