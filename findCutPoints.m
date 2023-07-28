function cut_points = findCutPoints(projection, threshold, space)
    % Returns the points to cut the image given its projection and
    % threshold and the minimum space there has to be to cut.

    cut_points = zeros(1,2);
    counter = 1;
    space_counter = 0;
    for line=1:1:length(projection)
        if projection(line) < threshold 
            if mod(counter, 2) == 1
                cut_points(counter) = line;
                counter = counter + 1;
            end
            space_counter = 0;
        elseif projection(line) >= threshold && mod(counter, 2) == 0
            space_counter = space_counter + 1;
            
            if space_counter >= space
                cut_points(counter) = line;
                counter = counter + 1;
                space_counter = 0;
            end
        end
    end
end