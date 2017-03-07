function [ output_pic ] = FD_module( org_pic,v )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    if numel(size(org_pic))>2
       I = rgb2gray(org_pic);%灰度转换
    else
        I=org_pic;
    end
    I = double(I);%转化为双精度
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
    
    a11=a1*(-1-(-1)^(v-1));
    a12=a2*(1-(-1)^(v-2));
    a13=a3*(-1-(-1)^(v-3));
    a21=a1*((-1)^(v-1)+1);
    a22=a2*((-1)^(v-2)-1);
    a23=a3*((-1)^(v-3)+1);
  
    
    X_mask=[a13 a12 a11 0 a21 a22 a23];
    Y_mask=-X_mask';
    
    gx = conv2(A,X_mask,'same');%"x"方向卷积图像
    gy = conv2(A,Y_mask,'same');%"y"方向卷积图像
    
    b= sqrt((gx.^2) + (gy.^2));%
    
    X_mask=[abs(a13) abs(a12) abs(a11) 0 -abs(a11) -abs(a12) -abs(a13)]; 
    Y_mask=-X_mask';   
    gx = conv2(A,X_mask,'same');%"x"方向卷积图像
    gy = conv2(A,Y_mask,'same');%"y"方向卷积图像
    %% Step3:阈值边缘提取

    temp=b;
    [m,n]=size(temp);
    a = atan2(gy,gx);%获取弧度，范围：-pi~pi
    a = a*180/pi;%将弧度转换为角度，得到角度图像，与原图像大小相等.
    for i = 1:m
        for j = 1:n
            if((a(i,j) >= -22.5) && (a(i,j) < 0)||(a(i,j) >= 0) && (a(i,j) < 22.5) || (a(i,j) <= -157.5) && (a(i,j) >= -180)||(a(i,j) >= 157.5)&&(a(i,j) <= 180))
                a(i,j) = 0;
            elseif((a(i,j) >= 22.5) && (a(i,j) < 67.5) || (a(i,j) <= -112.5) && (a(i,j) > -157.5))
                a(i,j) = 45;
            elseif((a(i,j) >= 67.5) && (a(i,j) < 112.5) || (a(i,j) <= -67.5) && (a(i,j) >- 112.5))
                a(i,j) = 90;
            elseif((a(i,j) >= 112.5) && (a(i,j) < 157.5) || (a(i,j) <= -22.5) && (a(i,j) > -67.5))
                a(i,j) = -45;  
            end
        end
    end
    Nms = zeros(m,n);%定义一个非极大值图像
    for i = 2:m-1
        for j= 2:n-1
            if (a(i,j) == 0 && temp(i,j) == max([temp(i,j), temp(i,j+1), temp(i,j-1)]))
                Nms(i,j) = temp(i,j);
            elseif (a(i,j) == 45 && temp(i,j) == max([temp(i,j), temp(i+1,j-1), temp(i-1,j+1)]))
                Nms(i,j) = temp(i,j);
            elseif (a(i,j) == 90 && temp(i,j) == max([temp(i,j), temp(i+1,j), temp(i-1,j)]))
                Nms(i,j) = temp(i,j);
            elseif (a(i,j) == -45 && temp(i,j) == max([temp(i,j), temp(i+1,j+1), temp(i-1,j-1)]))
                Nms(i,j) = temp(i,j);
            end;
        end;
    end;
    DT = zeros(m,n);%定义一个双阈值图像
    TL = 0.04 * max(max(Nms));%低阈值
    TH = 0.08 * max(max(Nms));%高阈值
    for i = 1  : m
        for j = 1 : n
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
    title('FD_module');
end

