function subPxI = createSubPxImg(center, kSize, I)

    x = center(:,2);
    y = center(:,1);

%Non subpixel coordinates
    x1 = floor(x);
    y1 = floor(y);
    
    x2 = ceil(x);
    y2 = ceil(y);

%Weights in the x and y direction
    xWeight = x - x1;
    yWeight = y - y1;
    
    kRadius = floor(kSize/2);
    
%Creating the 4 matrices that will be averaged with weights
    img = I(y1-kRadius:y1+kRadius,x1-kRadius:x1+kRadius);
    imgXShift = I(y1-kRadius:y1+kRadius,x2-kRadius:x2+kRadius);
    imgYShift = I(y2-kRadius:y2+kRadius,x1-kRadius:x1+kRadius);
    imgXYShift = I(y2-kRadius:y2+kRadius,x2-kRadius:x2+kRadius);
    
%%Finding 4 matrices inbetween pixels
    
%x
    xAvg1 = imgXShift .* xWeight + img .* (1-xWeight);
    xAvg2 = imgXYShift .* xWeight + imgYShift .* (1-xWeight);
    
%y
    yAvg1 = imgYShift .* yWeight + img .* (1-yWeight);
    yAvg2 = imgXYShift .* yWeight + imgXShift .* (1-yWeight);
    
    

    subPxI = (xAvg1 + xAvg2 + yAvg1 + yAvg2)./4;
    
    
   
    
   
end