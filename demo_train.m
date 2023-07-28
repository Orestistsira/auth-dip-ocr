clearvars;
close all;

tic

train_img_path = 'img/text1_v3.png';
train_text_path = 'img/text1_v3.txt';
N = 30;

% Train Model --------------------------

x = imread(train_img_path);
x = padarray(x, [10 10], 255);

text = fileread(train_text_path);
A = double(text);
% Remove spaces and other non-letter characters
A = A(A > 32);
A = A(A < 127);

x = resizeToCommon(x);

x = removeColor(x);

figure
imshow(x);

x_gray = double(rgb2gray(x));
x_gray = imresize(x_gray, 2);
x_bin = double(x_gray > 125);

% rotate image
angle = findRotationAngle(x_bin);

x_bin = rotateImage(x_bin, angle);

figure
imshow(x_bin);

[R, ~] = findTextLetters(x_bin, N);

[classifiers, wa_train, C_train] = trainKnn(R, A, N);

toc
