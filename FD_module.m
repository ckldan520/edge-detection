function [ output_pic ] = FD_module( org_pic,v )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    if numel(size(org_pic))>2
       I = rgb2gray(org_pic);%�Ҷ�ת��
    else
        I=org_pic;
    end
    I = double(I);%ת��Ϊ˫����
%%  Step1��ʹ�ø�˹�˲�ƽ��ͼ��
    B = [1 2 1;2 4 2;1 2 1];%��˹�˲�ϵ��
    B = 1/16.*B;%��˹�˲�ģ�� ����=0.8
    A = conv2(I,B,'same');%ʹ�ø�˹ģ����о��.�����ά���,�����ԭͼ���С��ͬ

%%  Step2�������ݶȵķ�ֵͼ��
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
    
    gx = conv2(A,X_mask,'same');%"x"������ͼ��
    gy = conv2(A,Y_mask,'same');%"y"������ͼ��
    
    b= sqrt((gx.^2) + (gy.^2));%
    
    X_mask=[abs(a13) abs(a12) abs(a11) 0 -abs(a11) -abs(a12) -abs(a13)]; 
    Y_mask=-X_mask';   
    gx = conv2(A,X_mask,'same');%"x"������ͼ��
    gy = conv2(A,Y_mask,'same');%"y"������ͼ��
    %% Step3:��ֵ��Ե��ȡ

    temp=b;
    [m,n]=size(temp);
    a = atan2(gy,gx);%��ȡ���ȣ���Χ��-pi~pi
    a = a*180/pi;%������ת��Ϊ�Ƕȣ��õ��Ƕ�ͼ����ԭͼ���С���.
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
    Nms = zeros(m,n);%����һ���Ǽ���ֵͼ��
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
    DT = zeros(m,n);%����һ��˫��ֵͼ��
    TL = 0.04 * max(max(Nms));%����ֵ
    TH = 0.08 * max(max(Nms));%����ֵ
    for i = 1  : m
        for j = 1 : n
            if (Nms(i, j) < TL)
                DT(i,j) = 0;
            elseif (Nms(i, j) > TH)
                DT(i,j) = 1 ;
            %��TL < Nms(i, j) < TH ʹ��8��ͨ����ȷ��
            elseif ( Nms(i+1,j) > TH || Nms(i-1,j) > TH || Nms(i,j+1) > TH || Nms(i,j-1) > TH || Nms(i-1, j-1) > TH || Nms(i-1, j+1) > TH || Nms(i+1, j+1) > TH || Nms(i+1, j-1) > TH)
                DT(i,j) = 1;
            end;
        end;
    end;
    figure, imshow(DT); %���յı�Ե���Ϊ��ֵͼ��
    output_pic=DT;
    grid on;
    title('FD_module');
end

