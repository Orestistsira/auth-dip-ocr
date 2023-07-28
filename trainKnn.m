function [classifiers, wa, C] = trainKnn(R, A, N)
    % Trains a classifying model using knn with the given training data, 
    % R being the letter descriptors and A the ascii values of the letters.
    % It splits the data to a train set and test set to train and evaluate
    % the model using 70:30 split. N is the size of the descriptors and 
    % returns the classifiers, the weighted accuracy wa and the confusion
    % matrix C
    

    % Divide data into training and test sets using 70:30 split
    [train_R, train_A, test_R, test_A] = splitDataset(R, A);

    % Divide characters into classes based on number of outlines
    %[train_classes, test_classes] = divide_classes(train_R, test_R);
    train_classes = getClasses(train_R);
    test_classes = getClasses(test_R);

    num_classes = max(train_classes);
    classifiers = cell(num_classes, 1);

    % Model training
    for i = 1:num_classes
        train_indices = find(train_classes == i);
        train_data_cells = train_R(train_indices);
        n = length(train_data_cells);
        train_data = zeros(n, i*(N-1));
        for j=1:1:n
            for k=1:1:i
                train_data(j, 1+(k-1)*(N-1):k*(N-1)) = cell2mat(train_data_cells{j}(k));
            end
        end
        train_labels = train_A(train_indices);
        classifiers{i} = fitcknn(train_data, train_labels, 'NumNeighbors', 5); %5,3
    end

    % Model testing
    test_labels = cell(num_classes, 1);
    predicted_labels = cell(num_classes, 1);
    for i = 1:num_classes
        test_indices = find(test_classes == i);
        
        test_data_cells = test_R(test_indices);
        n = length(test_data_cells);
        test_data = zeros(n, i*(N-1));
        for j=1:1:n
            for k=1:1:i
                test_data(j, 1+(k-1)*(N-1):k*(N-1)) = cell2mat(test_data_cells{j}(k));
            end
        end
        test_labels{i} = test_A(test_indices);
        
        predicted_labels{i} = predict(classifiers{i}, test_data);
    end
    
    % Evaluate training
    C = {};
    wa = zeros(num_classes, 1);
    for i = 1:num_classes
        % Find accuracy
        C{i} = confusionmat(test_labels{i}, predicted_labels{i});
        wa(i) = sum(diag(C{i})) / sum(sum(C{i})) * 100;
    end
    
end

function [train_R, train_A, test_R, test_A] = splitDataset(R, A)
    % Splits the dataset using the 70:30 split
    
    % Get unique characters in the dataset
    characters = unique(A);

    % Initialize empty tables for the training set and test set
    train_R = [];
    train_A = [];
    test_R = [];
    test_A = [];

    % Loop through each character and split it into a training and test set
    for i = 1:length(characters)
        % Get indices of current character
        idx = find(A == characters(i));

        % Calculate number of characters for training and test set
        num_rows = length(idx);
        num_train = round(num_rows * 0.7);

        % Shuffle indices
        idx = idx(randperm(num_rows));

        % Add to training set
        train_R = [train_R R(idx(1:num_train))];
        train_A = [train_A A(idx(1:num_train))];

        % Add to test set
        test_R = [test_R R(idx(num_train+1:end))];
        test_A = [test_A A(idx(num_train+1:end))];
    end
end
