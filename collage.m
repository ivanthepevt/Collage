% Read in the image
im = imread('aot.jpg');

% Thresholding
gray_im = rgb2gray(im);
level = graythresh(gray_im);
bw_im = imbinarize(gray_im, level);

% Morphological closing
se = strel('disk', 4);
closed_im = imclose(bw_im, se);

% Segmentation
cc = bwconncomp(closed_im);
numPixels = cellfun(@numel,cc.PixelIdxList);
[~,idx] = max(numPixels);
mask = zeros(size(closed_im));
mask(cc.PixelIdxList{idx}) = 1;

% Keep the object and create a white background
object = im;
object(repmat(~mask,[1 1 3])) = 255;

% Overlay outline
edge_im = edge(gray_im);
background = ~edge_im;
background = repmat(background,[1 1 3]);
final_im = uint8(double(object).*double(background));

imwrite(final_im, 'output_image.jpg');
