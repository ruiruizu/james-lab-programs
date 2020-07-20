function particles = particleDetector(I, minPeakI,d)
    % Apply a 1 pixel width guassian filter to reduse noice when fitting
    J = imgaussfilt(I,1);

    % Find local maximum
    localM = imregionalmax(J);
    
    % Remove local maximum less than threshold parameter
    localM(J<minPeakI) = 0;
        
    % If there are no canidate positions then exit
    if ~any(localM,'all')
        particles = [];
        return;
    end
    
    % Find approximate centers
    pixelIdx = label2idx(bwlabel(localM));
    numCanidates = size(pixelIdx,2);
    centers = zeros(numCanidates,2);
    for i = 1:numCanidates
        [pixelY, pixelX] = ind2sub(size(localM), pixelIdx{i});
        centers(i,:) = mean([pixelX, pixelY],1);
    end
    
    % Find exact centers
%     imageSizeX = size(I,2);
%     imageSizeY = size(I,1);
%     [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
%     particles = zeros(numCanidates,2);
%     
%     for i = 1:numCanidates
%         centerX = centers(i,1);
%         centerY = centers(i,2);
%         radius = 3;
%         circlePixels = (rowsInImage - centerY).^2 ...
%                      + (columnsInImage - centerX).^2 <= radius.^2;
%                  
%         weight = I(circlePixels);
%         pixelCellIdx = label2idx(bwlabel(circlePixels));
%         pixelIdx = pixelCellIdx{1};
%         numpixels = size(pixelIdx,1);
%         [pixelY, pixelX] = ind2sub(size(I), pixelIdx);
%         particles(i,:) = sum([pixelX.*weight, pixelY.*weight],1) / sum(weight);
%     end

%     imageSizeX = size(I,2);
%     imageSizeY = size(I,1);
%     [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
%     particles = zeros(numCanidates,2);
%     radius = 3;
%     
%     for i = 1:numCanidates
%         centerX = centers(i,1);
%         centerY = centers(i,2);
%         circlePixels = (rowsInImage - centerY).^2 ...
%                      + (columnsInImage - centerX).^2 ...
%                      <= radius.^2;
%         
%         Z = I(circlePixels);
%         X = columnsInImage(circlePixels);
%         Y = rowsInImage(circlePixels);
% 
%         [x, y, s, A, B] = MLFitWBg( Z, X, Y);
%         particles(i,:) = [x, y];
%     end
    
    
    imageSizeX = size(I,2);
    imageSizeY = size(I,1);
    [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    particles = zeros(numCanidates,2);
    radius = 3;
    
    for i = 1:numCanidates
        if d.CancelRequested
            break;
            particles = [];
        end
        
        centerX = centers(i,1);
        centerY = centers(i,2);
        circlePixels = (rowsInImage - centerY).^2 ...
                     + (columnsInImage - centerX).^2 ...
                     <= radius.^2;
        
    
        % Initial guess values
        p0 = zeros(1,4);
        B  = zeros(1,1);
        Z   = I(circlePixels);
        X   = columnsInImage(circlePixels);
        Y   = rowsInImage(circlePixels);

        [p0(1,2), p0(1,3), p0(1,4), p0(1,1), B(1)] = MLFitWBg( Z, X, Y);
        
        % Upper and lower bound on the guess values
        minA = min(Z,[],'all');
        minX = min(X,[],'all');
        minY = min(Y,[],'all');
        maxX = max(X,[],'all');
        maxY = max(Y,[],'all');
        %maxS = sqrt((maxX-minX)^2 + (maxY-minY)^2);
        %            A               x               y               s
        pU = [p0(:,1)*2,      p0(:,2)*0+maxX, p0(:,3)*0+maxY, p0(:,4)*2];
        pL = [p0(:,1)*0+minA, p0(:,2)*0+minX, p0(:,3)*0+minY, p0(:,4)*0+1];

        % Fitting
        p = WLSGMMFit(Z,X,Y,1,min(B),p0',pU',pL');
    
        particles(i,:) = [p.x, p.y];
    end
end




