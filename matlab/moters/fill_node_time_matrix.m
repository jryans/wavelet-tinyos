function [light_vals_by_node_and_time] = fill_node_time_matrix (light_value_array)


light_vals_by_node_and_time = zeros(985,20);

n = 17664;

for k = 1:n
    node = light_value_array(k,2);
    time = light_value_array(k,1);
    val = light_value_array(k,3);
    light_vals_by_node_and_time(time,node) = val;
end


for node = 1:20
    current_val = light_vals_by_node_and_time(1,node);
    for k = 1:985
        if(light_vals_by_node_and_time(k,node) == 0)
            light_vals_by_node_and_time(k,node) = current_val;
        else
            current_val = light_vals_by_node_and_time(k,node);
        end
    end
end

