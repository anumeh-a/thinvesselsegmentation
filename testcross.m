clc;
clear all;
close all;
%%
path         = '';
testpath     = 'testcross\';
resultspath  = 'results2\';
maskspath    = 'maskscross\';


origfiles   = dir(fullfile([path,testpath],'*.ppm'));
imfiles     = dir(fullfile([path,testpath],'*.jpg'));
imtotal     = numel(imfiles);
gtfiles     = dir(fullfile([path,maskspath],'*.jpg'));
resultfiles = dir(fullfile([path,resultspath],'*.jpg'));

f = 0;
idx = 0;
for k = 8:8
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
    for i = 12:12
        origaddress       = strcat(path,testpath,origfiles(i).name);
        fileaddress       = strcat(path,testpath,imfiles(i).name);
        gtaddress         = strcat(path,maskspath,gtfiles(i).name);
        resultaddress     = strcat(path,resultspath,resultfiles(i).name);
        file              = imread(fileaddress);
        orig              = imread(origaddress);
        orig              = orig(:,:,2);
        orig(orig<35)     = 0;
        orig(orig>=35)    = 1;
        file              = file.*orig;
        
        [m,cent]          = max2(file);
        cent              = [318,327];
        cm                = circle(file,cent,100,50);
        gt                = imread(gtaddress);
        result            = imread(resultaddress);
        
        s                 = size(file);
        result            = imresize(result,s);
        Ivessel           = FrangiFilter2D(double(file),defaultoptions);
        se                = strel('disk',2,4);
%         Ivessel           = imclose(Ivessel,se);
%         result            = imclose(result,se);
        Iv                = imbinarize(Ivessel);
        Iv                = bwareaopen(Iv,50);
        Iv                = Iv.*cm;
        res               = imbinarize(result)+(Iv);
%         resul             = imclose(res,se);
        resl(:,:,i)       = res.*double(orig);

        g(:,:,i) = performance_eval(resl(:,:,i),uint8(gt));
        if g(1,5,i)>f
            f = g(1,5,i);
            idx = i;
            a = g(:,:,i);
        end
    end
end
imshow(orig);
figure;
imshow(file);
figure;
imshow(gt);
figure;
imshow(result);
figure;
imshow(Ivessel);
figure;
imshow(Iv);
figure;
imshow(resl(:,:,idx));

rst(:,:) = g(1,:,:);
rst = rst';
