function [s] = toSingle(d)

for i=1:size(d, 2)
   s{i} = cast(d{i},'single'); 
end