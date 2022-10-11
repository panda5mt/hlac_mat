function batches = split_into_baches(img, nx, ny)
%SPLIT_INTO_BATCHES 画像データの分割をする(nx x ny 個に分割する)
%
% num_matches = extract_hlac(img,hlac_filters)
%     
% Parameters
% ----------
% i㎎ : vector
%   画像データ(グレースケールか2値)
% hlac_filters : cell
%   フィルタである数値配列(3次元と仮定) 
% 
% Returns
% -------
% num_matches : vector(numeric)
%   マスク(フィルタ)との一致回数
    
    batches = [];
    
    % 画像サイズ
    x_size = size(img,2);
    y_size = size(img,1);
    
    % 分割後の1つ分のサイズ
    each_x = x_size / nx;
    each_y = y_size / ny;

    for y=1:each_y:y_size
        for x=1:each_x:x_size
            batches = [batches img(y:(y + each_y - 1), x:(x + each_x - 1))]; 
        end
    end

end

