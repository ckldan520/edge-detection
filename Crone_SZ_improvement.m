function [ output_pic ] = Crone_SZ_improvement( org_pic,v )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   if numel(size(org_pic))>2
       I = rgb2gray(org_pic);%灰度转换
    else
       I =org_pic;
    end
    I = double(I);%转化为双精度
    [H,W] = size(I);%获取图像大小

%%  Step1：使用高斯滤波平滑图像

    B = [1 2 1;2 4 2;1 2 1];%高斯滤波系数
    B = 1/16.*B;%高斯滤波模板 方差=0.8
    A = conv2(I,B,'same');%使用高斯模板进行卷积.计算二维卷积,结果与原图像大小相同

%%  Step2：计算梯度的幅值图像
    a0=0;
    a1=(-1)*v;
    a2=v*(v-1)/2;
    a3=(-1)*v*(v-1)*(v-2)/6;
    a4=v*(v-1)*(v-2)*(v-3)/24;
    S_mask=[
    -a2 -a3 -a4;
    -a1 0 a1;
    a4 a3 a2;
    ];
    Z_mask=[
    a4 a3 a2;
    -a1 0 a1;
    -a2 -a3 -a4;
    ];

    gs = conv2(A,S_mask,'same');%"S"模板卷积图像
    gz = conv2(A,Z_mask,'same');%"Z"模板卷积图像
    b=abs(gs)+abs(gz);%对S+Z模板进行整合
    
    
    %%  Step3：阈值边缘提取
    [m,n]=size(A);
    %归一化图像
    for i=1:m
        for j=1:n
            if (b(i,j)>255)
                b(i,j)=255;
            end
            if  (b(i,j)<0)
                 b(i,j)=0;
            end
        end
    end
    min_count=min(min(b));
    max_count=max(max(b));
    for i=1:m
        for j=1:n
            b(i,j)=(b(i,j)-min_count)/(max_count-min_count);
        end
    end

    %阈值
    level=graythresh(b);
    
    for i=1:m
        for j=1:n
            if (b(i,j)>0.09)
                b(i,j)=1;
            else
                 b(i,j)=0;
            end
        end
    end
    output_pic=b;

    figure,imshow(output_pic);


    grid on;
    title('SZ_CRONE');




end

