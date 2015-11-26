require "torch"
require "math"

-- 关于tensor的search操作
-- 其实有点儿类似于过滤操作

--[[
LongTensor nonzero()  返回值就是下标
--]]
x = torch.rand(4, 4):mul(3):floor():int()  -- 这个涉及到四个函数，mul是直接乘以3，后面floor是取整数，然后转换为int类型
print(x)
y = x:nonzero()
-- 等价于 -- y = torch.nonzero(x)
print(y)

index = torch.LongTensor()
x.nonzero(index, x)  -- 这个获取他们的下标的甚是奇怪
print(index)

y = x:eq(1):nonzero()  -- 返回等于1元素位置的下标
print(y)


--[[
关于tensor的view操作
--]]
x = torch.Tensor(4, 1):fill(0)
y = x:view(2, 2)
print(y)
-- 如果有一个维度是-1的话，那么这个维度的size由其他维度size推断出来
y = x:view(1, 4)
print(y)
y = x:view(2, -1)
print(y)

y = x:view(torch.LongStorage{2, 2})
print(y)

--[[
tensor transpose(dim1, dim2)  dim1 和dim2转置
--]]
x = torch.Tensor(4, 5):fill(0)
y = x:select(1,2):fill(-1)
print(x)
y = x:transpose(1, 2)
print(y)
y:select(1, 4):fill(-2)
y = y:transpose(1, 2)
print(y)
print(x)
-- 关于转置还有一个简化版本的函数，专门针对2D的tensor   t()
-- 一定要是2D的，像torch.Tensor(3)，虽然也可以视为3*1维的，但是运行过不去


-- 其他有用的函数
--[[
 apply(function)  前面其实已经用过了,相当于tensor里面的每一个元素都要apply到function里面去
--]]
i = 0
x = torch.Tensor(10, 1)
x:apply(
function(x)
        i = i +1
        return i
end
)
print(x:t())  -- 相当于每个元素都在匿名函数里面执行了一次

x = torch.randn(3, 2)
print(x)
x:apply(math.sin)
print(x)

-- 这里再写一个求和函数，类似reducer
sum = 0
x:apply(
function(x)
        sum = sum + x
end
)
print(sum)
print(x:sum())  --很明显这个两个结果是一样

-- 还有一个简单应用map的例子
x = torch.Tensor(3, 3)
y = torch.Tensor(9, 1)
i = 0
x:apply(function() i = i + 1; return i end) -- fill-up x
i = 0
y:apply(function() i = i + 1; return i end) -- fill-up y
print(x)
print(y:t())
print(x:map(y, function(m, n) return m*n end))  --常见的map操作
