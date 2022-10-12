function hlac_angles = vector_angle(hv1, hv2, eps)
%VECTOR_ANGLE この関数の概要をここに記述
%   詳細説明をここに記述

    if isempty(eps)
        eps = 1e-6;
    end

    hlac_angles = [];
    
    hv1 = (hv1 + eps) / norm(hv1 + eps);
    hv2 = (hv2 + eps) / norm(hv2 + eps);
    
    hlac_angles = acos(dot(hv1,hv2));
   
end

