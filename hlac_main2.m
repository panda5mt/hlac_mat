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
img = (ind2rgb(img, cmap)); % rgbに変換

%img = double(imread('./img/saize_gekimuzu.jpg')./255);

% サイズ取得
colsize = size(img,1); % 縦サイズ
rowsize = size(img,2); % 横サイズ

% 画像を左右に2等分する
ref_img = img(1:colsize, 1:uint16(rowsize/2), :);
tar_img = img(1:colsize, (uint16(rowsize/2) + 1):rowsize, :);


% 2値化する
ncl = 2; % 1~3
ref_bin = ref_img(:,:,ncl) > graythresh(ref_img(:,:,ncl)) ; 
tar_bin = tar_img(:,:,ncl) > graythresh(tar_img(:,:,ncl)) ; 


%% HLAC特徴量を求める
nx = 30;
ny = 30;
ref_hlac = extract_batchwise_hlac(ref_bin,hlac_filters, nx, ny);
tar_hlac = extract_batchwise_hlac(tar_bin,hlac_filters, nx, ny);

% グラフ描画用パラメータの用意
ref_X = 1:size(ref_hlac, 2);
ref_Y = 1:size(ref_hlac, 1);
ref_Z = ref_hlac(ref_Y,ref_X);

tar_X = 1:size(tar_hlac, 2);
tar_Y = 1:size(tar_hlac, 1);
tar_Z = tar_hlac(tar_Y,tar_X);

%% 内積を求める
hlac_angles = [];
for i=ref_Y
    ha = vector_angle(ref_hlac(i,:), tar_hlac(i,:), 1e-6);
    hlac_angles = [hlac_angles ha]; 
end

%% 描画
tiledlayout(2,5);
nexttile
contourf(ref_X,ref_Y,ref_Z);
title('reference');

nexttile
contourf(tar_X,tar_Y,tar_Z);
title('target');

nexttile
contourf(tar_X,tar_Y,abs(tar_Z-ref_Z));
title('difference');

nexttile(7)
imshow(ref_bin);
title('reference');

nexttile(8)
imshow(tar_bin);
title('target');


nexttile(6)
plot(ref_Y,real(hlac_angles));

nexttile(4,[2 2])
%colsize; % 縦サイズ
%rowsize; % 横サイズ
ax = gca;
ax.XDir = 'normal';
ax.YDir = 'reverse';
img =  tar_img ;
batches = split_into_baches(img, nx, ny);

x_each = size(batches,2);
y_each = size(batches,1);
x_lim  = x_each * nx;
y_lim  = y_each * ny;

ax.XLim = [1 x_lim];
ax.YLim = [1 y_lim];
im = image('CData',img,'XData',[1 ax.XLim],'YData',[1 ax.YLim]);
im.AlphaData = 0.5;
hold on
p = 1;
th = 0.08;
for y=1:y_each:y_lim
    for x=1:x_each:x_lim
        angle = real(hlac_angles(p));
        
        if angle > th
            r = rectangle('Position',[x y x_each y_each]);
            if(angle <= 1 )
                r.FaceColor = [0 angle 0 0.7];
            else
                r.FaceColor = [0 1 0 0.7];
            end
            r.EdgeColor = 'b';
            r.LineWidth = 1;
            
        end
        p = p + 1;
    end
end

hold off
% figure(1);
% tiledlayout(1,2);
