function imgMontage = montageMaker(images,I)
    IMG = images(:,:,1);
    for i = 1:size(images,3)-1
        IMG = cat(2,IMG,images(:,:,i+1));
    end
    imgMontage = [imadjust(I) IMG];
end