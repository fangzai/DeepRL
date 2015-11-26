require "torch"
require "io"
filename = "data.t7"
flag = 0
if (flag == 1)  then 
        -- save文件
        obj = {
                mat = torch.Tensor(3, 3):fill(1),
                name = 'wanghaitao',
                test = {entry = 1 }
        }
        torch.save(filename, obj)
else 
        -- load文件
        obj = torch.load(filename)
        print(obj)
        print(obj.mat)
        print(obj.name)
        print(obj.test.entry)
        data = obj.mat
        i = 0
        data:apply(
        function(x)
                i = i +1
                return i + x
        end
        )
        --data[1][1] = 1
        print(data)
        name = "file.txt"
        f = io.open(name,'w')
        for i=1, data:size(1)  do
                for j =1, data:size(2) do
                        f:write(data[i][j].."\t")
                end
        end
        f.close()
end

-- 关于计时器
timer = torch.Timer() -- the Timer starts to count now
x = 0
 for i=1,1000000 do
        x = x + math.sin(x)
end
print('Time elapsed for 1,000,000 sin: ' .. timer:time().real .. ' seconds')



