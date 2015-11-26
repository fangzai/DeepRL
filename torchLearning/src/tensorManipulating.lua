require "torch"
require "math"

-- 关于tensor的操作函数
--[[
-- clone() 函数， 该函数拷贝内存，而不仅仅是句柄
--]]
i = 0
x = torch.Tensor(5,1):apply(
function(x)
        i = i +1
        return i
end
)
y = x:clone()  -- 从下面的输出可以看到改变y之后，对x是不影响的，反之也是
print(y:t())
print(torch.Tensor(5):size())
y:fill(1)
print(x:t())
print(y:t())

--[[
-- contiguous() 这个函数的用法比较奇怪，如果Tensor的内容在memory中是连续的，就返回句柄
-- 否则就是返回一个copy
--]]
x = torch.Tensor(2, 3):fill(1)
print(x)  -- 这种情况下x中的元素在内存中是连续的，不要问我这是为什么
y = x:contiguous():fill(2)
print(y)  
print(x)  -- 可以看到x就是已经改变了，因为y就是指向x的句柄
-- 那种情况下Tensor内容不是连续的呢？ 
z = x:t():contiguous():fill(math.pi)  -- 将t转置之后内容就不连续了 和c里面规则是一样的
print(x)
print(z)  -- 很明显这个就是不一样的了  这个函数到底有啥用～～～～


--[[
-- torch.type这个函数，很明显和lua原始的type差不多，就是为了获取数据的类型
--]]
print(torch.Tensor(3):fill(2.1):type())
-- 关于类型的转化
-- DoubleTensor  -> DoubleTensor  拷贝的是句柄
x = torch.Tensor(5,1):fill(math.pi)
print(x)
y = x:type("torch.DoubleTensor")
y:fill(0)
print(x:t())  --可以看到改变y，就相当于直接改变了x

--[[
-- DoubleTensor ->IntTensor 拷贝的是内容, 也就是类型变化，其他的一样
--]]
x = torch.Tensor(5, 1):fill(math.pi)
print(x:t())
y = x:type("torch.IntTensor")
print(x:t())
print(y:t()) -- 很明显，这里改变y不再影响x，也就是说这里是内存拷贝

--[[
     isTensor()  判定某个变量是否是Tensor
--]]
print(torch.randn(3, 4):isTensor())  -- 很明显是Tensor
print(torch.randn(3, 4)[1]:isTensor())
print(torch.isTensor(torch.randn(3, 4)[1][2])) --这里是一个标量，不是Tensor
-- 很奇怪 torch.randn(3, 4)[1][2]:isTensor()  这句话是报错的
-- 关于类型转化还有更简单的方法

x = torch.Tensor(3, 1):fill(math.pi)
print(x:t())
print(x:t():type("torch.IntTensor"))
print(x:t())
print(x:t():int())  -- 和上面的一句是等价的

--[[
Tensor的size和structure
--]]
x = torch.Tensor(4, 5)  -- 4 * 5
print(x:nDimension())  -- 维度  2D
print(x:dim()) -- 和上面的一句是等价的
print(x:size())  -- 返回的是Tensor的结构信息

print(x:size(1))  -- 获取第1维度的size
print(x:size(2))  -- 获取第2维度的size

--[[
Tensor中stride信息，也就是元素跳跃的个数
--]]
x = torch.Tensor(4, 5):fill(1)
print(x:stride())  -- 输出应该是5，1
print(x:stride(1))  -- 对应第2维的size

--[[
storage相当于将向量映射到1维
--]]
x = torch.Tensor(4, 5)
s = x:storage()  -- s的句柄指向x
i = 0 
x:apply(
function(x)
        i = i + 1
        return i 
end
)
print(s)

--[[
isContiguous()上面已经用过一个类似的contiguous函数
很明显是为了判定Tensor的数据是否是连续的
--]]
x = torch.randn(4, 5)
print(x:isContiguous())
y = x:select(2, 3)  -- 相当于取第2维的第3列  切片操作
print(x)
print(y)
print(y:isContiguous()) -- 这个地方当然不是了
print(y:stride())  -- 输出一下stride，会发现还是原来的

--[[
isSize(LongStorage) 判定size是否是一致的
--]]
x = torch.Tensor(4, 5)
y = torch.LongStorage({4, 5})
z = torch.LongStorage({4, 5, 1})
print(x:isSize(y)) -- size一样的
print(x:isSize(z))  -- size是不一样的

--[[
boolean isSameSizeAs(Tensor)  比较两个Tensor的size是否一致
--]]
x = torch.Tensor(4, 5)
y = torch.Tensor(4, 5)
print(x:isSameSizeAs(y))

--[[
nElement()  获取Tensor里面元素的个数
--]]

x = torch.Tensor(4, 5)
print("x中元素的个数是  ",x:nElement())