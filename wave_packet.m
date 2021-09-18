function [values,denoised_speech]=wave_packet(clear_speech,noisy_speech,wavename,level,s_or_h,method,Fs,db_val)
% seg_step = Fs*0.01;
% overlap = Fs*0.01;

% seg_step = (Fs/1000)*32;
% overlap =(Fs/1000)*32;
% seg_len = seg_step + overlap;
sec=10;
seg_len=(Fs/1000)*sec; %x
overlap_percentage=50; %y

overlap=((seg_len*overlap_percentage)/100);
seg_step=(seg_len*(1-overlap_percentage/100));

sp_len = length(noisy_speech);
Nseg = floor(sp_len/(seg_step))-1;
window = hamming(seg_len);
de = hanning(2*overlap - 1)';
dewindow = [de(1:overlap) , ones(1,seg_len -2*overlap) ,de(overlap:end)]'./window;

denoised_speech = zeros(sp_len, 1);
% thr_seg=thselect(noisy_speech,'heursure') %'rigrsure''heursure''sqtwolog''minimaxi'
for i = 1 : Nseg
    
    sp_Seg(:,i) = noisy_speech((i-1)*seg_step+1 :i*seg_step+overlap);

    noisy_speechW(:,i) = window.*sp_Seg(:,i);

    wpt = wpdec(noisy_speechW(:,i),level,wavename);
    KeepApp=1;
    thr = wthrmngr('wp1ddenoGBL',method,wpt);
%     sigma=std(noisy_speechW(:,i));
%     p=2*log2(length(noisy_speechW(:,i)));
%     thr=0.8*0.9*sigma*sqrt(p);
% 
% %     thr=std( noisy_speechW(:,i))*0.8*0.9*sqrt(2*log2(length(sp_Seg(:,i))));
%     NT = wpp(wpt,KeepApp,thr);
    NT = wpthcoef(wpt,KeepApp,s_or_h,thr);
    denoised_seg = wprec(NT);
%     [denoised_seg] = wden(noisy_speechW(:,i),'modwtsqtwolog',s_or_h,'mln',level,wavename);
%     denoised_seg=denoised_seg';
    denoised_seg (:,i) = denoised_seg;
    noisy_speechDe(:,i) = denoised_seg (:,i).*dewindow;
    denoised_speech((i-1)*seg_step+1 : i*seg_step+overlap) = noisy_speechDe(:,i) + denoised_speech((i-1)*seg_step+1 : i*seg_step+overlap);

end

denoised_speech=denoised_speech-mean(denoised_speech);
noisy_speech=noisy_speech-mean(noisy_speech);
clear_speech=clear_speech-mean(clear_speech);
denoised_speech=denoised_speech*max(abs(noisy_speech))/max(abs(denoised_speech));

MSE_in=sum((noisy_speech-clear_speech).^2);
MSE_out=sum((denoised_speech-clear_speech).^2);

PESQ_in=pesq2(clear_speech,noisy_speech,Fs);
PESQ_out=pesq2(clear_speech,denoised_speech,Fs);


a=sum(clear_speech.^2);
b=sum((denoised_speech-clear_speech).^2);
SNR_before=double(string(db_val));
SNR=10*log10(a/b);
SNR_improve=SNR-SNR_before;

values=table(MSE_in,MSE_out,SNR,SNR_improve,PESQ_in,PESQ_out);
end

