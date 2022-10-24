function hlac_batches = extract_batchwise_hlac(img, hlac_filters, nx, ny)
%EXTRACT_HLAC 2値化HLAC展開用にマスク(フィルタ)と画像データの畳み込みを行う
%
% hlac_batches = extract_hlac(img,hlac_filters,nx,ny)
%     
% Parameters
% ----------
% i㎎ : vector
%   画像データ
% hlac_filters : cell
%   フィルタである数値配列(3次元と仮定) 
% nx,ny : numeric
%   imgを縦にny分割、横にnx分割する
% 
% Returns
% -------
% hlac_batches : vector(numeric)
%   マスク(フィルタ)との一致回数
    batches = split_into_baches((img), nx, ny);
    b_size = size(batches,3); % バッチ総数

    result = [];
    hlac_batches = [];

    for b=1:b_size
        img = batches(:,:,b);
        for i=1:size(hlac_filters,2) %hlac_filtersの要素2 = 総フィルタ数
            filter = cell2mat(hlac_filters(:,i)); % cellから行列に変換
            feature_map = my_conv2(img, filter,'valid');
            count = sum(feature_map == sum(filter,'all'),'all'); %マスクと一致する数を集計
            result = [result count];
        end
        hlac_batches = [hlac_batches; result];
        result = [];
    end
    
end

