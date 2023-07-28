function [R, word_index] = findTextLetters(x_bin, N)
    % Returns the size N descriptors R of each letter in the binary image
    % x_bin and the index of where every word ends 

    projection = sum(x_bin, 2);
    threshold = max(projection)-1;

    cut_points = findCutPoints(projection, threshold, 1);
    
    R = [];
    word_index = (1);
    for i=1:2:length(cut_points)-1
        current_line = x_bin(cut_points(i):cut_points(i+1), :);

        current_line_blurred = imgaussfilt(current_line, 9); %10

        projection = sum(current_line_blurred, 1);
        threshold = max(projection)-1;

        cut_points_words = findCutPoints(projection, threshold, 1);

        for j=1:2:length(cut_points_words)-1
            word = current_line(:, cut_points_words(j):cut_points_words(j+1));

            [R_j, letter_count] = findWordLetters(word, N);
            
            R = [R R_j];
            word_index(end+1) = word_index(end) + letter_count;
        end
    end
end