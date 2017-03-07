function [ output_pic ] = Fraction_G_L( org_pic,v)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    if numel(size(org_pic))>2
       I = rgb2gray(org_pic);%�Ҷ�ת��
    else
        I=org_pic;
    end
    I = double(I);%ת��Ϊ˫����
    [H,W] = size(I);%��ȡͼ���С

    %%  Step1��ʹ�ø�˹�˲�ƽ��ͼ��

    B = [1 2 1;2 4 2;1 2 1];%��˹�˲�ϵ��
    B = 1/16.*B;%��˹�˲�ģ�� ����=0.8
    A = conv2(I,B,'same');%ʹ�ø�˹ģ����о��.�����ά���,�����ԭͼ���С��ͬ 

    %%  Step2��������Ĥ ���
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
      mask=mask/(4*v*v-12*v+8);%��һ��

    %  b = abs(conv2(A,mask,'same')); 
    b = abs(filter2(mask,A,'same')); 
    %%  Step3���ݶȵķ�ֵͼ��

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
    %��һ��ͼ��
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
%     a = atan2(fy,fx);%��ȡ���ȣ���Χ��-pi~pi
%     a = a*180/pi;%������ת��Ϊ�Ƕȣ��õ��Ƕ�ͼ����ԭͼ���С���.
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
%     Nms = zeros(m,n);%����һ���Ǽ���ֵͼ��
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
%     DT = zeros(m,n);%����һ��˫��ֵͼ��
%     TL = 0.06 * max(max(Nms));%����ֵ
%     TH = 0.15 * max(max(Nms));%����ֵ
%     for i = 1  : m
%         for j = 1 : n
%             if (Nms(i, j) < TL)
%                 DT(i,j) = 0;
%             elseif (Nms(i, j) > TH)
%                 DT(i,j) = 1 ;
%             %��TL < Nms(i, j) < TH ʹ��8��ͨ����ȷ��
%             elseif ( Nms(i+1,j) > TH || Nms(i-1,j) > TH || Nms(i,j+1) > TH || Nms(i,j-1) > TH || Nms(i-1, j-1) > TH || Nms(i-1, j+1) > TH || Nms(i+1, j+1) > TH || Nms(i+1, j-1) > TH)
%                 DT(i,j) = 1;
%             end;
%         end;
%     end;
%     figure, imshow(DT); %���յı�Ե���Ϊ��ֵͼ��
%     output_pic=DT;
    grid on;
    title('Tianis');
end

