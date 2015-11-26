require "torch"
require "math"

-- 关于tensor的math操作
-- 只列举一些简单常用的
x = torch.range(2,5)
print(x)
x = torch.zeros(2, 3)
print(x)
-- 像类似于cos, sin, acos这些函数都会对tensor的每个元素进行操作
-- sqrt, round, floor等等
-- 比如
x = torch.randn(3,1)
print(x)
y = x:sin()
print(y)
--[[
基本操作 
add    +
sub     -
mul    *
div     /
--]]
x = torch.Tensor(2,2):fill(2)  
y = torch.Tensor(4):fill(3)
x:add(y)    
print(x)
 -- y = torch.Tensor(a, b) 返回一个新的tensor
 -- torch.add(y, a, b)  put a+b in y
 -- a:add(b)  acculmulate all eles to a
 -- y:add(a, b) put a+b into y
 
 
 --torch.add(y, tensor a, value, tensor b)  等价于 y = a + b*value
x = torch.Tensor(2,2):fill(2)
y = torch.Tensor(4):fill(3)
x:add(2, y)
print(x)
-- 一些其他的方法类似于上面最简单的两个tensor之间的操作

-- 相似的函数mul sub div等等都是这两种用法
--还有一些涉及到向量的math操作
-- 如mean, max， min, sum,
i = 0
x = torch.Tensor(4, 5):apply(
function()
        i = i + 1
        return i
end
)
print(x)
print(x:mean())
print(x:mean(1))
print(x:mean(2))

print(x)
print("x中最大值为")
print(x:max())
print("按照第1维最大值为")
y = x:max(1)
print(y)
y = x:max(2)
print("按照第2维最大值为")
print(y)
--Logical Operations on Tensors
--torch.lt(a, b)  le gr  ge eq ne等等这些函数