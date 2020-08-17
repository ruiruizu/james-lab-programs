%%
% Gernerate Simple image with one peak
image_width = 20;
image_height = 20;
peak_x = 10;
peak_y = 10;
peak_sigma = 1;
peak_height = 5000;

I = zeros(image_height, image_width, 'uint16');
I(peak_y,peak_x) = peak_height * peak_sigma * sqrt(2*pi);
I = imgaussfilt(I, peak_sigma);

f = figure(1);
imshow(imadjust(I))

T = 0;
I_d = im2double(I);
tic;
detected_centers = ParticleDetector.LocalMax(I_d,T);
toc
detected_x = detected_centers(1);
detected_y = detected_centers(2);

if ~(detected_x == peak_x && detected_y == peak_y)
    error('')
end

%%
importStream = ImportTiff.start('../Examples/Image1.tif');
I = importStream.getStack;
importStream.close;

f = figure(1);
imshow(imadjust(I))

T = 0.02;
I_d = im2double(I);
tic;
detected_centers = ParticleDetector.LocalMax(I_d,T);
toc
viscircles(detected_centers, detected_centers(:,1)*0+4);

detected_centers = ParticleDetector.WeightedLeastSquares(I_d,T);
viscircles(detected_centers, detected_centers(:,1)*0+4,'Color','b');