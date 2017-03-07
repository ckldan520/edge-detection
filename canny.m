function [ output_pic ] = canny( org_pic )
%UNTITLED2 Summary of this function goes here
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

    %%  Step2�������ݶȵķ�ֵͼ��,�Ƕ�ͼ��.

%     %Prewitt�ݶ�ģ��
%     dx = [-1 0 1;-1 0 1;-1 0 1];%x������ݶ�ģ��
%     dy = [1 1 1; 0 0 0;-1 -1 -1];%y������ݶ�ģ��
%     gx = conv2(A,dx,'same');%��ȡx������ݶ�ͼ��.ʹ���ݶ�ģ����ж�ά���,�����ԭͼ���С��ͬ
%     gy = conv2(A,dy,'same');%��ȡy������ݶ�ͼ��.ʹ���ݶ�ģ����ж�ά���,�����ԭͼ���С��ͬ
%     M = sqrt((gx.^2) + (gy.^2));%��ȡ��ֵͼ��.��С��ԭͼ�����.(.^)��ʾ����˷�
%     a = atan2(gy,gx);%��ȡ���ȣ���Χ��-pi~pi
%     a = a*180/pi;%������ת��Ϊ�Ƕȣ��õ��Ƕ�ͼ����ԭͼ���С���.
% 
%     %%  Step3���Է�ֵͼ�����Ӧ�÷Ǽ���ֵ����
% 
%     %���Ƚ��ǶȻ��ֳ��ĸ�����Χ:ˮƽ(0��)��-45�㡢��ֱ(90��)��+45��
%     for i = 1:H
%         for j = 1:W
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
%     %���۶�3x3������ĸ�������Ե������зǼ���ֵ����.��ȡ�Ǽ���ֵ����ͼ��
%     Nms = zeros(H,W);%����һ���Ǽ���ֵͼ��
%     for i = 2:H-1
%         for j= 2:W-1
%             if (a(i,j) == 0 && M(i,j) == max([M(i,j), M(i,j+1), M(i,j-1)]))
%                 Nms(i,j) = M(i,j);
%             elseif (a(i,j) == -45 && M(i,j) == max([M(i,j), M(i+1,j-1), M(i-1,j+1)]))
%                 Nms(i,j) = M(i,j);
%             elseif (a(i,j) == 90 && M(i,j) == max([M(i,j), M(i+1,j), M(i-1,j)]))
%                 Nms(i,j) = M(i,j);
%             elseif (a(i,j) == 45 && M(i,j) == max([M(i,j), M(i+1,j+1), M(i-1,j-1)]))
%                 Nms(i,j) = M(i,j);
%             end;
%         end;
%     end;
% 
%     %%  Step4:˫��ֵ�������ӱ�Ե
% 
%     DT = zeros(H,W);%����һ��˫��ֵͼ��
%     TL = 0.06 * max(max(Nms));%����ֵ
%     TH = 0.15 * max(max(Nms));%����ֵ
%     for i = 1  : H
%         for j = 1 : W
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

    BW = edge(A,'canny');
    figure, imshow(BW); %���յı�Ե���Ϊ��ֵͼ��
    output_pic=BW;
    grid on;
    title('canny');
end

