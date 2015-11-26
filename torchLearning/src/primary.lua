require "io"
-- 基本的数据类型  number string nil boolean   
-- 高级的数据类型 table function userdata(用户定义的)  thread(线程,lua and torch支持多线程)

a = 8
io.write(a)
io.write(" 的数据类型是 ")
io.write(type(a))
b='2.7'
-- b前面不需要声明 直接将字符转换过去
a = tonumber(b)
print()
print(type(b))

c = " is number"
print(b..c)
io.write(b..c.."\n")    -- 相当于字符串拼接
print(type(c)..a)

f = io.open('file.txt', 'w')
print(type(f))   -- 相当于用户自己构建的数据userdata，也就是句柄

a, b, c = 1, 2  -- c没有赋值 所以直接被置为nil了
io.write(a..b.."\n")
a, b = b, a  -- 相当于a,b 交换
io.write(a..b.."\n")

arr = {1, 2, 3, 4, 5}
io.write("arr 数组的长度是 "..#arr.." \n")
io.write("其类型是 "..type(arr))
print(arr)  --直接print table的话一般输出的是地址

-- 调用函数
function mypow(x)
        return x*x
end

x = 10
io.write(mypow(x).."\n")


