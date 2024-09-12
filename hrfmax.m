clc;
clear all;
close all;
%%
path         = '';
origpath     = 'test\';
testpath     = 'test7\';
resultspath  = 'results\';
maskspath    = 'masks2\';
mskspath     = 'msk\';
crosspath    = 'testcross\';
resultspath2 = 'results2\';
maskscross   = 'maskscross\';

dsname       = 'HRF';
k = 8;
im = 9;
% im = 3;
r = 4;
n = 8;
b = 100;
x = 1000;
rc = 200;
rc1 = 150;
mt = 15;
cent = [1093,2720];
m = 5;
% 
% dsname         = 'DRIVE';
% k = 3;
% im = 7;
% m = 1;
% r = 2;
% n = 4;
% x = 500;
% b = 10;
% rc = 80;
% rc1 = 1;
% mt = 25;
% cent=[274,489];


% dsname         = 'Chase';
% k = 3;
% % im = 4;
% im = 2;
% r = 2;
% n = 4;
% x = 300;
% rc = 100;
% rc1  = 70;
% mt = 10;
% cent = [448,514];



imfiles     = dir(fullfile([path,testpath],[dsname,'*']));
imtotal     = numel(imfiles);
gtfiles     = dir(fullfile([path,maskspath],[dsname,'*']));

resultfiles = dir(fullfile([path,resultspath],[dsname,'*']));
origfiles   = dir(fullfile([path,origpath],[dsname,'*']));

f = 0;
idx = 0;

    switch(k)
        case 1
            defaultoptions = struct('FrangiScaleRange', [1 5], 'FrangiScaleRatio', 1, 'FrangiBetaOne', .25, 'FrangiBetaTwo', 5, 'verbose',true,'BlackWhite',true);
        case 2
            defaultoptions = struct('FrangiScaleRange', [1 5], 'FrangiScaleRatio', 1, 'FrangiBetaOne', .25, 'FrangiBetaTwo', 10, 'verbose',true,'BlackWhite',true);
        case 3
            defaultoptions = struct('FrangiScaleRange', [1 5], 'FrangiScaleRatio', 2, 'FrangiBetaOne', .5, 'FrangiBetaTwo', 10, 'verbose',true,'BlackWhite',true);
        case 4
            defaultoptions = struct('FrangiScaleRange', [1 10], 'FrangiScaleRatio', 2, 'FrangiBetaOne', .25, 'FrangiBetaTwo', 5, 'verbose',false,'BlackWhite',true);
        case 5
            defaultoptions = struct('FrangiScaleRange', [1 10], 'FrangiScaleRatio', 2, 'FrangiBetaOne', .25, 'FrangiBetaTwo', 10, 'verbose',false,'BlackWhite',true);
        case 6
            defaultoptions = struct('FrangiScaleRange', [1 10], 'FrangiScaleRatio', 2, 'FrangiBetaOne', .5, 'FrangiBetaTwo', 15, 'verbose',false,'BlackWhite',true);
        case 7
            defaultoptions = struct('FrangiScaleRange', [1 15], 'FrangiScaleRatio', 2, 'FrangiBetaOne', .25, 'FrangiBetaTwo', 5, 'verbose',true,'BlackWhite',true);
        case 8
            defaultoptions = struct('FrangiScaleRange', [1 25], 'FrangiScaleRatio', 2, 'FrangiBetaOne', .75, 'FrangiBetaTwo', 15, 'verbose',false,'BlackWhite',true);

    end
    for i = im:im%1:imtotal%
        fileaddress       = strcat(path,testpath,imfiles(i).name);
        gtaddress         = strcat(path,maskspath,gtfiles(i).name);
        resultaddress     = strcat(path,resultspath,resultfiles(i).name);

        file              = imread(fileaddress);
        thresh = multithresh(file,5);
        t = thresh(4);
        file(file>t) = t;
        origaddress       = strcat(path,origpath,origfiles(i).name);
        orig              = imread(origaddress);
        orig              = orig(:,:,2);
        mask              = orig;
        mask(mask<=mt)    = 0;
        mask(mask>mt)     = 1;
        file              = mask.*file;
%         file              = adapthisteq(file);
%         [m,cent]          = max2(file);
                  
        cm                = circle(file,cent,rc,rc1);
        gt                = imread(gtaddress);
        result            = imread(resultaddress);

        if ndims(mask) ~= 2
            mask = mask(:,:,1);
        end
        s                 = size(file);
        result            = imresize(result,s);
        Ivessel           = FrangiFilter2D(double(file),defaultoptions);
        se                = strel('disk',r,n);
        Ivessel           = imclose(Ivessel,se);
        result            = imclose(result,se);
%         Iv                = imbinarize(Ivessel);
        Iv                = blockproc(m*Ivessel, [b b], @(block) (adapthisteq(block.data)), 'Border', [4 4]);
        Iv                = bwareaopen(imbinarize(Iv),x);
        Iv                = Iv.*cm;
        res               = imbinarize(result)+(Iv);
        resul             = imclose(res,se);
        resl(:,:,i)       = resul.*double(mask);
        resl(:,:,i)       = bwareaopen(resl(:,:,i),50);
        i1 = i;
        g(:,:,i1) = performance_eval(resl(:,:,i),uint8(gt));
        
        if g(1,5,i1)>f
            f = g(1,5,i1);
            idx = i1;
            a = g(:,:,i1);
        end
    end

imshow(orig);
figure;
imshow(file);
figure;
imshow(gt);
figure;
imshow(mask*255);
figure;
imshow(result);
figure;
imshow(2*Ivessel);
figure;
imshow(Iv);
figure;
imshow(resl(:,:,idx));

rsp = bwmorph(resl(:,:,idx),'spur',inf);
figure;
imshow(rsp)

rst(:,:) = g(1,:,:);
rst = rst';

% cent1 = [301,281];
% rc1 = 280;
% rc11 = 260;
% cm1 = circle(file,cent1,rc1,rc11);
% figure;
% imshow(resl(:,:,idx).*cm1);
% gg = resl(:,:,idx).*cm1;
% performance_eval(gg,uint8(gt));