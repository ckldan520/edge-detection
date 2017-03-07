function [ output_pic ] = first_improve_GL( org_pic,v )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    if numel(size(org_pic))>2
       I = rgb2gray(org_pic);%�Ҷ�ת��
    else
        I =org_pic;
    end
    I = double(I);%ת��Ϊ˫����
    [Height,Width] = size(I);%��ȡͼ���С

    %%  Step1��ʹ�ø�˹�˲�ƽ��ͼ��

    B = [1 2 1;2 4 2;1 2 1];%��˹�˲�ϵ��
    B = 1/16.*B;%��˹�˲�ģ�� ����=0.8
    A = conv2(I,B,'same');%ʹ�ø�˹ģ����о��.�����ά���,�����ԭͼ���С��ͬ 


    %%  Step2��������Ĥ ���
    a0=1;
    a1=-v;
    a2=-v*(-v+1)/2;
    a3=(4*v*v-12*v+8);%��һ��

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

    temp_pic1 = A;%����һ����ʼͼ��
    temp_pic2 = A;%����һ����ʼͼ��
    temp_pic3 =A;%����һ����ʼͼ��



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
        %����һ    
        impove_sum_W1=[(W(1)+W(3)+W(5)+W(7)),(W(2)+W(4)+W(6)+W(8))];
        temp_pic1(i,j)=max(impove_sum_W1)*2/a3;
        %������
        impove_sum_W2=[(W(1)+W(5)),(W(2)+W(6)),(W(3)+W(7)),(W(4)+W(8))];
        temp_pic2(i,j)=max(impove_sum_W2)*4/a3;
        %������
        temp_pic3(i,j)=max(W)*8/a3;
    end
end

%%   Step3���ݶȵķ�ֵͼ��
   

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
    a = atan2(fy,fx);%��ȡ���ȣ���Χ��-pi~pi
    a = a*180/pi;%������ת��Ϊ�Ƕȣ��õ��Ƕ�ͼ����ԭͼ���С���.
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
    TL = 0.06 * max(max(Nms));%����ֵ
    TH = 0.15 * max(max(Nms));%����ֵ
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
    title('improve-Tianis');
end


















