function [ x ] = wist( y,dic,lamda,maxErr,maxIter )
%WIST ������ֵ�����㷨 ����ֵ ����һ��������
%   ���������
%     y:�����ź�
%     A:�ֵ�
%     lamda:����
%     err:�������
%     maxIter:����������

    if nargin < 5    
        maxIter = 10000;    
    end    
    if nargin < 4      
        maxErr = 1e-2;      
    end     
    if nargin < 3      
        lamda = 0.1*max(abs(dic'*y));     
    end     
    [y_rows,y_columns] = size(y);      
    if y_rows<y_columns      
        y = y';%y should be a column vector      
    end 
    
    % �ֵ�dicΪdic_rows*dic_cols����,�źų���Ϊdic_rows,ԭ�Ӹ���Ϊdic_cols
    [dic_rows,dic_cols]=size(dic); 
    
    x = zeros(dic_cols,1);%Initialize x=0  
    f = 0.5*(y-dic*x)'*(y-dic*x)+lamda*sum(abs(x));%added in v1.1
    iter = 0; 
    
     % ��Ȩ��
    W=weight(y,dic);
    w=W*ones(dic_cols,1);

    while 1    
        x_pre = x;
        B=x + dic'*(y-dic*x);
        
        x = soft_threshold(B,lamda,w);%update x    
        
        %% �鿴�����еı仯���
%         figure();
%         subplot(3,1,1);
%         plot(x_pre);
%         subplot(3,1,2);
%         plot(x);
%         subplot(3,1,3);
%         plot(B);
        %%
        
        
        iter = iter + 1;  
        f_pre = f;%added in v1.1
        f = 0.5*(y-dic*x)'*(y-dic*x)+lamda*sum(abs(x));%added in v1.1
        if abs(f-f_pre)/f_pre<maxErr%modified in v1.1
            fprintf('abs(f-f_pre)/f_pre<%f\n',maxErr);
            fprintf('IST loop is %d\n',iter);
            break;
        end
        if iter >= maxIter
            fprintf('loop > %d\n',maxIter);
            break;
        end
        if norm(x-x_pre)<maxErr
            fprintf('norm(x-x_pre)<%f\n',maxErr);
            fprintf('IST loop is %d\n',iter);
            break;
        end
    end  
end

%% ����ֵ����
function [ x ]=soft_threshold(b,lamda,w)
    x=sign(b).*max(abs(b) - lamda*w,0);
end