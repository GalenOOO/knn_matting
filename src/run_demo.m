clear
close all

disp('starting the KNN Matting demo');
run ('../vlfeat-0.9.20/toolbox/vl_setup');

%%
    image = imread('test.jpg');
%     image = imread('input.png');
 
    gray = rgb2gray(image);
    edge = edge(gray,'canny',[0.04 0.08]);
    
     %strel函数的功能是运用各种形状和大小构造结构元素
    element = strel('disk',5);%这里是创建一个半径为5的平坦型圆盘结构元素
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
%     edge = imdilate(edge,element);
%     edge = imdilate(edge,element);
	edge = imerode(edge,element);
   	edge = imerode(edge,element);
	edge = imerode(edge,element);
	
    edge = imdilate(edge,element); 
    edge = imdilate(edge,element);
    edge = imdilate(edge,element);
%     edge = imdilate(edge,element);
%     edge = imdilate(edge,element);
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

input_resize = imresize(knn_input,[313 208], 'bilinear');
trimap_resize = imresize(knn_trimap,[313 208], 'bilinear');
trimap_resize = reshape(trimap_resize(:,:,1), [], 1);

%%
lambda = 100;
level  = 1;

tic
knn_mask = knn_matting(input_resize, trimap_resize, lambda, level);
toc

%%

back = im2double(imread('background.jpg'));
knn_back_resize = imresize(back,[313 500], 'bilinear');

%%
knn_image_r = double(input_resize(:,:,1));
knn_image_g = double(input_resize(:,:,2));
knn_image_b = double(input_resize(:,:,3));

back_r = double(knn_back_resize(:,:,1));
back_g = double(knn_back_resize(:,:,2));
back_b = double(knn_back_resize(:,:,3));

knn_matting_image(:,:,1) = knn_image_r .* knn_mask;
knn_matting_image(:,:,2) = knn_image_g .* knn_mask;
knn_matting_image(:,:,3) = knn_image_b .* knn_mask;

back_r(:,146:353) = back_r(:,146:353) .* (1.0-knn_mask) + knn_image_r .* knn_mask;
back_g(:,146:353) = back_g(:,146:353) .* (1.0-knn_mask) + knn_image_g .* knn_mask;
back_b(:,146:353) = back_b(:,146:353) .* (1.0-knn_mask) + knn_image_b .* knn_mask;

knn_matting_back(:,:,1) = back_r;
knn_matting_back(:,:,2) = back_g;
knn_matting_back(:,:,3) = back_b;
knn_result =  knn_matting_back;


%%
% knn_image_r = double(input_resize(:,:,1));
% knn_image_g = double(input_resize(:,:,2));
% knn_image_b = double(input_resize(:,:,3));
% 
% back_r = double(knn_back_resize(:,:,1));
% back_g = double(knn_back_resize(:,:,2));
% back_b = double(knn_back_resize(:,:,3));
% 
% knn_matting_image(:,:,1) = knn_image_r .* knn_mask;
% knn_matting_image(:,:,2) = knn_image_g .* knn_mask;
% knn_matting_image(:,:,3) = knn_image_b .* knn_mask;
% 
% knn_matting_back(:,:,1) = back_r .* (1.0-knn_mask);
% knn_matting_back(:,:,2) = back_g .* (1.0-knn_mask);
% knn_matting_back(:,:,3) = back_b .* (1.0-knn_mask);
% 
% knn_result = knn_matting_image + knn_matting_back;

%%

% knn_result = uint8(knn_matting_image);

figure; imshow(knn_result,[]);title('result');

