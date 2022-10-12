function hlac_batches = extract_batchwise_hlac(img, hlac_filters, nx, ny)
%EXTRACT_BATCHWISE_HLAC この関数の概要をここに記述
%   詳細説明をここに記述
    batches = split_into_baches((img), nx, ny);
    b_size = size(batches,3); % バッチ総数

    result = [];
    hlac_batches = [];

    for b=1:b_size
        img = batches(:,:,b);
        for i=1:size(hlac_filters,2) %hlac_filtersの要素2 = 総フィルタ数
            filter = cell2mat(hlac_filters(:,i)); % cellから行列に変換
            feature_map = conv2(img, filter,'valid');
            count = sum(feature_map == sum(filter,'all'),'all'); %マスクと一致する数を集計
            result = [result count];
        end
        hlac_batches = [hlac_batches; result];
        result = [];
    end
    
end

