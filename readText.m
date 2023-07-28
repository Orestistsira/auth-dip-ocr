function [predicted_ascii, predicted_chars] = readText(x, classifiers, N)
    % Reads the text of the image x using a trained model in classifiers
    % and returns the predicted charachters in ascii and in text.

    % Remove any colored pixels in the image (for text1)
    x = removeColor(x);

    figure
    imshow(x);

    % Convert image to binary
    x_gray = double(rgb2gray(x));
    x_gray = imresize(x_gray, 2);
    x_bin = double(x_gray > 125);

    % rotate image
    angle = findRotationAngle(x_bin);

    x_bin = rotateImage(x_bin, angle);

    figure
    imshow(x_bin);
    
    % Find text letters
    [R, word_index] = findTextLetters(x_bin, N);
    
    % Predict letters 
    num_of_letters = length(R);
    predicted_ascii = zeros(1, num_of_letters);
    predicted_chars = [];
    word_counter = 1;
    
    for i=1:1:num_of_letters
        letter = R{i};
        class_number = length(letter);
        
        letter_data = zeros(1, class_number * (N-1));
        
        for j=1:1:class_number
           letter_data(1+(j-1)*(N-1):j*(N-1)) = cell2mat(letter(j));
        end
        
        predicted_ascii(i) = predict(classifiers{class_number}, letter_data);
        
        if i == word_index(word_counter)
            predicted_chars(end+1) = 32;
            word_counter = word_counter + 1;
        end
        predicted_chars(end+1) = predicted_ascii(i);
    end
    
    predicted_chars = char(predicted_chars(2:end));
end