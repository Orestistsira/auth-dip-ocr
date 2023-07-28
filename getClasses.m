function classes = getClasses(data)
    % Returns an array that contains in which class every letter of the
    % data array classifies, according to the number of their contours.

    classes = zeros(size(data));
    
    for i = 1:length(data)
        classes(i) = length(data{i});
    end
end