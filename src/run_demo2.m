clear
close all
disp('starting the KNN Matting demo');
run ('../vlfeat-0.9.20/toolbox/vl_setup');

%%
%     image = imread('test.jpg');
    image = imread('input.png');
 
    gray = rgb2gray(image);
    edge = edge(gray,'canny',[0.04 0.08]);
    
     %strel函数的功能是运用各种形状和大小构造结构元素
    element = strel('disk',7);%这里是创建一个半径为5的平坦型圆盘结构元素
    edge = imdilate(edge,element);%图像A1被结构元素B膨胀
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);

	edge = imerode(edge,element);
   	edge = imerode(edge,element);
	edge = imerode(edge,element);

	edge = imdilate(edge,element); 
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
	edge = imerode(edge,element);
   	edge = imerode(edge,element);
	edge = imerode(edge,element);
	
    edge = imdilate(edge,element); 
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
	edge = imerode(edge,element);
   	edge = imerode(edge,element);
	edge = imerode(edge,element);   
    edge = imfill(edge,'holes');
    
    
    test = bwperim(edge);                   %轮廓提取  
%     element = strel('disk',5);%这里是创建一个半径为5的平坦型圆盘结构元素
    test = imdilate(test,element); 
    test = imdilate(test,element);
    test = imdilate(test,element);
    test = imdilate(test,element); 
    test = imdilate(test,element);
    test = imdilate(test,element);
    test = imdilate(test,element); 
    test = imdilate(test,element);
    test = imdilate(test,element);
     
    test = uint8(test);
    test1 = test * 125;
    test = imfill(test,'holes');
    trimap = test*255 - test1;
    figure,imshow(trimap);title('trimap');
    
%%
% knn_input  = im2double(imread('input.png'));
% knn_trimap = im2double(imread('trimap.png'));
knn_input  = im2double(image);
knn_trimap = im2double(trimap);

input_resize = imresize(knn_input,[500 750], 'bilinear');
trimap_resize = imresize(knn_trimap,[500 750], 'bilinear');
trimap_resize = reshape(trimap_resize(:,:,1), [], 1);

%%
lambda = 100;
level  = 1;

tic
knn_mask = knn_matting(input_resize, trimap_resize, lambda, level);
toc

%%

back = im2double(imread('background.jpg'));
back_resize = imresize(back,[500 750], 'bilinear');
%%

image_r = input_resize(:,:,1);
image_g = input_resize(:,:,2);
image_b = input_resize(:,:,3);
back_r = back_resize(:,:,1);
back_g = back_resize(:,:,2);
back_b = back_resize(:,:,3);
mask = knn_mask;

matting_image(:,:,1) = image_r .* mask;
matting_image(:,:,2) = image_g .* mask;
matting_image(:,:,3) = image_b .* mask;

matting_back(:,:,1) = back_r .* (1.0-mask);
matting_back(:,:,2) = back_g .* (1.0-mask);
matting_back(:,:,3) = back_b .* (1.0-mask);

result = matting_image + matting_back;

figure;imshow(result,[]);title('result');

