function k = createKernel(sigma,center)

    x = floor(center(:,1));
    y = floor(center(:,2));
    
    xOffset = center(:,1) - x;
    yOffset = center(:,2) - y;
    
    kSize = 2*ceil(2*sigma)+1;
    
    baseImg =  zeros(kSize,kSize);
    particleAmp = 1;
    
    k = gauss2d(baseImg,sigma,[ceil(kSize/2) + xOffset ,ceil(kSize/2) + yOffset],particleAmp);

end

function mat = gauss2d(mat, sigma, center, particleAmp)
    gaussSize = size(mat);
    [x,y] = ndgrid(1:gaussSize(1), 1:gaussSize(2));
    xGauss = center(1);
    yGauss = center(2);
    exponent = ((x-xGauss).^2 + (y-yGauss).^2)./(2*sigma);
    mat       = (exp(-exponent))*particleAmp;
end