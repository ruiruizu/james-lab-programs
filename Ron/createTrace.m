function traces = createTrace(stack, centers, sigma)
    nCenters = size(centers, 1);
    nFrames = size(stack,4);
    nChannels = size(stack,3);
    
    kernel = createKernel(sigma);
    kSize = size(kernel,1);
    
    traces = zeros(nCenters,nChannels,nFrames);
    
    for i = 1:nFrames
        for  j = 1:nChannels
            I = im2double(stack(:,:,j,i));
            I = padarray(I,kSize);
            for k = 1:nCenters
                subPxI = createSubPxImg(centers(k,:) + [kSize,kSize] , kSize, I);
                traces(k,j,i) = sum(subPxI .* kernel,'all');
            end
        end
    end
    
end
