function batches = split_into_baches(img, nx, ny)
%SPLIT_INTO_BATCHES 画像データの分割をする(画像データimgを(ny,nx)等分に分割する)
%
% batches = split_into_baches(img, nx, ny)
%     
% Parameters
% ----------
% i㎎ : vector
%   画像データ(グレースケールか2値)
% nx,ny : numeric(imgを縦にny分割、横にnx分割する)
%    
% 
% Returns
% -------
% batches : vector(numeric)
%   分割後の画像配列
    
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

