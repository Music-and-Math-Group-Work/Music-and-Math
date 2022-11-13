filename = "test.json";
P = loadjson(filename);
chain_length = 10;
% 最终马尔可夫链长度
target0 = 3;
% 第一个音，选主音比较好?
chain = zeros(1, chain_length);
chain(1) = target0;

for i = 2:chain_length
    P_i = P(chain(i - 1), :);
    prob = cumsum(P_i);
    choice = rand();
    temp = find(prob >= choice);
    target = temp(1);
    chain(i) = target;
end

disp(chain)
