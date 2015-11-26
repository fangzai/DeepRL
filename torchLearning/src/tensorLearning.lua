require "torch"

-- 关于torch中 tensor的处理
-- 构造函数 torch.Tensor(4,6,6,5)相当于构造一个4D的向量 维度分别是给定的参数
z = torch.Tensor(3, 2)
print(z:nDimension())  -- 输出z的维度
print(z:size())                -- 输出每个维度的size

-- LongStorage这种数据类型
s = torch.LongStorage(4)  -- 下标计数是从1开始的
s[1] = 3; s[2] = 5; s[3] = 2; s[4] = 5
x = torch.Tensor(s)
print(x:size())

-- 尽管可以声明多维向量，其实内部存的时候还是一维的
x = torch.Tensor(4, 5)
s = x:storage()  -- 化为1D的
for i = 1, s:size() do  --继续强调，下标是从1开始的
        s[i] = i
end
print(x)
