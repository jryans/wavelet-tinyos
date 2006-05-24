function [batt_vals] = fill_node_time_matrix (batt)


batt_vals = zeros(296,10);

n = 2230;

for k = 1:n
    node = batt(k,2);
    time = batt(k,1);
    val = batt(k,3);
    batt_vals(time,node) = val;
end


for node = 1:10
    current_val = batt_vals(1,node);
    for k = 1:296
        if(batt_vals(k,node) == 0)
            batt_vals(k,node) = current_val;
        else
            current_val = batt_vals(k,node);
        end
        if batt_vals(k,node) > 0
            batt_vals(k,node) = 1.223 * 1024 / batt_vals(k,node);
        end
    end
end

