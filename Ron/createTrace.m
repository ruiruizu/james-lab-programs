function traces = createTrace(stack, centers, sigma)
    nCenters = size(centers, 1);
    nFrames = size(stack,4);
    nChannels = size(stack,3);
    
    
    traces = zeros(nCenters,nChannels,nFrames);
    
    kSize = 2*ceil(2*sigma)+1;
    kRadius = floor(kSize/2);
    kStack = zeros(kSize,kSize,nCenters);
    
%     kernel = createKernel(sigma,[1,1]);
    
    for i = 1:nCenters
        kStack(:,:,i) = createKernel(sigma,centers(i,:));
    end
    
    for i = 1:nFrames
        for  j = 1:nChannels
            I = im2double(stack(:,:,j,i));
            I = padarray(I,kSize);
            for k = 1:nCenters
%                 subPxI = createSubPxImg(centers(k,:) + [kSize,kSize] , kSize, I);
%                 traces(k,j,i) = sum(subPxI .* kernel,'all');
                center = centers(k,:) + [kSize,kSize]; 
                cropI = I(floor(center(:,2)/2) - kRadius:floor(center(:,2)/2) + kRadius,...
                            floor(center(:,1)/2) - kRadius:floor(center(:,1)/2) + kRadius);
                traces(k,j,i) = sum(cropI .* kStack(:,:,k),'all');
            end
        end
    end
    
end
