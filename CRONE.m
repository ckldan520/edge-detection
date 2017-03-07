function [ output_pic ] = CRONE( org_pic,v )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if numel(size(org_pic))>2
       I = rgb2gray(org_pic);%�Ҷ�ת��
    else
       I =org_pic;
    end
    I = double(I);%ת��Ϊ˫����
    [H,W] = size(I);%��ȡͼ���С

    %%  Step1��ʹ�ø�˹�˲�ƽ��ͼ��

    B = [1 2 1;2 4 2;1 2 1];%��˹�˲�ϵ��
    B = 1/16.*B;%��˹�˲�ģ�� ����=0.8
    A = conv2(I,B,'same');%ʹ�ø�˹ģ����о��.�����ά���,�����ԭͼ���С��ͬ

    %%  Step2�������ݶȵķ�ֵͼ��,�Ƕ�ͼ��.
    a0=0;
    a1=(-1)*v;
    a2=v*(v-1)/2;
    a3=(-1)*v*(v-1)*(v-2)/6;
    a4=v*(v-1)*(v-2)*(v-3)/24;

    X_mask=[a4 a3 a2 a1 a0 -a1 -a2 -a3 -a4];
    Y_mask=X_mask';
    gx = conv2(A,X_mask,'same');%��ȡx������ݶ�ͼ��.ʹ���ݶ�ģ����ж�ά���,�����ԭͼ���С��ͬ
    gy = conv2(A,Y_mask,'same');%��ȡy������ݶ�ͼ��.ʹ���ݶ�ģ����ж�ά���,�����ԭͼ���С��ͬ
    kx=1;
    ky=1;
    b = sqrt(kx*gx.*gx + ky*gy.*gy);


    %%  Step3����ֵ��Ե��ȡ
    [m,n]=size(A);
    %��һ��ͼ��
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

    %��ֵ
    level=graythresh(b);

    for i=1:m
        for j=1:n
            if (b(i,j)>0.08)
                b(i,j)=1;
            else
                 b(i,j)=0;
            end
        end
    end
    output_pic=b;

    figure,imshow(output_pic);


    
    grid on;
    title('CRONE');
end

