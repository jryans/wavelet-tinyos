function [faren] = convert_ADC_temp(ADC_val)



a = 0.00130705;
b = 0.000214381;
c = 0.000000093;
R = 10000;
ADC_FS = 1023;

%ADC = hex2dec(ADC_val)'
ADC = ADC_val
if ADC > 0
    R_thr = R .* (ADC_FS - ADC) ./ ADC;
    inv = a + b .* log(R_thr) + c .* (log(R_thr)).^3;
    kelvin = 1./inv;
    celsius = kelvin - 273;
    faren = (9 / 5) .* celsius + 32;
    if faren < 0
        faren = 0;
    end
else
    faren = 0;
end



