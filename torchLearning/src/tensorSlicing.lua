require "torch"
require "math"

-- 关于tensor的切片操作
-- 关于set的构造函数有很多
--[[
self set(tensor)  将一个tensor填充到另一个中
--]]
y = torch.Storage(10)
x = torch.Tensor()
x:set(y, 1, 10)  --讲y中的从第1个元素开始的10个元素置于x中
-- 上面的命令等价于
y = torch.Storage(10)
x = torch.Tensor(y, 1, 10)

x = torch.Tensor(2, 5):fill(math.pi)
print(x)
y = torch.Tensor():set(x)  --但是需要记住的是，他们句柄指向一个位置
y:fill(1)
print(x)

--[[
boolean isSetTo(tensor) 判定一个对象是否被set到另一个对象上
-- 这个地方函数用法貌似有问题，先不管这个函数了  mark一下
--]]
x = torch.Tensor(4, 5)
y = torch.Tensor()
--print(y:isSetTo(x))
y:set(x)
--print(y:isSetTo(x))

s = torch.Storage(10):fill(1)
-- we want to see it as a 2x5 tensor
sz = torch.LongStorage({2,5})
x = torch.Tensor()
x:set(s, 1, sz)
print(x)
x:zero()
print(x)


--[[
self copy(tensor) 向量的copy，维度可以不一样，但是元素的个数必须一样
--]]
x = torch.Tensor(4, 1):fill(2)
y = torch.Tensor(2, 2):copy(x)
print(x:t())
print(y)
--[[
self fill(tensor)   和 self zero(tensor)这两个函数就不说了，上面已经用过很多次了
--]]


-- 下面是很重要的sub-tensors的切片操作，这些操作很快，因为他们并未涉及到内存拷贝的问题
-- 也就是说，他们只是创建了一个句柄而已

--[[
self narrow(dim, index, size)  dim表示在第几维上操作，index~index+size上切片
--]]
x = torch.Tensor(5, 6):zero()
print(x)
y = x:narrow(2, 3, 2) -- 表示在第2维上 3~4列进行操作，只是操作了句柄
y:fill(2)
print(x)  --  memory并没有拷贝

--[[
self sub(dim1, dim2,[],[])  和narrow很相似，只不过这里的操作更细一些，可以同时指定多个维度的index范围
--]]
x = torch.Tensor(5, 6):zero()
y = x:sub(2, 4):fill(1)  -- 前两个数子表示的第1维的index范围
print(y)
print(x)

-- 下面同时操作两个维度
y = x:sub(2, 4, 3, 5):fill(3)
print(y)
print(x)

--[[
tensor select(dim, index)  上面已经讨论过，相当于取第dim维度的第index个向量，只是句柄操作
--]]
x = torch.Tensor(5, 6):zero()
y = x:select(1, 3):fill(1)
print(x)
y = x:select(2, 4):fill(2)
print(x)

--[[
用中括号下标的方式对tensor进行切片操作
-- 记住 这里的操作都是从1开始计数的，并不是从0开始的
--]]
x = torch.Tensor(5, 6):zero()
x[{3, 4}] = 1
print(x)
x[{2, {2, 4}}] = 2  -- 第1维度， 第2维度的2~4全部取出来
print(x)
x[{{},3}] = -1 --第2维度，的第3列全部取出来
print(x)
x[{{}, 1}] = torch.range(1, 5)
print(x)
-- 下面的就比较高级了，将tensor  x中的所有元素小于0的全部置为-2
x[torch.lt(x,0)] = -2 -- sets all negative elements to -2 via a mask
print(x)

-- 下面的切片操作就比较慢了，因为涉及到memcpy，所以不再是句柄的操作了
--[[
tensor index(dim, index)  dim表示在第dim个维度上进行操作,参数index表示index的范围
该函数的应用类似于select(dim, index)
--]]

x = torch.randn(5, 6)
print(x)
y = x:index(1, torch.LongTensor({3, 2, 4}))  --后面就是第1维的一个index范围
-- 上面一句话也等价于
-- y = torch.Tensor()
-- y:index(x, 1, torch.LongTensor({3, 2, 4}))
print(y)
y:fill(0)
print(x)  --可以看到x并没有变化

--[[
tensor indexCopy(dim ,index , tensor)  这个函数就比较高级了，不仅把dim维的选择出来，还把第三个参数tensor
copy进去， 下面是一个简单用法
--]]
x = torch.randn(5, 6)
z = torch.Tensor(5, 2)
z:select(2, 1):fill(-1)
z:select(2, 2):fill(-2)
print(x)
x:indexCopy(2, torch.LongTensor{1, 6}, z)  -- 这个地方仔细体会一下
print(x)

-- 还有一些函数就比较奇葩了，什么indexAdd，估计很少见到有人用，这里就不写了