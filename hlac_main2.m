%% 2値HLACを利用した間違い探し検出コード
close all;
clc;

%% フィルタの準備(cell形式)
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


%% 画像読み込み
% Wikipediaの'Spot_the_difference.png'はインデックス付きの画像
% カラーマップの復元が必要となる
[img,cmap] = imread('./img/Spot_the_difference.png');
img = uint8(ind2rgb(img, cmap)) * 255; % rgbに変換

%img = uint8(imread('./img/saize_gekimuzu.jpg'));

% サイズ取得
colsize = size(img,1); % 縦サイズ
rowsize = size(img,2); % 横サイズ

% 画像を左右に2等分する
ref_img = img(1:colsize, 1:uint16(rowsize/2), :);
tar_img = img(1:colsize, (uint16(rowsize/2) + 1):rowsize, :);


% 2値化する
% todo: OTSUの手法に直すこと
ref_bin = ((rgb2gray(ref_img)) > 127); 
tar_bin = ((rgb2gray(tar_img)) > 127); 

%% HLAC特徴量を求める
ref_hlac = extract_batchwise_hlac(ref_bin,hlac_filters,20,20);
tar_hlac = extract_batchwise_hlac(tar_bin,hlac_filters,20,20);

% グラフ描画用パラメータの用意
ref_X = 1:size(ref_hlac, 2);
ref_Y = 1:size(ref_hlac, 1);
ref_Z = ref_hlac(ref_Y,ref_X);

tar_X = 1:size(tar_hlac, 2);
tar_Y = 1:size(tar_hlac, 1);
tar_Z = tar_hlac(tar_Y,tar_X);


%% 描画
tiledlayout(1,3);
nexttile
contourf(ref_X,ref_Y,ref_Z);
title('reference');

nexttile
contourf(tar_X,tar_Y,tar_Z);
title('target');

nexttile
contourf(tar_X,tar_Y,tar_Z-ref_Z);
title('difference');

% figure(1);
% tiledlayout(1,2);
% nexttile
% imshow(ref_bin);
% title('reference');
% 
% nexttile
% imshow(tar_bin);
% title('target');
