raw_values = wavelet_data_2(:,5);
wav_values = wavelet_data_2(:,3);

for i =1:20
    if(raw_values(i) > 60000)
        raw_values(i) = raw_values(i) - 2^16;
    end
    if(wav_values(i) > 60000)
        wav_values(i) = wav_values(i) - 2^16;
    end    
end



[exp_wav_values,scales,predneighbs,predfilts,upneighbs,upfilts,tranmat]=itlift_meshless(coords,raw_values);

exp_raw_values = itrecon_meshless(wav_values,scales,predneighbs,predfilts,upneighbs,upfilts);

        

figure(1)
plot(abs(raw_values - exp_raw_values),'o');

figure(2)
plot(raw_values,'o');
hold on;
plot(exp_raw_values,'x');

figure(3)
plot(abs(wav_values - exp_wav_values),'o');

figure(4)
plot(wav_values,'o');
hold on;
plot(exp_wav_values,'x');
