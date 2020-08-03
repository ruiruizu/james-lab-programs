function k = createKernel(sigma)

    size = 2*ceil(2*sigma)+1;
    
    baseImg =  zeros(size,size);
    particleAmp = 1;
    
    k = gauss2d(baseImg,sigma,[ceil(size/2),ceil(size/2)],particleAmp);

end

function mat = gauss2d(mat, sigma, center, particleAmp)
    gaussSize = size(mat);
    [x,y] = ndgrid(1:gaussSize(1), 1:gaussSize(2));
    xGauss = center(1);
    yGauss = center(2);
    exponent = ((x-xGauss).^2 + (y-yGauss).^2)./(2*sigma);
    mat       = (exp(-exponent))*particleAmp;
end