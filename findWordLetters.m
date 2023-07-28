function [R, letter_count] = findWordLetters(word, N)
    % Returns the size N descriptors of every letter in the image of a word
    % and the number of letters the word has

    projection = sum(word, 1);
    threshold = max(projection);

    cut_points_letters = findCutPoints(projection, threshold, 1);

    R = {};
    letter_count = 0;
    for j=1:2:length(cut_points_letters)-1

        letter = word(:, cut_points_letters(j):cut_points_letters(j+1));
        %figure
        %imshow(letter);

        letter = imresize(letter, 2);
        x_bin_rev = double(letter < 0.7);
        x_bin_rev = padarray(x_bin_rev, [3 3], 0);

        %figure
        %imshow(x_bin_rev);

        c = getContour(x_bin_rev);

        R{end+1} = findBorderDescriptor(c, N);
        letter_count = letter_count + 1;
    end
end