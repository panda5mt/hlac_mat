function num_matches = extract_hlac(img,hlac_filters)
%EXTRACT_HLAC 2値化HLAC展開用にマスク(フィルタ)と画像データの畳み込みを行う
%
% num_matches = extract_hlac(img,hlac_filters)
%     
% Parameters
% ----------
% i㎎ : vector
%   画像データ
% hlac_filters : cell
%   フィルタである数値配列(3次元と仮定) 
% 
% Returns
% -------
% num_matches : vector(numeric)
%   マスク(フィルタ)との一致回数

result = [];
img = uint8(img);
%hlac_filters = uint8(hlac_filters);

for i=1:size(hlac_filters,2) %hlac_filtersの要素2 = 総フィルタ数
    filter = cell2mat(hlac_filters(:,i)); % cellから行列に変換
    feature_map = my_conv2(img, filter,'valid');
    count = sum(feature_map == sum(filter,'all'),'all'); %マスクと一致する数を集計
    result = [result count];
end
num_matches = result;

