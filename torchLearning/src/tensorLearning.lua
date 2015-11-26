require "torch"
require "math"

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
-- 使用匿名函数
i = 0
x:zero()  -- 所有的元素置为0
print(x)
x:apply(function()
        i = i +1
        return i
end
)
print(x)

print(x:stride())   --表示从第二维开始，他们下标的跨越值
-- 在lua里面x是userdata类型，但是在torch里面x的类型是torch.DoubleTensor
print(type(x), "\n",torch.type(x))
-- 所以对应而言还有ByteTensor, CharTensor, ShortTensor, IntTensor以及FloadTensor
-- 如果需要修改默认的生成的Tensor类型，可以用 torch.setdefaulttensortype('torch.FloatTensor')

x = torch.Tensor(5):zero()  -- zero() 元素全部置0
print(x)
x = torch.Tensor(1, 5):zero()
print(x)

y = torch.Tensor(x:size()):copy(x)
-- 等价于 y = x:clone()
print(y)

x = torch.Tensor(2,5):fill(math.pi)
print(x)
y = torch.Tensor(x)  --这句话只是将x的句柄赋给y了，如果改变了x的元素，y的元素也会改变的
print(y)  
x[2][3] = 0
print(y)   --  这个例子的结论是，一般不会使用这种构造函数

-- 还有一种构造函数，就是torch.Tensor(torch.LongStorage({2, 4, 4}))
x = torch.Tensor(torch.LongStorage({2, 4, 4}))
x:fill(1)
print("x 的维度是 ： ", x:nDimension())
print("x每个维度上的size是：" )
print(x:size())


x = torch.Tensor(torch.LongStorage({4}), torch.LongStorage({0})):zero()
-- 这个地方好奇怪，明明最后一维是0了，但是还是输出了一个结果
-- 和 torch.Tensor(torch.LongStorage({4}), torch.LongStorage({0})):zero() 似乎是等价的
print(x:size())

-- 另一种构造函数，涉及到memcpy
s = torch.Storage(10):fill(2)
print(s)  -- 得到的其实是一个一维向量
-- 如果想将这个向量转化一下
x = torch.Tensor(s, 1, torch.LongStorage({2, 5}))
print(x)  --这里的第二个参数相当于s中的起始偏量

-- 但是这里的构造和上面的也是类似的，只是一个浅层拷贝，把句柄赋值过去了而已
x:zero()
print(s)  -- s的所有元素也都变成了0

-- 最原始的构造函数  torch.Tensor(table),这里用到了lua里面的table这种数据结构
x = torch.Tensor({{1, 2, 3, 4}, {5, 6, 7, 8}})
print("x的内容是 ：")
print(x)





























