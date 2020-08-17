function centers = pointDistFilter(centers,pD)
    n = size(centers,1);
    while n >0
        distances = sqrt((centers(n,1) - centers(1:n-1,1)).^2 + (centers(n,2) - centers(1:n-1,2)).^2);
        if min(distances) < pD
            centers(n,:) = [];
            centers(distances < pD,:) = [];
            n = size(centers,1);
        else
            n = n-1;
            
        end
    
    end
    
end