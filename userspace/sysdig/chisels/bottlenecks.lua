-- The number of items to show
HOW_MANY = 10

-- Chisel description
description = "Lists the " .. HOW_MANY .. " system calls that took the longest to return during the capture interval.";
short_description = "Slowest system calls";
category = "Performance";

-- Chisel argument list
args = {}

slow_calls = {}
last_lines = {}

-- Initialization callback
function on_init()
	-- Request the fields
	fevnum = chisel.request_field("evt.num")
	fevtime = chisel.request_field("evt.time")
	fevtype = chisel.request_field("evt.type")
	fevtargs = chisel.request_field("evt.args")
	flatency = chisel.request_field("evt.latency")
	fprname = chisel.request_field("proc.name")
	ftid = chisel.request_field("thread.tid")
	
	return true
end

-- Event parsing callback
function on_event()
	latency = evt.field(flatency)
	tid = evt.field(ftid)
	evtype = evt.field(fevtype)
	
	if evtype == "switch" then
		return true
	end
	
	if latency == 0 then
		prname = evt.field(fprname)
		if prname == nil then
			prname = ""
		end			
		line = string.format("%d) 0.%.9d %s (%d) > %s %s", evt.field(fevnum), 
			0, 
			prname, 
			evt.field(ftid), 
			evtype, 
			evt.field(fevtargs))
		
		last_lines[tid] = line
	else
		for j = 1, HOW_MANY do
			if slow_calls[j] == nil or latency > slow_calls[j][1] then
				prname = evt.field(fprname)
				if prname == nil then
					prname = ""
				end
				
				line = string.format("%d) %d.%.9d %s (%d) < %s %s", evt.field(fevnum), 
					latency / 1000000000, 
					latency % 1000000000, 
					prname, evt.field(ftid), 
					evtype, 
					evt.field(fevtargs))

				table.insert(slow_calls, j, {latency, last_lines[tid], line})
				break
			end
		end
		
		if table.getn(slow_calls) > HOW_MANY then
			table.remove(slow_calls)
		end	
	end
	
	return true
end

-- Interval callback, emits the ourput
function on_capture_end()
	for j = 1, table.getn(slow_calls) do
		print(slow_calls[j][2])
		print(slow_calls[j][3])
	end

	return true
end
