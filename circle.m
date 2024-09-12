function img = circle(im,cent,r,r1)

ss = size(im);




radius =r;
for i = 1:ss(1)
    for j = 1:ss(2)
        centr = sqrt((cent(1)-i)^2+(cent(2)-j)^2);
        if centr<radius && centr>r1
            img(i,j) = 0;
        else
            img(i,j) = 1;
        end

    end
end

% img = imcomplement(img);

imshow(img);