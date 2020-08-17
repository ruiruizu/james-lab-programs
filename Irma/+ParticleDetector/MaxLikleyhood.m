function centers = MaxLikleyhood(I,T,cancelObj)

%%% centers = ParticleDetector.MaxLikleyhood(I,T,(cancelObj = false))

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

%% MaxLikleyhood
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
        Z   = I(circlePixels);
        X   = columnsInImage(circlePixels);
        Y   = rowsInImage(circlePixels);

        [x, y] = ParticleDetector.MLFitNoBg( Z, X, Y);
    
        centers(i,:) = [x, y];
    end