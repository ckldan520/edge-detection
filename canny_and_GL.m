function [ output_pic ] = canny_and_GL( org_pic )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if numel(size(org_pic))>2
       I = rgb2gray(org_pic);%灰度转换
    else
        I=org_pic;
    end
    I = double(I);%转化为双精度
    [H,W] = size(I);%获取图像大小
 %%  Step1：使用高斯滤波平滑图像
    B = [1 2 1;2 4 2;1 2 1];%高斯滤波系数
    B = 1/16.*B;%高斯滤波模板 方差=0.8
    A = conv2(I,B,'same');%使用高斯模板进行卷积.计算二维卷积,结果与原图像大小相同 
%%  Step2：计算梯度的幅值图像,角度图像.
    %Prewitt梯度模板
    dy = [
        0.0295 0.1387 0.3126 0.1387 0.0295;
        0.0347 0.1768 0.4472 0.1768 0.0347;
        0 0 0 0 0;
       -0.0347 -0.1768 -0.4472 -0.1768 -0.0347; 
       -0.0295 -0.1387 -0.3126 -0.1387 -0.0295;
    ];%x方向的梯度模板
    
    dx = -dy';
    gx = conv2(A,dx,'same');%获取x方向的梯度图像.使用梯度模板进行二维卷积,结果与原图像大小相同
    gy = conv2(A,dy,'same');%获取y方向的梯度图像.使用梯度模板进行二维卷积,结果与原图像大小相同
    M = sqrt((gx.^2) + (gy.^2));%获取幅值图像.大小与原图像相等.(.^)表示数组乘方
    a = atan2(gy,gx);%获取弧度，范围：-pi~pi
    a = a*180/pi;%将弧度转换为角度，得到角度图像，与原图像大小相等.
    
%%  Step3：对幅值图像进行应用非极大值抑制
    %首先将角度划分成四个方向范围:水平(0°)、-45°、垂直(90°)、+45°
    for i = 1:H
        for j = 1:W
            if((a(i,j) >= -22.5) && (a(i,j) < 0)||(a(i,j) >= 0) && (a(i,j) < 22.5) || (a(i,j) <= -157.5) && (a(i,j) >= -180)||(a(i,j) >= 157.5)&&(a(i,j) <= 180))
                a(i,j) = 0;
            elseif((a(i,j) >= 22.5) && (a(i,j) < 67.5) || (a(i,j) <= -112.5) && (a(i,j) > -157.5))
                a(i,j) = -45;
            elseif((a(i,j) >= 67.5) && (a(i,j) < 112.5) || (a(i,j) <= -67.5) && (a(i,j) >- 112.5))
                a(i,j) = 90;
            elseif((a(i,j) >= 112.5) && (a(i,j) < 157.5) || (a(i,j) <= -22.5) && (a(i,j) > -67.5))
                a(i,j) = 45;  
            end
        end
    end
    %讨论对3x3区域的四个基本边缘方向进行非极大值抑制.获取非极大值抑制图像
    Nms = zeros(H,W);%定义一个非极大值图像
    for i = 2:H-1
        for j= 2:W-1
            if (a(i,j) == 0 && M(i,j) == max([M(i,j), M(i,j+1), M(i,j-1)]))
                Nms(i,j) = M(i,j);
            elseif (a(i,j) == -45 && M(i,j) == max([M(i,j), M(i+1,j-1), M(i-1,j+1)]))
                Nms(i,j) = M(i,j);
            elseif (a(i,j) == 90 && M(i,j) == max([M(i,j), M(i+1,j), M(i-1,j)]))
                Nms(i,j) = M(i,j);
            elseif (a(i,j) == 45 && M(i,j) == max([M(i,j), M(i+1,j+1), M(i-1,j-1)]))
                Nms(i,j) = M(i,j);
            end;
        end;
    end;

    %%  Step4:双阈值检测和连接边缘

    DT = zeros(H,W);%定义一个双阈值图像
    TL = 0.02 * max(max(Nms));%低阈值
    TH = 0.07 * max(max(Nms));%高阈值
    for i = 1  : H
        for j = 1 : W
            if (Nms(i, j) < TL)
                DT(i,j) = 0;
            elseif (Nms(i, j) > TH)
                DT(i,j) = 1 ;
            %对TL < Nms(i, j) < TH 使用8连通区域确定
            elseif ( Nms(i+1,j) > TH || Nms(i-1,j) > TH || Nms(i,j+1) > TH || Nms(i,j-1) > TH || Nms(i-1, j-1) > TH || Nms(i-1, j+1) > TH || Nms(i+1, j+1) > TH || Nms(i+1, j-1) > TH)
                DT(i,j) = 1;
            end;
        end;
    end;
    figure, imshow(DT); %最终的边缘检测为二值图像
    output_pic=DT;
    grid on;
    title('canny_GL');

end

