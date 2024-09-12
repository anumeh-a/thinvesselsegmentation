function mask = createCirclesMask(Iv,cent,r)

% CENTERS        An m x 2 vector of [x, y] coordinates of circle centers
%
% RADII          An m x 1 vector of circle radii
%
% OUTPUTS:
% MASK           A logical mask of size [xDim,yDim], true where the circles
%                are indicated, false elsewhere.
%
%%% EXAMPLE 1:
%   img = imread('coins.png');
%   [centers,radii] = imfindcircles(img,[20 30],...
%      'Sensitivity',0.8500,...
%      'EdgeThreshold',0.30,...
%      'Method','PhaseCode',...
%      'ObjectPolarity','Bright');
%   figure
%   subplot(1,2,1);
%   imshow(img)
%   mask = createCirclesMask(img,centers,radii);
%   subplot(1,2,2);
%   imshow(mask)
%
%%% EXAMPLE 2:
%   % Note: Mask creation is the same as in Example 1, but the image is
%   % passed in, rather than the size of the image.
%
%   img = imread('coins.png');
%   [centers,radii] = imfindcircles(img,[20 30],...
%      'Sensitivity',0.8500,...
%      'EdgeThreshold',0.30,...
%      'Method','PhaseCode',...
%      'ObjectPolarity','Bright');
%   mask = createCirclesMask(size(img),centers,radii);
%
% See Also: imfindcircles, viscircles, CircleFinder
%
% Brett Shoelson, PhD
% 9/22/2014
% Comments, suggestions welcome: brett.shoelson@mathworks.com
% Copyright 2014 The MathWorks, Inc.

	[xDim,yDim] = size(Iv);

centers = cent;
radii =r;
xc = centers(:,1);
yc = centers(:,2);
[xx,yy] = meshgrid(1:yDim,1:xDim);
mask = false(xDim,yDim);
for ii = 1:numel(radii)
	mask = mask | hypot(xx - xc(ii), yy - yc(ii)) <= radii(ii);
end
