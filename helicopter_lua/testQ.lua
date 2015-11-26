
require 'Quaternion'

require 'HeliVector'
--[[
local myNum={x=1,y=2,z=3,w=4}

myVector = Quaternion:_init(myNum)
conj_myNum = myVector.conj()
myVector.show(conj_myNum )
--用于测试quaternion这个类的
--]]
local myNum={x=0.4,y=0.1,z=0.3,w=0.9}
local myVector = HeliVector:_init(myNum.x,myNum.y,myNum.z)
--toQ = myVector.to_quaternion()
--display(toQ)
--print(myVector5.x)
--toQ = myVector.rotate(myNum)
--display(toQ)

toQ = myVector.express_in_quat_frame(myNum)
display(toQ)
