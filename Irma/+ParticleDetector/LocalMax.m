function centers = LocalMax(I,T)

%%% centers = ParticleDetector.LocalMax(I,T)

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
    centers = zeros(nCanidates,2);
    for i = 1:nCanidates
        [Y, X] = ind2sub(size(localM), idx{i});
        centers(i,:) = mean([X, Y],1);
    end