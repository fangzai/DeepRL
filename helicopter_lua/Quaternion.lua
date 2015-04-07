--[[
	this project implements the Helicopter model from Andrew NG or his student Abbeel
	coded by ht
	2015-4-3 to 2015-4-7
	though I have tested those functions, there may exist tiny errors.
--]]

Quaternion={}
function Quaternion:_init(args)
	local vector={
		x=args.x,
		y=args.y,
		z=args.z,
		w=args.w,
	}
	--print("hello world")
	function vector.qToCopy(srcVector)
		--ÓÃcopyµÄ·½Ê½µ÷ÓÃ³õÊ¼»»¯
		vector.x = srcVector.x
		vector.y = srcVector.y
		vector.z = srcVector.z
		vector.w = srcVector.w
	end
	function vector.show(disVector)
		print(disVector.x)
		print(disVector.y)
		print(disVector.z)
		print(disVector.w)
	end

	function vector.conj()
		tempx=vector.x
		tempy=vector.y
		tempz=vector.z
		tempw=vector.w
		return {x=-tempx,y=-tempy,z=-tempz,w=tempw};
	end

	function vector.complex_part()
		tempx=vector.x
		tempy=vector.y
		tempz=vector.z
		return {x=tempx,y=tempy,z=tempz}
	end
	function vector.mult(QuatVector)
		-- Õâ¸öµØ·½ÓÃµÄÊÇËÄÎ¬ÏòÁ¿
		tempx=vector.w*QuatVector.x + vector.x*QuatVector.w + vector.y*QuatVector.z - vector.z*QuatVector.y
		tempy=vector.w*QuatVector.y - vector.x*QuatVector.z + vector.y*QuatVector.w + vector.z*QuatVector.x
		tempz=vector.w*QuatVector.z + vector.x*QuatVector.y - vector.y*QuatVector.x + vector.z*QuatVector.w
		tempw=vector.w*QuatVector.w - vector.x*QuatVector.x - vector.y*QuatVector.y - vector.z*QuatVector.z
		return {x=tempx,y=tempy,z=tempz,w=tempw}
	end
	return vector
end



--[[
local myNum={x=1,y=2,z=3,w=4}

myVector = Quaternion:_init(myNum)
conj_myNum = myVector.conj()
myVector.show(conj_myNum )
--]]
