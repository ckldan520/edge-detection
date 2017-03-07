function [ output_pic ] = Sobel( org_pic )
%SOBEL Summary of this function goes here
%   Detailed explanation goes here
    if numel(size(org_pic))>2
       A = rgb2gray(org_pic);%�Ҷ�ת��
    else
        A =org_pic;
    end
    

    figure,imshow(A);

    %%  Step1��ʹ�ø�˹�˲�ƽ��ͼ��

    B = [1 2 1;2 4 2;1 2 1];%��˹�˲�ϵ��
    B = 1/16.*B;%��˹�˲�ģ�� ����=0.8
    A = conv2(A,B,'same');%ʹ�ø�˹ģ����о��.�����ά���,�����ԭͼ���С��ͬ 


    %%  Step2��������Ĥ ���

    kx=1;
    ky=1;
    %�����˲���
    op= [-1 -2 -1;0 0 0;1 2 1]/8;
    y_mask=op;
    x_mask=op';
    %���˲�����ͼ���������ˮƽ����ֱ�����ͼƬ
    bx = abs(filter2(x_mask,A,'same')); 
    by = abs(filter2(y_mask,A,'same'));

    b = kx*bx.*bx + ky*by.*by;

    %%  Step3�������ݶȵķ�ֵͼ��,�Ƕ�ͼ��.
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








