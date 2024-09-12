clc;
clear all;
close all;
%%
path         = '';
testpath     = 'test7\';
resultspath  = 'results\';
maskspath    = 'masks2\';
crosspath    = 'testcross\';
resultspath2 = 'results2\';
maskscross   = 'maskscross\';

imfiles    = dir(fullfile([path,testpath],'Chase*'));
imtotal     = numel(imfiles);


for i = 4:4
    fileaddress       = strcat(path,testpath,imfiles(i).name);
    file              = imread(fileaddress);
    center            = [502,486];
    mask              = createCirclesMask(file,center,(990/2-40));
    imwrite(mask,"D:\Anumeha\SEM9\Journal2\msk\Chase14L.jpeg");
    file(file>20)      = 255;
    figure
    imshow(file.*imcomplement(uint8(mask)));

    figure
    imshow(mask);
end



    