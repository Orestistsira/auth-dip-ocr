close all;
clearvars -except classifiers N

tic

test_img_path = 'img/text2.png';
test_text_path = 'img/text2.txt';

% Test Model -----------------------------

x = imread(test_img_path);
x = padarray(x, [10 10], 255);

text = fileread(test_text_path);
A = double(text);
% Remove spaces and other non-letter characters
A = A(A > 32);
A = A(A < 127);

x = resizeToCommon(x);

[predicted_ascii, predicted_text] = readText(x, classifiers, N);

C_test = confusionmat(A, predicted_ascii);
wa_test = sum(diag(C_test)) / sum(sum(C_test)) * 100;

fileID = fopen('out.txt','w');
fprintf(fileID, '%s', predicted_text);
fclose(fileID);

toc