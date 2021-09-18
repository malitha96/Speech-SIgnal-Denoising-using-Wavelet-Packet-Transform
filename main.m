clear all
close all
clc


db_val='10';
s_or_h='s'; 
a='D:\sorted_audios\';
b=strcat('punchi_maluo','_',db_val,'db.wav');
path=strcat(a,b);

[clear_speech,fs]=audioread('D:\sorted_audios\clear.wav');
[noisy_speech,Fs]=audioread(path);

wavename={'haar','db5','db10','db15','sym5','sym10','sym15','coif3','coif4','coif5'};

level=5;
%method='bal_sn';
method='sqtwologswn';
dd={};
t_new=array2table(zeros(1,6),'VariableNames',{'MSE_in','MSE_out','SNR','SNR_improve','PESQ_in','PESQ_out'});
for i=1:1:length(wavename)
    ww=char(wavename(i));
    [vv,denoised_speech]=wave_packet(clear_speech,noisy_speech,ww,level,s_or_h,method,Fs,db_val);
    dd{i}=denoised_speech;
    t_new=vertcat(t_new,vv)
    
end

%figure;
% subplot(3,1,1)
% plot(clear_speech);
% title('clear speech')
% 
% subplot(3,1,2)
% plot(noisy_speech);
% title('noisy speech')
% % 
% subplot(3,1,3)
% plot(dd{1,1});
% title('denoised_speech')
% % 
% cc=strcat('C:\Users\Malitha Gunawardhana\Desktop\Software\','sym10_',db_val,'db.wav');
% audiowrite(cc,dd{1,1},Fs)
% 
% cc=strcat('C:\Users\Malitha Gunawardhana\Desktop\Software\','sym15_',db_val,'db.wav');
% audiowrite(cc,dd{1,2},Fs)


