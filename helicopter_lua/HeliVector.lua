
--[[
	this project implements the Helicopter model from Andrew NG or his student Abbeel
	coded by ht
	2015-4-3 to 2015-4-7
	though I have tested those functions, there may exist tiny errors.
--]]

require 'Quaternion'

HeliVector={}
function HeliVector:_init(srcx,srcy,srcz)
	local vector={
		x=srcx,
		y=srcy,
		z=srcz,
	}

	function vector.qToCopy(srcVector)
		--用copy的方式调用初始换?
		vector.x = srcVector.x
		vector.y = srcVector.y
		vector.z = srcVector.z
	end

	function vector.to_quaternion()
		tempx=0
		tempy=0
		tempz=0
		tempw=0
		qua={}
		--print(vector.x)
		total= vector.x*vector.x + vector.y*vector.y + vector.z*vector.z

		--print(total)
		rotation_angle = math.sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)

		if(rotation_angle < 1e-4) then

			tempx=vector.x/2.0
			tempy=vector.y/2.0
			tempz=vector.z/2.0
			tempw=math.sqrt(1-(tempx*tempx + tempy*tempy + tempz*tempz))
			qua={x=tempx,y=tempy,z=tempz,w=tempw}

		else
			tempx=math.sin(rotation_angle/2.0)*(vector.x/rotation_angle)
			tempy=math.sin(rotation_angle/2.0)*(vector.y/rotation_angle)
			tempz=math.sin(rotation_angle/2.0)*(vector.z/rotation_angle)
			tempw=math.cos(rotation_angle/2.0)
			qua={x=tempx,y=tempy,z=tempz,w=tempw}
		end

		return qua
	end

	function vector.rotate(q)
		-- 参数是一个四维向量也就是Quaternion
		this_Quaternion={x=vector.x, y=vector.y, z=vector.z, w=0}
		local myVector = Quaternion:_init(q)

		q_conj = myVector.conj()

		q1=myVector.mult(this_Quaternion)
		local myVector1=Quaternion:_init(q1)

		q2=myVector1.mult(q_conj)

		local myVector2=Quaternion:_init(q2)
		q3=myVector2.complex_part()
		-- 返回的是三维的
		return q3
	end

	function vector.express_in_quat_frame(q)
		-- 参数是一个四维向量也就是Quaternion
		myQuaVector = Quaternion:_init(q)
		q_conj = myQuaVector.conj()
		-- 返回的是三维的
		return vector.rotate(q_conj)
	end

	return vector
end


function display(args)
	--print(#args)
	if(args.w == nill) then

		print("x",args.x)
		print("y",args.y)
		print("z",args.z)
	else
		print("x",args.x)
		print("y",args.y)
		print("z",args.z)
		print("w",args.w)
	end

end
function printVector(args)
	if(args.w == nill) then

		print("[",args.x,",",args.y,",",args.z,"]")
	else
		print("[",args.x,",",args.y,",",args.z,",",args.w,"]")
	end
end

--[[

local myNum={x=0.4,y=0.1,z=0.3,w=0.9}
local myVector = HeliVector:_init(myNum.x,myNum.y,myNum.z)
--toQ = myVector.to_quaternion()
--display(toQ)
--print(myVector5.x)
toQ = myVector.rotate(myNum)
display(myVector)

toQ = myVector.express_in_quat_frame(myNum)
display(myVector)
--]]



