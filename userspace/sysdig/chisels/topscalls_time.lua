-- The number of items to show
TOP_NUMBER = 30

-- Chisel description
description = "Show the top " .. TOP_NUMBER .. " system calls in terms of time spent in each call. You can use filters to restrict this to a specific process, thread or file."
short_description = "Top system calls by time"
category = "Performance"

-- Chisel argument list
args = {}

-- Argument notification callback
function on_set_arg(name, val)
	return false
end

-- Initialization callback
function on_init()
	chisel.exec("table_generator", 
		"evt.type",
		"System Call",
		"evt.latency",
		"Time",
		"", 
		"" .. TOP_NUMBER,
		"time")
	return true
end
