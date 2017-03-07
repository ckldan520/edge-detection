function [ output_pic ] = first_improve_GL( org_pic,v )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    if numel(size(org_pic))>2
       I = rgb2gray(org_pic);%灰度转换
    else
        I =org_pic;
    end
    I = double(I);%转化为双精度
    [Height,Width] = size(I);%获取图像大小

    %%  Step1：使用高斯滤波平滑图像

    B = [1 2 1;2 4 2;1 2 1];%高斯滤波系数
    B = 1/16.*B;%高斯滤波模板 方差=0.8
    A = conv2(I,B,'same');%使用高斯模板进行卷积.计算二维卷积,结果与原图像大小相同 


    %%  Step2：构造掩膜 卷积
    a0=1;
    a1=-v;
    a2=-v*(-v+1)/2;
    a3=(4*v*v-12*v+8);%归一化

    mask_0=[
        0  0   0;
        1  a1  a2;
        0  0   0;
            ];
    mask_45=[
        0    0   a2;
        0    a1  0 ;
        1    0   0 ;
            ];
    mask_90=[
        0  a2  0;
        0  a1  0;
        0  1   0;];
    mask_135=[
        a2 0  0;
        0  a1  0;
        0  0   1;];
    mask_180=[
        0   0  0;
        a2  a1   1;
        0   0   0;];
    mask_225=[
        0   0  1;
        0  a1  0;
        a2  0   0;];
    mask_270=[
        0  1  0;
        0  a1  0;
        0  a2  0;];
    mask_315=[
        1  0  0;
        0 a1  0;
        0  0  a2;
        ];

    temp_pic1 = A;%定义一个初始图像
    temp_pic2 = A;%定义一个初始图像
    temp_pic3 =A;%定义一个初始图像



for i=3:Height-2
    for  j=3:Width-2
        W(1)=A(i,j)+A(i,j+1)*a1+A(i,j+2)*a2;
        W(2)=A(i,j)+A(i-1,j+1)*a1+A(i-2,j+2)*a2;
        W(3)=A(i,j)+A(i-1,j)*a1+A(i-2,j)*a2;
        W(4)=A(i,j)+A(i-1,j-1)*a1+A(i-2,j-2)*a2;
        W(5)=A(i,j)+A(i,j-1)*a1+A(i,j-2)*a2;
        W(6)=A(i,j)+A(i+1,j-1)*a1+A(i+2,j-2)*a2;
        W(7)=A(i,j)+A(i+1,j)*a1+A(i+2,j)*a2;
        W(8)=A(i,j)+A(i+1,j+1)*a1+A(i+2,j+2)*a2;
        %方法一    
        impove_sum_W1=[(W(1)+W(3)+W(5)+W(7)),(W(2)+W(4)+W(6)+W(8))];
        temp_pic1(i,j)=max(impove_sum_W1)*2/a3;
        %方法二
        impove_sum_W2=[(W(1)+W(5)),(W(2)+W(6)),(W(3)+W(7)),(W(4)+W(8))];
        temp_pic2(i,j)=max(impove_sum_W2)*4/a3;
        %方法三
        temp_pic3(i,j)=max(W)*8/a3;
    end
end

%%   Step3：梯度的幅值图像
   

%    b1=abs(temp_pic1-A);
%    min_count=min(min(b1));
%    max_count=max(max(b1));
%    for i=1:Height
%      for j=1:Width
%         b1(i,j)=(b1(i,j)-min_count)/(max_count-min_count);
%      end
%    end
%     level=graythresh(b1);
%    for i=1:Height
%     for j=1:Width
%         if (b1(i,j)>level)
%             b1(i,j)=1;
%         else
%              b1(i,j)=0;
%         end
%     end
%    end
   % figure,imshow(b1);
    
    
%    b2=abs(temp_pic2-A);
%    min_count=min(min(b2));
%    max_count=max(max(b2));
%    for i=1:Height
%      for j=1:Width
%         b2(i,j)=(b2(i,j)-min_count)/(max_count-min_count);
%      end
%    end
%     level=graythresh(b2);
%    for i=1:Height
%     for j=1:Width
%         if (b2(i,j)>level)
%             b2(i,j)=1;
%         else
%              b2(i,j)=0;
%         end
%     end
%    end
    %figure,imshow(b2);
    
    
     
 
   b3=abs(temp_pic3-A);
%    min_count=min(min(b3));
%    max_count=max(max(b3));
%    for i=1:Height
%      for j=1:Width
%         b3(i,j)=(b3(i,j)-min_count)/(max_count-min_count);
%      end
%    end
%     level=graythresh(b3);
%    for i=1:Height
%     for j=1:Width
%         if (b3(i,j)>0.12)
%             b3(i,j)=1;
%         else
%              b3(i,j)=0;
%         end
%     end
%    end
%     figure,imshow(b3);

 
    temp=b3;
    [m,n]=size(temp);
    [fx,fy]=gradient(temp);
    a = atan2(fy,fx);%获取弧度，范围：-pi~pi
    a = a*180/pi;%将弧度转换为角度，得到角度图像，与原图像大小相等.
    for i = 1:m
        for j = 1:n
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
    TL = 0.06 * max(max(Nms));%低阈值
    TH = 0.15 * max(max(Nms));%高阈值
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
    title('improve-Tianis');
end


















