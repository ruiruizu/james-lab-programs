function centers = WeightedLeastSquares(I,T,cancelObj)

%%% centers = ParticleDetector.WeightedLeastSquares(I,T,(cancelObj = false))

    if nargin == 2
        cancelObj.status = false;
    end

%% LocalMaxDetector
    % Apply a 1 pixel sigma guassian filter to reduse camera noise
    J = imgaussfilt(I,1);

    % Find local maximum
    localM = imregionalmax(J);
    
    % Remove local maximum less than threshold parameter
	localM(J<T) = 0;
        
    % If there are no canidate positions then exit
    if ~any(localM,'all')
        centers = [];
        return;
    end
    
    % Calculate the pixel of the accepted local maximum
    idx = label2idx(bwlabel(localM));
    nCanidates = size(idx,2);
    LMcenters = zeros(nCanidates,2);
    for i = 1:nCanidates
        [Y, X] = ind2sub(size(localM), idx{i});
        LMcenters(i,:) = mean([X, Y],1);
    end

%% WeightedLeastSquares
    imageSizeX = size(I,2);
    imageSizeY = size(I,1);
    [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    centers = zeros(nCanidates,2);
    RADIUS = 3;
    
    for i = 1:nCanidates
        if cancelObj.status
            centers = [];
            return;
        end
        
        centerX = LMcenters(i,1);
        centerY = LMcenters(i,2);
        circlePixels = (rowsInImage - centerY).^2 ...
                     + (columnsInImage - centerX).^2 ...
                     <= RADIUS.^2;
        
    
        % Initial guess values
        p0 = zeros(1,4);
        B  = zeros(1,1);
        Z   = I(circlePixels);
        X   = columnsInImage(circlePixels);
        Y   = rowsInImage(circlePixels);

        [p0(1,2), p0(1,3), p0(1,4), p0(1,1), B(1)] = ParticleDetector.MLFitWBg( Z, X, Y);
        
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
        p = ParticleDetector.WLSGMMFit(Z,X,Y,1,min(B),p0',pU',pL');
    
        centers(i,:) = [p.x, p.y];
    end