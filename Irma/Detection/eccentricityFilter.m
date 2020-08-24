function centers = eccentricityFilter(I,centers,e)
    numCenters = size(centers,1);
    I = imgaussfilt(I,1);

    BW = bwlabel(imbinarize(I,'adaptive'));
    eccenVals = zeros(numCenters,1);
    for i = 1:numCenters
        num = BW(centers(i,2),centers(i,1));
        newBW = BW;
        newBW(newBW ~= num) = 0;
        newBW = imbinarize(newBW);
        stats = regionprops(newBW,'Eccentricity');
        if isempty(stats)
            eccenVals(i) = 0;
        else
            eccenVals(i) = stats.Eccentricity;
        end
    end
    centers(eccenVals(:) < e,:) = [];
end