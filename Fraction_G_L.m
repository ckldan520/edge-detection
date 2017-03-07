function [ output_pic ] = Fraction_G_L( org_pic,v)
%UNTITLED3 Summary of this function goes here
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

    %%  Step2：构造掩膜 卷积
    a0=1;
    a1=-v;
    a2=-v*(-v+1)/2;

    mask=[
        a2 0 a2 0 a2;
        0  a1 a1 a1 0;
        a2 a1 8*a0 a1 a2;
        0  a1 a1  a1 0;
        a2 0 a2 0 a2;
          ];
      mask=mask/(4*v*v-12*v+8);%归一化

    %  b = abs(conv2(A,mask,'same')); 
    b = abs(filter2(mask,A,'same')); 
    %%  Step3：梯度的幅值图像

    b=abs(b-A);
    for i=1:H
        for j=1:W
            if (b(i,j)>255)
                b(i,j)=255;
            end
            if  (b(i,j)<0)
                 b(i,j)=0;
            end
        end
    end
    %归一化图像
    min_count=min(min(b));
    max_count=max(max(b));
    for i=1:H
        for j=1:W
            b(i,j)=(b(i,j)-min_count)/(max_count-min_count);
        end
    end
    level=graythresh(b);

    %9
    for i=1:H
        for j=1:W
            if (b(i,j)>0.1)
               b(i,j)=1;
            else
                 b(i,j)=0;
            end
        end
    end
    figure,imshow(b);
    output_pic=b;

%     temp=b;
%     [m,n]=size(temp);
%     [fx,fy]=gradient(temp);
%     a = atan2(fy,fx);%获取弧度，范围：-pi~pi
%     a = a*180/pi;%将弧度转换为角度，得到角度图像，与原图像大小相等.
%     for i = 1:m
%         for j = 1:n
%             if((a(i,j) >= -22.5) && (a(i,j) < 0)||(a(i,j) >= 0) && (a(i,j) < 22.5) || (a(i,j) <= -157.5) && (a(i,j) >= -180)||(a(i,j) >= 157.5)&&(a(i,j) <= 180))
%                 a(i,j) = 0;
%             elseif((a(i,j) >= 22.5) && (a(i,j) < 67.5) || (a(i,j) <= -112.5) && (a(i,j) > -157.5))
%                 a(i,j) = -45;
%             elseif((a(i,j) >= 67.5) && (a(i,j) < 112.5) || (a(i,j) <= -67.5) && (a(i,j) >- 112.5))
%                 a(i,j) = 90;
%             elseif((a(i,j) >= 112.5) && (a(i,j) < 157.5) || (a(i,j) <= -22.5) && (a(i,j) > -67.5))
%                 a(i,j) = 45;  
%             end
%         end
%     end
%     Nms = zeros(m,n);%定义一个非极大值图像
%     for i = 2:m-1
%         for j= 2:n-1
%             if (a(i,j) == 0 && temp(i,j) == max([temp(i,j), temp(i,j+1), temp(i,j-1)]))
%                 Nms(i,j) = temp(i,j);
%             elseif (a(i,j) == 45 && temp(i,j) == max([temp(i,j), temp(i+1,j-1), temp(i-1,j+1)]))
%                 Nms(i,j) = temp(i,j);
%             elseif (a(i,j) == 90 && temp(i,j) == max([temp(i,j), temp(i+1,j), temp(i-1,j)]))
%                 Nms(i,j) = temp(i,j);
%             elseif (a(i,j) == -45 && temp(i,j) == max([temp(i,j), temp(i+1,j+1), temp(i-1,j-1)]))
%                 Nms(i,j) = temp(i,j);
%             end;
%         end;
%     end;
%     DT = zeros(m,n);%定义一个双阈值图像
%     TL = 0.06 * max(max(Nms));%低阈值
%     TH = 0.15 * max(max(Nms));%高阈值
%     for i = 1  : m
%         for j = 1 : n
%             if (Nms(i, j) < TL)
%                 DT(i,j) = 0;
%             elseif (Nms(i, j) > TH)
%                 DT(i,j) = 1 ;
%             %对TL < Nms(i, j) < TH 使用8连通区域确定
%             elseif ( Nms(i+1,j) > TH || Nms(i-1,j) > TH || Nms(i,j+1) > TH || Nms(i,j-1) > TH || Nms(i-1, j-1) > TH || Nms(i-1, j+1) > TH || Nms(i+1, j+1) > TH || Nms(i+1, j-1) > TH)
%                 DT(i,j) = 1;
%             end;
%         end;
%     end;
%     figure, imshow(DT); %最终的边缘检测为二值图像
%     output_pic=DT;
    grid on;
    title('Tianis');
end

