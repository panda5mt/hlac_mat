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
    
    
    % 画像サイズ
    x_size = uint16(size(img,2));
    y_size = uint16(size(img,1));
    
    % 分割後の1つ分のサイズ
    each_x = uint16(x_size / nx) - 1;
    each_y = uint16(y_size / ny) - 1;
    
    % 画像サイズ再定義(半端な部分は切り捨てる) 
    x_size = each_x * nx;
    y_size = each_y * ny;
    


    % バッチの領域を確保(3次元)
    batches = zeros(each_y,each_x,(nx * ny));

    % 分割した画像をひたすら格納
    i = 1;
    for y=1:each_y:y_size
        for x=1:each_x:x_size
            
            x_end = (x + each_x - 1);
            y_end = (y + each_y - 1);
            
            c_img = img(y:y_end, x:x_end); 
            batches(:,:,i) = c_img;
            i = i + 1;
        end
    end


end

