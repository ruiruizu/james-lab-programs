function traces = createTrace(stack, centers, sigma)
    nCenters = size(centers, 1);
    nFrames = size(stack,4);
    nChannels = size(stack,3);
    
    traces = zeros(nCenters,nChannels,nFrames);

    for i = 1:nFrames
        for  j = 1:nChannels
            convImg = imgaussfilt(stack(:,:,j,i),sigma);
            traces(:,j,i) = convImg(sub2ind(size(convImg), centers(:,1), centers(:,2)));
        end
    end
    
end
