%% 2値HLACテストコード
close all;
clc;
img_dog1 = uint8(imread("dog1.png"));
img_dog2 = uint8(imread("dog2.png"));
img_cat = uint8(imread("cat.png"));
img_mer = uint8(imread("merge.png"));
% 2値化する
dog1_bin = rgb2gray(img_dog1) > 127; 
dog2_bin = rgb2gray(img_dog2) > 127;
cat_bin = rgb2gray(img_cat) > 127;
mer_bin = rgb2gray(img_mer) > 127;

% フィルタの準備(cell形式)
hlac_filters = { ...
    [0 0 0; 0 1 0; 0 0 0], ...
    [0 0 0; 0 1 1; 0 0 0], ...  
    [0 0 1; 0 1 0; 0 0 0], ...  
    [0 1 0; 0 1 0; 0 0 0], ...  
    [1 0 0; 0 1 0; 0 0 0], ...
    [0 0 0; 1 1 1; 0 0 0], ...  
    [0 0 1; 0 1 0; 1 0 0], ...  
    [0 1 0; 0 1 0; 0 1 0], ...  
    [1 0 0; 0 1 0; 0 0 1], ...  
    [0 0 1; 1 1 0; 0 0 0], ...  
    [0 1 0; 0 1 0; 1 0 0], ...  
    [1 0 0; 0 1 0; 0 1 0], ...  
    [0 0 0; 1 1 0; 0 0 1], ... 
    [0 0 0; 0 1 1; 1 0 0], ...  
    [0 0 1; 0 1 0; 0 1 0], ...  
    [0 1 0; 0 1 0; 0 0 1], ... 
    [1 0 0; 0 1 1; 0 0 0], ...  
    [0 1 0; 1 1 0; 0 0 0], ...  
    [1 0 0; 0 1 0; 1 0 0], ...  
    [0 0 0; 1 1 0; 0 1 0], ...  
    [0 0 0; 0 1 0; 1 0 1], ...  
    [0 0 0; 0 1 1; 0 1 0], ...  
    [0 0 1; 0 1 0; 0 0 1], ...  
    [0 1 0; 0 1 1; 0 0 0], ... 
    [1 0 1; 0 1 0; 0 0 0] ...
    };

%% HLAC特徴量を求める
dog1_hlac = extract_hlac(dog1_bin, hlac_filters);
dog2_hlac = extract_hlac(dog2_bin, hlac_filters);
cat_hlac = extract_hlac(cat_bin, hlac_filters);
dogcat_hlac = extract_hlac(mer_bin, hlac_filters);

% 加法性の確認
dogcat_minus_dog_hlac = dogcat_hlac - dog2_hlac; % 位置不変特徴量なのでdog1_hlacでもdog2_hlacでもよい

x = 1:size(dog1_hlac,2);

tiledlayout(2,4);
nexttile
imshow('dog1.png')
title('dog1');

nexttile 
imshow('dog2.png')
title('dog2');

nexttile(5) 
imshow('cat.png')
title('cat');

nexttile(6) 
imshow('merge.png')
title('dogcat');

nexttile(3,[2 2])
plot( ...
    x,dog1_hlac, ...
    x,dog2_hlac, 'o',...
    x,cat_hlac,  ...
    x, mer_hlac, ...
    x, dogcat_minus_dog_hlac,'.' ...
    );

legend('dog1 HLAC', ...
    'dog2 HLAC',    ...
    'cat HLAC',     ...
    'dogcat HLAC', ...
    'dogcat minus dog');