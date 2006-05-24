n = 2230;

already_seen = zeros(20,1);
A = zeros(n,3);
A(:,2:3) = test_vect;

current_frame = 1;

for k = 1:n
    node_id = A(k,2);
    if(already_seen(node_id) == 0)
        already_seen(node_id) = 1;
        A(k,1) = current_frame;
    else
        current_frame = current_frame + 1;
        already_seen = zeros(20,1);
        already_seen(node_id) = 1;
        A(k,1) = current_frame;
    end
    
end