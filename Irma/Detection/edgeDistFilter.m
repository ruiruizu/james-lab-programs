function centers = edgeDistFilter(I,centers,eD)

    imgSizeY = size(I,1);
    imgSizeX = size(I,2);
    for i = size(centers,1):-1:1
        if(centers(i,1) <= eD || imgSizeX - centers(i,1) <= eD ||...
           centers(i,2) <= eD || imgSizeY - centers(i,2) <= eD)
       
            centers(i,:) = [];
            
        end
    end
end