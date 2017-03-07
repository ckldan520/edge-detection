function [ output_pic ] = Sobel( org_pic )
%SOBEL Summary of this function goes here
%   Detailed explanation goes here
    if numel(size(org_pic))>2
       A = rgb2gray(org_pic);%灰度转换
    else
        A =org_pic;
    end
    

    figure,imshow(A);

    %%  Step1：使用高斯滤波平滑图像

    B = [1 2 1;2 4 2;1 2 1];%高斯滤波系数
    B = 1/16.*B;%高斯滤波模板 方差=0.8
    A = conv2(A,B,'same');%使用高斯模板进行卷积.计算二维卷积,结果与原图像大小相同 


    %%  Step2：构造掩膜 卷积

    kx=1;
    ky=1;
    %定义滤波器
    op= [-1 -2 -1;0 0 0;1 2 1]/8;
    y_mask=op;
    x_mask=op';
    %用滤波器与图像卷积，求得水平和竖直方向的图片
    bx = abs(filter2(x_mask,A,'same')); 
    by = abs(filter2(y_mask,A,'same'));

    b = kx*bx.*bx + ky*by.*by;

    %%  Step3：计算梯度的幅值图像,角度图像.
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
            if (b(i,j)>level)
                b(i,j)=1;
            else
                 b(i,j)=0;
            end
        end
    end


    output_pic=b;

    for i=2:m-1
        for j=2:n-1
            if (b(i,j)>level&&((bx(i,j)>kx*by(i,j) && output_pic(i,j-1)<output_pic(i,j) && output_pic(i,j+1)<output_pic(i,j) ) || (by(i,j)>ky*bx(i,j) && output_pic(i-1,j)<output_pic(i,j) &&output_pic(i+1,j)<output_pic(i,j))))
               output_pic(i,j)=1;
            else
               output_pic(i,j)=0;
            end
        end
    end

    figure,imshow(output_pic);
    grid on;
    title('Sobel');
end








