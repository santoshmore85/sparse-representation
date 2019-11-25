clc;clear all;close all;
%% StOMP�㷨���� �����źŷ���

fs=2000;                %����Ƶ��
total_time=1;           %����ʱ��
len=fs*total_time;   %��������
point=1:len;         %����������
t=point/fs;             %ʱ��

damp=0.05;              %����ϵ��
f_vibrate=300;          %��Ƶ��
t0=0.05;                %ʱ��
T=0.1;                  %�ź�����


while (t0-T>0)
    t0=t0-T;
end
sig_laplacewavelet=exp(-(damp/sqrt(1-damp^2))*2*pi*f_vibrate*t).*sin(2*pi*f_vibrate*t);
Wss=round(t0*fs);

A1=1;                   %��ֵ
A2=0.5;                 %��ֵ

sig=zeros(len,1);
for k=1:len
    if k<=Wss
        sig(k)=0;
    else
        sig(k)=A1*sig_laplacewavelet(k-Wss);
    end
end

count=0;
for i=1:len/(T*fs)
    Wss=round(T*fs*i+t0*fs);
    for k=1:len      
        if k>Wss
            if mod(count,2)==0
                sig(k)=sig(k)+A2*sig_laplacewavelet(k-Wss);
            else
                sig(k)=sig(k)+A1*sig_laplacewavelet(k-Wss);
            end
        end
    end
    count=count+1;
end
%% ��������
SNR=-5;


% figure()
% subplot(2,1,1);
% plot(t,sig);
% title('��������ź�');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% ylim([-1,1]);
% 
% subplot(2,1,2);
% plot(t,signal);
% title('��������ź�');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% ylim([-1,1]);

%% �����ֵ�
f_min=299;                  %(��Ҫ����ʵ���������)
f_max=301;                  %(��Ҫ����ʵ���������)
zeta_min=0.049;              %(��Ҫ����ʵ���������)
zeta_max=0.051;              %(��Ҫ����ʵ���������)
W_step=4;
[Dic,rows,cols]=generate_dic(len,f_min,f_max,zeta_min,zeta_max,W_step,fs);
Dic=dictnormalize(Dic);
Dic=Dic/norm(Dic); 



%% ϡ��ָ��㷨 CcIST
% �㷨�й����ĸ����� �ֱ�����
%     lamda:����                  ���ص������
%     distance:�������߶�        ���ص������
%     ts:ԭ����ѡ��ض���ֵ
%     maxIter:����������


exp_num=50; %ÿ��ʵ�����


%% ����:sigma
% cc=[];
% sigma_range=0.01:0.0025:0.05;
% for sigma=sigma_range
%     lamda=sigma*sqrt(2*log(cols));
%     
%     temp=[];
%     for i=1:exp_num
%         [signal,noise]=noisegen(sig,SNR);
%         theta=ClusterShrinkIST(signal,Dic,lamda,20);
%         sig_recovery=Dic*theta;
%         % ���ϵ��
%         r=corrcoef(sig,sig_recovery);
%         temp=[temp r(1,2)];
%     end
%     % ȡ��ֵ
%     cc=[cc mean(temp)];
% end
% 
% figure()
% plot(sigma_range,cc);
%% ����:ts
cc=[];
ts_range=0.5:0.01:0.8;
for ts=ts_range
    
    sigma=0.03;
    lamda=sigma*sqrt(2*log(cols));
    temp=[];
    for i=1:exp_num
        [signal,noise]=noisegen(sig,SNR);
        theta=ClusterShrinkIST(signal,Dic,lamda,20,ts);
        sig_recovery=Dic*theta;
        % ���ϵ��
        r=corrcoef(sig,sig_recovery);
        temp=[temp r(1,2)];
    end
    % ȡ��ֵ
    cc=[cc mean(temp)]; 
end

figure()
plot(ts_range,cc);
