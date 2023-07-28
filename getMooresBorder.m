function [b, found_start] = getMooresBorder(b_im, b)
    % Returns an array of the points from the outer contour not found yet
    % from the reverse binary image x_bin

    [N, M] = size(b_im);
    x_start = 0;
    y_start = 0;

    % find start point
    found_start = false;
    for x=1:1:N
        for y=1:1:M
            if b_im(x, y) == 1 && notIncluded(x, y, b)
                x_start = x;
                y_start = y;
                found_start = true;
                break;
            end
        end
        if found_start
            break;
        end
    end
    
    % If there are no other pixels left return and end the serach
    if found_start == false
        return
    end

    b{end+1} = [];
    b_counter = 1;


    s_x = x_start;
    s_y = y_start;

    b{end}(b_counter, 1) = s_x;
    b{end}(b_counter, 2) = s_y;
    b_counter = b_counter + 1;

    offset_table = [0 0;0 -1;-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1];

    p_x = s_x;
    p_y = s_y;

    b_x = s_x;
    b_y = s_y - 1;

    id = findNextRotationId(b_x, b_y, p_x, p_y, offset_table);

    c_x = p_x + offset_table(id, 1);
    c_y = p_y + offset_table(id, 2);

    % Travel the contour while getting its points
    while c_x ~= s_x || c_y ~= s_y
        if b_im(c_x, c_y) == 1
    
            b{end}(b_counter, 1) = c_x;
            b{end}(b_counter, 2) = c_y;
            b_counter = b_counter + 1;

            b_x = p_x;
            b_y = p_y;

            p_x = c_x;
            p_y = c_y;

            id = findNextRotationId(b_x, b_y, p_x, p_y, offset_table);

            c_x = p_x + offset_table(id, 1);
            c_y = p_y + offset_table(id, 2);
        else
            b_x = c_x;
            b_y = c_y;

            id = findNextRotationId(b_x, b_y, p_x, p_y, offset_table);

            c_x = p_x + offset_table(id, 1);
            c_y = p_y + offset_table(id, 2);
        end

    end

end

function id = findNextRotationId(b_x, b_y, p_x, p_y, offset_table)
    id = -1;
    for i=1:1:9
        if b_x - p_x == offset_table(i, 1) && b_y - p_y == offset_table(i, 2)
            id = i;
            break;
        end
    end
    id = mod(id, 9) + 1;
end

function not_inc = notIncluded(x, y, b)
    not_inc = true;
    [~, n] = size(b);
    for i=1:1:n
        prev = b{i};
        n_prev = length(prev);
        for j=1:1:n_prev
            if x == prev(j, 1) && y == prev(j, 2)
                not_inc = false;
                return
            end
        end
    end
end