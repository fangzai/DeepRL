require 'io'
-- lua中的循环语句
-- while
i = 1
while   i <= 10 do
        io.write(i.."\t")
        i = i + 1
end
io.write("\n");
-- for 
for i = 1, 5 do  -- 这里的语法和matlab还是很相似的
        io.write(i.."\t")
end
print()

-- 下面的这个类似与do while()
i = 1
repeat
        io.write(i.."\t")
        i = i + 1
until i == 6
print()
-- 遍历lua中的类似map的东西，或者说是table
t = {key1 = 1, key2 = 2, key3 = 3}
for k, v in pairs(t) do
        print(k.."->"..v)
end
for _, v in pairs(t) do
	io.write(v.."\t")
end
io.write("\n")
        
        
        
        