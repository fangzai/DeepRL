--[[
	this project implements the Helicopter model from Andrew NG or his student Abbeel
	coded by ht
	2015-4-3 to 2015-4-7
	though I have tested those functions, there may exist tiny errors.
--]]
require 'Quaternion'

require 'HeliVector'

HelicopterState={}

function HelicopterState:_init()
	--这个地方就不给参数了，太多参数了
	local table={
		ndot_idx = 1,         -- north velocity
		--给的是一些参数下标的限制  必须从1 开始
		edot_idx = 2,         -- east velocity
		ddot_idx = 3,         -- down velocity
		n_idx = 4, 	--north
		e_idx = 5, 	--east
		d_idx = 6, 	--down
		p_idx = 7, 		--angular rate around forward axis
		q_idx = 8, 		--angular rate around sideways (to the right) axis
		r_idx = 9, 		--angular rate around vertical (downward) axis
		qx_idx = 10,
		--quaternion entries, x,y,z,w   q = [ sin(theta/2) * axis; cos(theta/2)]
		qy_idx = 11,
		--where axis = axis of rotation; theta is amount of rotation around that axis
		qz_idx = 12,
		--[recall: any rotation can be represented by a single rotation around some axis]

		qw_idx = 13,  --这个状态是不需要的
		state_size = 13,
		-- 以上定义的状态下标

		NUMOBS = 12,
		-- note: observation returned is not the state itself, but the "error state" expressed in the helicopter's frame (which allows for a simpler mapping from observation to inputs)
		-- observation consists of:
		-- u, v, w  : velocities in helicopter frame
		-- xerr, yerr, zerr: position error expressed in frame attached to helicopter [xyz correspond to ned when helicopter is in "neutral" orientation, i.e., level and facing north]
		-- p, q, r
		-- qx, qy, qz
		env_terminal = false, -- 用于表示仿真是否结束
		num_sim_steps = 0,   -- 用于计数的
		wind={0,0},   -- 风的干扰

		-- 下面表示是一些状态限制
		MAX_VEL = 5.0,
		MAX_POS = 20.0,
		MAX_RATE = 2 * 3.1415 * 2,
		MAX_QUAT = 1.0,
		MIN_QW_BEFORE_HITTING_TERMINAL_STATE = math.cos(30.0 / 2.0 * math.pi / 180.0),
		MAX_ACTION = 1.0,
		WIND_MAX = 5.0,   -- 风的最大系数
		--mins = {-MAX_VEL,-MAX_VEL,-MAX_VEL,-MAX_POS, -MAX_POS, -MAX_POS, -MAX_RATE, -MAX_RATE, -MAX_RATE, -MAX_QUAT, -MAX_QUAT, -MAX_QUAT, -MAX_QUAT},
		--maxs = {MAX_VEL, MAX_VEL, MAX_VEL, MAX_POS, MAX_POS, MAX_POS, MAX_RATE, MAX_RATE, MAX_RATE, MAX_QUAT, MAX_QUAT, MAX_QUAT, MAX_QUAT},
		mins={},
		maxs={},

		-- very crude helicopter model, okay around hover:
		heli_model_u_drag = 0.18,
		heli_model_v_drag = 0.43,
		heli_model_w_drag = 0.49,
		heli_model_p_drag = 12.78,
		heli_model_q_drag = 10.12,
		heli_model_r_drag = 8.16,
		heli_model_u0_p = 33.04,
		heli_model_u1_q = -33.32,
		heli_model_u2_r = 70.54,
		heli_model_u3_w = -42.15,
		heli_model_tail_rotor_side_thrust = -0.54,
		DT = 0.1,    -- 表示每次运行0.1s
		NUM_SIM_STEPS_PER_EPISODE = 6000,  -- 运行6000步
		velocity={x=0,y=0,z=0}, -- 先这么干 到时候还需要再那个调整
		position={x=0,y=0,z=0},
		angular_rate={x=0,y=0,z=0},
		q={x=0,y=0,z=0,w=1},
		noise={0,0,0,0,0,0},  -- 原始的是没有赋值的？？？？？？？？？？？
	}
	function table.setMinMax()
		for i=1,3 do
			table.mins[i] = -table.MAX_VEL
			table.maxs[i] =  table.MAX_VEL
		end
		for i=4,6 do
			table.mins[i] = -table.MAX_POS
			table.maxs[i] =  table.MAX_POS
		end
		for i=7,9 do
			table.mins[i] = -table.MAX_RATE
			table.maxs[i] =  table.MAX_RATE
		end
		for i=10,12 do
			table.mins[i] = -table.MAX_QUAT
			table.maxs[i] =  table.MAX_QUAT
		end
	end

	table.setMinMax()  --需要在init函数里面执行一下，表示初始化

	function table.reset()
		print("the state of Helicopter has been reset....")
		table.velocity={x=0,y=0,z=0}   -- 先这么干 到时候还需要再那个调整
		table.position={x=0,y=0,z=0}
		table.angular_rate={x=0,y=0,z=0}
		table.q={x=0,y=0,z=0,w=1}

		table.noise = {0,0,0,0,0,0}  -- 原始的是没有赋值的？？？？？？？？？？？
		-- table.q = {x=0,y=0,z=0,w=1}
		table.num_sim_steps = 0
		table.env_terminal = false
	end

	function table.checkObservationConstraints(observationArrays)
		for i=1,table.NUMOBS do
			if(observationArrays[i] > table.maxs[i]) then
				observationArrays[i] = table.maxs[i]
			end

			if(observationArrays[i] < table.mins[i]) then
				observationArrays[i] = table.mins[i]
			end
		end
	end


	--[[
		这个地方很重要，我只是为了和原来的模型比较才有了现在的设置x1和x2是常数
		实际上，他们是随机值，只需要把这两行设置给注释掉就可以了
	--]]
	function table.box_mull()
		x1 = math.random()   -- 产生0-1的随机数  尽管和java里面的会有一些不同，测试比较的时候设置成一样的就可以了
		x2 = math.random()
		x1 = 0.5
		x2 = 0.5  ------------?????????????????
		tempValue = math.sqrt(-2.0 * math.log(x1)) * math.cos(2.0 * math.pi * x2)
		return tempValue
	end

	function table.rand_minus_plus1()
		--此函数没有用
		x1 = math.random()
		tempValue = 2.0*x1 - 1.0
		return tempValue
	end

	function table.stateUpate(myAction)
		-- 我不确定这个地方是应该用类里面的还是自己传如一个状态
		for i=1, 4 do  -- 四维动作，而不是四个动作
			myAction[i] = math.min(math.max(myAction[i],-1),1.0)
			-- check action是在（-1， +1)之间
		end

		noise_mult = 2.0  -- 设置noise的一些参数
		noise_std = {0.1941, 0.2975, 0.6058, 0.1508, 0.2492, 0.0734}
		-- u, v, w, p, q, r

		noise_memory =0.8  -- 下面要产生高斯分布的随机数
		-- print(" noise is ......")
		for i=1, 6 do  -- 因为是对 uvw 还有pqr做的随机噪声
			table.noise[i] = noise_memory * table.noise[i] + (1.0 - noise_memory) * table.box_mull() * noise_std[i] *noise_mult

			--print(table.noise[i]) --计算noise的是还是正确的
		end

		dt = 0.01  -- 采样时间  integrate at 100Hz and control at 10Hz

		for t=0, 9 do  -- 程序运行的时候需要仔细考虑到底是0-9 还是1-10  ？？？？
			-- 欧拉积分
			-- print("the",t,"th loop....")
			-- 关于飞行速度
			table.position.x = table.position.x + dt * table.velocity.x
			table.position.y = table.position.y + dt * table.velocity.y
			table.position.z = table.position.z + dt * table.velocity.z

			local myVector0 = HeliVector:_init(table.velocity.x,table.velocity.y,table.velocity.z)
			uvw = myVector0.express_in_quat_frame(table.q)

			--printVector(table.position)
			--printVector(table.q)   -- 在这个地方 q值变化了
			-- printVector(uvw)
			-- display(myVector0)

			local myVector1 = HeliVector:_init(table.wind[1],table.wind[2],0.0)  --下标从1开始
			-- print(myVector1.x)
			wind_ned = myVector1  -- 返回值是3维
			-- print(wind_ned.x)

			local myVector2 = HeliVector:_init(wind_ned.x, wind_ned.y, wind_ned.z)
			--display(myVector2)
			wind_uvw = myVector2.express_in_quat_frame(table.q)
			--display(myVector2)
			--wind_uvw = myVector2.rotate(table.q)

			tempx = -table.heli_model_u_drag * (uvw.x + wind_uvw.x) + table.noise[1]
			tempy = -table.heli_model_v_drag * (uvw.y + wind_uvw.y) + table.heli_model_tail_rotor_side_thrust + table.noise[2]
			tempz = -table.heli_model_w_drag * uvw.z + table.heli_model_u3_w * myAction[4] + table.noise[3]

			local myVector3 = HeliVector:_init(tempx, tempy, tempz)
			uvw_force_from_heli_over_m = myVector3.vector
			---其实这个地方的表达式完全可以直接写为 uvw_force_from_heli_over_m = {x=tempx,y=tempy,z=tempz}
			ned_force_from_heli_over_m = myVector3.rotate(table.q)

			-- 速度积分

			table.velocity.x = table.velocity.x + dt * ned_force_from_heli_over_m.x
			table.velocity.y = table.velocity.y + dt * ned_force_from_heli_over_m.y
			table.velocity.z = table.velocity.z + dt * (ned_force_from_heli_over_m.z + 9.81)
			-- 9.81是重力加速度
			-- 可以print一下
			-- printVector(table.velocity)

			tempx = nil
			tempy = nil
			tempz = nil
			tempx = table.angular_rate.x * dt
			tempy = table.angular_rate.y * dt
			tempz = table.angular_rate.z * dt
			local myVector4 = HeliVector:_init(tempx, tempy, tempz)
			rot_quat = myVector4.to_quaternion()  --这个4维的
			-- printVector(rot_quat)
			local myVecotr5 = Quaternion:_init(table.q)
			table.q = myVecotr5.mult(rot_quat)  --旋转重新给q赋值

			-- printVector(table.q)
			-- angular_rate update
			p_dot = -table.heli_model_p_drag * table.angular_rate.x + table.heli_model_u0_p * myAction[1] + table.noise[4];
            q_dot = -table.heli_model_q_drag * table.angular_rate.y + table.heli_model_u1_q * myAction[2] + table.noise[5];
            r_dot = -table.heli_model_r_drag * table.angular_rate.z + table.heli_model_u2_r * myAction[3] + table.noise[6];

			table.angular_rate.x = table.angular_rate.x + dt * p_dot
			table.angular_rate.y = table.angular_rate.y + dt * q_dot
			table.angular_rate.z = table.angular_rate.z + dt * r_dot
			if(( not table.env_terminal) and (math.abs(table.position.x) > table.MAX_POS or
				math.abs(table.position.y) > table.MAX_POS or
				math.abs(table.position.z) > table.MAX_POS or
				math.abs(table.velocity.x) > table.MAX_VEL or
				math.abs(table.velocity.y) > table.MAX_VEL or
				math.abs(table.velocity.z) > table.MAX_VEL or
				math.abs(table.angular_rate.x) > table.MAX_RATE or
				math.abs(table.angular_rate.y) > table.MAX_RATE or
				math.abs(table.angular_rate.z) > table.MAX_RATE or
				math.abs(table.q.w) < table.MIN_QW_BEFORE_HITTING_TERMINAL_STATE)) then

				env_terminal = true  -- 判定此时状态结束

			end
		end

	end

	function table.makeObservations()
		-- 用于observe 状态的
		observations={}  -- 声明一下 这个地方是 12维度

		-- about the position
		local myHeliVectorPos = HeliVector:_init(table.position.x,table.position.y,table.position.z)
		ned_error_in_heli_frame = myHeliVectorPos.express_in_quat_frame(table.q) -- 返回的是三维的

		-- about the velocity
		local myHeliVectorVel = HeliVector:_init(table.velocity.x,table.velocity.y,table.velocity.z)
		uvw = myHeliVectorVel.express_in_quat_frame(table.q) -- 返回的是三维的

		observations[1] = uvw.x
		observations[2] = uvw.y
		observations[3] = uvw.z   -- 其实这个地方用那个table里面的下标的完全是可以的

		observations[table.n_idx] = ned_error_in_heli_frame.x
		observations[table.e_idx] = ned_error_in_heli_frame.y
		observations[table.d_idx] = ned_error_in_heli_frame.z

		observations[table.p_idx] = table.angular_rate.x
		observations[table.q_idx] = table.angular_rate.y
		observations[table.r_idx] = table.angular_rate.z

		-- the error quaternion gets negated, b/c
        -- we consider the rotation required to bring the helicopter
        -- back to target in the helicopter's frame
		observations[table.qx_idx] = table.q.x
		observations[table.qy_idx] = table.q.y
		observations[table.qz_idx] = table.q.z

		table.checkObservationConstraints(observations)  -- check一下是否过界

		return observations

	end

	return table  -- 这句话必须有  否则就跪了
end


function change(myArray)
	-- 用于测试操作数组是可行的
	myArray[1]=2
	myArray[2]=30
end
--[[
	下面的这两个函数完全可以不要
--]]
function myMin(x,y)
	return math.min(x,y)
end
function myMax(x,y)
	return math.max(x,y)
end

--[[
local myVector=HelicopterState:_init()
--print(myVector.NUM_SIM_STEPS_PER_EPISODE)
--print(myMin(1,2))
--myNum={1,2}
--change(myNum)
--print(myNum[2])
--flag = true
--flag1 = false
--num = 1
--print(not num)
myAction = {0.5,0.5,0.5,0.5}
myVector.stateUpate(0,myAction)
--]]
--[[
print("position......")
display(myVector.position)
print("velocity......")
display(myVector.velocity)
print("angular_rate......")
display(myVector.angular_rate)
--
local observe = {}
observe = myVector.makeObservations()
print("the observation of state is ......")
for i=1,#observe do
	print(i,observe[i])
end
print("end of state is ......")
--]]
