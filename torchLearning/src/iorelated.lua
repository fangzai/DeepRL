require "io"

print("请输入一段文本：")
--line = io.read()
print("输入的文本是：")
--io.write(line)


--str = io.read(4)  --读取前3个字符
print("输入文本的前3个字符为：")
--print(str)
pi = 3.1415
io.write("this number ", 3, " close to ", pi)  --字符串也可以此种方式拼接
print()

-- 直接io文件文本输入输出
f = io.open('file.txt', 'w')
content = "Hello world! 89000 come on please! \n"
f:write(content)
f:close()
f = io.open('file.txt', 'r')
content = f:read()
print(content)
f:close()

-- 关于string的操作，其实和其他脚本语言真的差不多
m = 10
str = "wanghaitao"
tiny = string.sub(str, 3, 5)
-- 等价于 tiny = str:(3,5)
print(tiny)
print(string.format("the substr of %s is %s and %d", str, tiny, m))

