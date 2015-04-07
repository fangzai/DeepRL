--[[
	this project implements the Helicopter model from Andrew NG or his student Abbeel
	coded by ht
	2015-4-7
--]]

require "HelicopterState"

Helicopter = {}

function Helicopter:_init()
	local table={
		state={0,0,0,0,0,0,0,0,0,0,0,0},   --有12状态
		reward_state={0,0,0,0,0,0,0,0,0,0,0,0,0,0}, --一共1+12+1
		-- 1 reward
		-- 12 state
		-- 1 isterminal
		heli = {},
	}
	-- 初始化helicopter的状态


	function table.setWind(p)
		if(p ~= nil) then
			-- 这个地方可以设置风速 但是其实并没有实现
		end
	end
	function table.env_init()
		heli = HelicopterState:_init()
		return "Welcome to the world of Helicopter....."
	end
	function table.env_start()
		heli.reset()
		--print("the ")
		return table.makeObservations()
	end

	function table.env_step(myAction)
		-- myAction 必须是四维的
		-- for instance myAction={0.5,0.5,0.5,0.5}
		heli.stateUpate(myAction)
		heli.num_sim_steps = heli.num_sim_steps + 1  -- 步数+1
		heli.env_terminal = heli.env_terminal or (heli.num_sim_steps == heli.NUM_SIM_STEPS_PER_EPISODE)

		isTerminal = 0  -- 表示未有结束

		if(heli.env_terminal) then
			isTerminal = 1
		end
		reward_state={0,0,0,0,0,0,0,0,0,0,0,0,0,0} --一共1+12+1
		reward_state[1] = table.getReward()

		for i=1, heli.NUMOBS do  --当然可以直接写12
			reward_state[i+1]= table.makeObservations()[i]
		end
		reward_state[heli.NUMOBS+2] = isTerminal

		return reward_state

	end

	function table.getReward()
		local reward = 0
		if(not heli.env_terminal) then
			-- not in terminal state  也就没有结束
			reward = reward - heli.velocity.x * heli.velocity.x
			reward = reward - heli.velocity.y * heli.velocity.y
			reward = reward - heli.velocity.z * heli.velocity.z

			reward = reward - heli.position.x * heli.position.x
			reward = reward - heli.position.y * heli.position.y
			reward = reward - heli.position.z * heli.position.z

			reward = reward - heli.angular_rate.x * heli.ngular_rate.x
			reward = reward - heli.angular_rate.y * heli.ngular_rate.y
			reward = reward - heli.angular_rate.z * heli.ngular_rate.z

			reward = reward - heli.q.x * heli.q.x
			reward = reward - heli.q.y * heli.q.y
			reward = reward - heli.q.z * heli.q.z

		else
			-- in terminal state, obtain very negative reward. And the agent will exit
			reward = -3.0* Heli.MAX_POS * Heli.MAX_POS +
					 -3.0* Heli.MAX_RATE * Heli.MAX_RATE +
					 -3.0* Heli.MAX_VEL * Heli.MAX_VEL +
					 - (1.0f - Heli.MIN_QW_BEFORE_HITTING_TERMINAL_STATE * Heli.MIN_QW_BEFORE_HITTING_TERMINAL_STATE)

			reward = reward * heli.NUM_SIM_STEPS_PER_EPISODE - heli.num_sim_steps
		end

		return reward
	end

	function table.makeObservations()
		return heli.makeObservations()
	end
	return table
end

--[[
	test code
--]]
local myHeli = Helicopter:_init()
init_information = myHeli.env_init()
print(init_information)
myHeli.env_start()
local myAction={0.5,0.5,0.5,0.5}
print(heli.NUMOBS)
local ro={}
ro = myHeli.env_step(myAction)
for i =1, 14 do
	print(i, ro[i])
end

