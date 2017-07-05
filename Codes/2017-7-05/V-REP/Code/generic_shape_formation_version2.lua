-- DO NOT WRITE CODE OUTSIDE OF THE if-then-end SECTIONS BELOW!! (unless the code is a function definition)
function cleanNumbers(number)
    number = tonumber(string.format("%.3f",number))
    if (number == 0) then
        return 0
    end   
    return number
end

function distance(x1,y1,x2,y2)
    return math.sqrt(((x1-x2)^2) + ((y1-y2)^2))
end

function round_off(number)
    local floor_value = math.floor(number)
    local decimal_value = number - floor_value
    if(decimal_value < 0.5) then
        return floor_value
    else
        return math.ceil(number)
    end
end

function setVelocity(velLeft,velRight)
    simSetJointTargetVelocity(leftWheel,velLeft)
    simSetJointTargetVelocity(rightWheel,velRight)
end

function getVelocityOfWheels(x,y)
    KP = 0.09
    position = simGetObjectPosition(eYSIP_bot,-1)
    orientation = simGetObjectOrientation(eYSIP_bot,-1)

    distance_error =  math.sqrt(((x - cleanNumbers(position[1]))^2 + (y - cleanNumbers(position[2]))^2))
    local_angle_error = math.atan2(y - position[2], x - position[1])
    local_angle_error = local_angle_error * 180 / math.pi + 90
    -- print("______________________",local_angle_error,angle_error)
    if(local_angle_error > 180) then
        local_angle_error = local_angle_error - 360
    end
    angle_error = local_angle_error - (cleanNumbers(orientation[3]) * 180 / math.pi)
    -- print("______________________",local_angle_error,angle_error,cleanNumbers(orientation[3]) * 180 / math.pi)
    if(angle_error < -180) then
        angle_error = angle_error + 360
    elseif(angle_error > 180) then
        angle_error = angle_error - 360
    end
    -- angle_error = angle_error + (135 - local_angle_error) 
    -- print("______________________",local_angle_error,angle_error)
    if (not reached_destination and not zone_flag) then
        -- print(angle_error,sensor_angle)
        angle_error = angle_error + sensor_angle
    end
    if(front_sensor_flag) then
    	distance_error = 0
    end
    omega = KP * cleanNumbers(angle_error)
    -- print("______________________________________ OMEGA",omega)
    velocity = KP * cleanNumbers(distance_error)
    robotLength = 0.08
    wheelRadius = 0.015

    velocity_left = (2 * velocity - 0.08 * omega) / 0.03
    velocity_right = (2 * velocity + 0.08 * omega) / 0.03

    return {cleanNumbers(velocity_left),cleanNumbers(velocity_right)}
end

function  getVerticeForRobot()
    local main_vertices_length = table.getn(main_vertices)
    local fill_vertices_length = table.getn(fill_vertices)
    local mid_points_length = table.getn(mid_points)
    local robot_position = simGetObjectPosition(eYSIP_bot,-1)
    local min_dist = 10000
    local min_position = nil
    local min_vertice = {robot_position[1],robot_position[2]}
    if (main_vertices_length ~= main_vertice_counter) then
        for i=1,main_vertices_length do
            if(not main_vertices_present[i]) then
                local dist = distance(robot_position[1],robot_position[2],main_vertices[i][1],main_vertices[i][2])
                if(min_dist > dist) then
                    min_dist = dist
                    min_vertice = main_vertices[i]
                    min_position = i
                end
            end
        end
        return min_vertice,"main", min_position
    elseif (fill_vertices_length ~= fill_vertice_counter) then
        for i=1,fill_vertices_length do
            if(not fill_vertices_present[i]) then
                local dist = distance(robot_position[1],robot_position[2],fill_vertices[i][1],fill_vertices[i][2])
                if(min_dist > dist) then
                    min_dist = dist
                    min_vertice = fill_vertices[i]
                    min_position = i
                end
            end
        end
        return min_vertice,"fill", min_position
    else
        for i=1,mid_points_length do
            if(not mid_points_present[i]) then
                local dist = distance(robot_position[1],robot_position[2],mid_points[i][1],mid_points[i][2])
                if(min_dist > dist) then
                    min_dist = dist
                    min_vertice = mid_points[i]
                    min_position = i
                end
            end
        end
        return min_vertice,"mid", min_position
    end
end

function vertice_exists(vertice)
    local main_vertices_length = table.getn(main_vertices)
    local fill_vertices_length = table.getn(fill_vertices)
    if(main_vertices_length ~= 0 and fill_vertices_length ~= 0) then
        for i=1,main_vertices_length do
            if(main_vertices[i][1] == vertice[1] and main_vertices[i][2] == vertice[2]) then
                return true
            end
        end
        for i=1,fill_vertices_length do
            if(fill_vertices[i][1] == vertice[1] and fill_vertices[i][2] == vertice[2]) then
                return true
            end
        end
    end
    return false
end

function populate_vetices()
    for i=1,14 do
        if (shape[i] == 1) then
            table.insert(mid_points,{(vertices[i][1][1]+vertices[i][2][1])/2,(vertices[i][1][2]+vertices[i][1][2])/2})
            table.insert(mid_points_present,false)
            if(i % 2 == 0) then
                if(shape[i-1] == 1) then
                    if(not vertice_exists(vertices[i][2])) then
                        table.insert(main_vertices,vertices[i][2])
                        table.insert(main_vertices_present,false)  
                    end
                    if(not vertice_exists(vertices[i][1])) then
                        table.insert(fill_vertices,vertices[i][1])
                        table.insert(fill_vertices_present,false)
                    end
                else
                    if(not vertice_exists(vertices[i][1])) then
                        table.insert(main_vertices,vertices[i][1])
                        table.insert(main_vertices_present,false)
                    end
                    if(not vertice_exists(vertices[i][2])) then
                        table.insert(main_vertices,vertices[i][2])
                        table.insert(main_vertices_present,false)
                    end
                end
            else
                if(shape[i+1] == 1) then
                    if(not vertice_exists(vertices[i][1])) then
                        table.insert(main_vertices,vertices[i][1])
                        table.insert(main_vertices_present,false)  
                    end
                    if(not vertice_exists(vertices[i][2])) then
                        table.insert(fill_vertices,vertices[i][2])
                        table.insert(fill_vertices_present,false)
                    end
                else
                    if(not vertice_exists(vertices[i][1])) then
                        table.insert(main_vertices,vertices[i][1])
                        table.insert(main_vertices_present,false)
                    end
                    if(not vertice_exists(vertices[i][2])) then
                        table.insert(main_vertices,vertices[i][2])
                        table.insert(main_vertices_present,false)
                    end
                end
            end
        end
    end
end

function valueBetween(value,bottom_value,top_value)
    return (value > bottom_value) and (value < top_value)
end

function should_i_proceed()
	local robot_position = simGetObjectPosition(eYSIP_bot,-1)
	local robot_orientation = simGetObjectOrientation(eYSIP_bot,-1)
	local angle_of_sensor = math.pi/4
	local do_i_proceed = true
	local min_dist = distance(robot_position[1],robot_position[2],vertice[1],vertice[2])
	for i=1,8 do
		if(sensorValues[i] ~= nil) then
			local x_cord = robot_position[1] + (sensorValues[i] + 0.04) * math.cos(robot_orientation[3] - (math.pi/2) + angle_of_sensor * (i-1))
			local y_cord = robot_position[2] + (sensorValues[i] + 0.04) * math.sin(robot_orientation[3] - (math.pi/2) + angle_of_sensor * (i-1))
			local cord_distance = distance(x_cord,y_cord,vertice[1],vertice[2])
			-- print(x_cord,y_cord)
			-- print("___________________________",cord_distance,min_dist)
			if(cord_distance < min_dist) then
				-- print("falseeeeeeeeeeeeeeeeeeeeee")
				do_i_proceed = false
				break
			end
		end
	end
	return do_i_proceed
end

if (sim_call_type==sim_childscriptcall_initialization) then

    -- Put some initialization code here

    -- Make sure you read the section on "Accessing general-type objects programmatically"
    -- For instance, if you wish to retrieve the handle of a scene object, use following instruction:
    --
    -- handle=simGetObjectHandle('sceneObjectName')
    -- 
    -- Above instruction retrieves the handle of 'sceneObjectName' if this script's name has no '#' in it
    --
    -- If this script's name contains a '#' (e.g. 'someName#4'), then above instruction retrieves the handle of object 'sceneObjectName#4'
    -- This mechanism of handle retrieval is very convenient, since you don't need to adjust any code when a model is duplicated!
    -- So if the script's name (or rather the name of the object associated with this script) is:
    --
    -- 'someName', then the handle of 'sceneObjectName' is retrieved
    -- 'someName#0', then the handle of 'sceneObjectName#0' is retrieved
    -- 'someName#1', then the handle of 'sceneObjectName#1' is retrieved
    -- ...
    --
    -- If you always want to retrieve the same object's handle, no matter what, specify its full name, including a '#':
    --
    -- handle=simGetObjectHandle('sceneObjectName#') always retrieves the handle of object 'sceneObjectName' 
    -- handle=simGetObjectHandle('sceneObjectName#0') always retrieves the handle of object 'sceneObjectName#0' 
    -- handle=simGetObjectHandle('sceneObjectName#1') always retrieves the handle of object 'sceneObjectName#1'
    -- ...
    --
    -- Refer also to simGetCollisionhandle, simGetDistanceHandle, simGetIkGroupHandle, etc.
    --
    -- Following 2 instructions might also be useful: simGetNameSuffix and simSetNameSuffix
    sensor0 = simGetObjectHandle("Sensor0")
    sensor1 = simGetObjectHandle("Sensor1")
    sensor2 = simGetObjectHandle("Sensor2")
    sensor3 = simGetObjectHandle("Sensor3")
    sensor4 = simGetObjectHandle("Sensor4")
    sensor5 = simGetObjectHandle("Sensor5")
    sensor6 = simGetObjectHandle("Sensor6")
    sensor7 = simGetObjectHandle("Sensor7")
    leftWheel = simGetObjectHandle("LeftWheelJoint")
    rightWheel = simGetObjectHandle("RightWheelJoint")
    eYSIP_bot = simGetObjectHandle("eYSIP_Swarm_Bot")
    sensorValues = 0
    scale_value = 0.5
    main_vertices = {}
    fill_vertices = {}
    mid_points = {}
    main_vertices_present = {}
    fill_vertices_present = {}
    mid_points_present = {}
    local scale_X_2 = scale_value * 2
    main_vertice_counter = 0
    fill_vertice_counter = 0
    shape = {1,1,1,1,0,0,1,1,0,0,1,0,0,0}
    vertices = {
        {{0,0}, {0,scale_value}},                               -- 1
        {{0,scale_value}, {0,scale_X_2}},                       -- 2
        {{0,scale_X_2}, {scale_value,scale_X_2}},               -- 3
        {{scale_value,scale_X_2}, {scale_X_2,scale_X_2}},       -- 4
        {{scale_X_2,scale_X_2}, {scale_X_2,scale_value}},       -- 5
        {{scale_X_2,scale_value}, {scale_X_2,0}},               -- 6
        {{scale_X_2,0}, {scale_value,0}},                       -- 7
        {{scale_value,0}, {0,0}},                               -- 8
        {{0,0}, {scale_value,scale_value}},                     -- 9
        {{scale_value,scale_value}, {scale_X_2,scale_X_2}},     -- 10
        {{0,scale_value}, {scale_value,scale_value}},           -- 11
        {{scale_value,scale_value}, {scale_X_2,scale_value}},   -- 12
        {{0,scale_X_2}, {scale_value,scale_value}},             -- 13
        {{scale_value,scale_value}, {scale_X_2,0}},             -- 14
    }
    sensor_angle = 0
    reached_destination = false
    zone_flag = false
    go_to_goal_flag = false
    populate_vetices()
end


if (sim_call_type==sim_childscriptcall_actuation) then
    -- Put your main ACTUATION code here

    -- For example:
    --
    -- local position=simGetObjectPosition(handle,-1)
    -- position[1]=position[1]+0.001
    -- simSetObjectPosition(handle,-1,position)
    -- local to_go_vertice = getVerticeForRobot()
    local robot_position = simGetObjectPosition(eYSIP_bot,-1)
    if (not go_to_goal_flag) then
        if(not reached_destination) then
            vertice,vertice_type,vertice_index = getVerticeForRobot()
            -- print(vertice_type,vertice_index)
            go_to_goal_flag = true
        else
            if (not valueBetween(robot_position[1],vertice[1]-0.01,vertice[1]+0.01) or not valueBetween(robot_position[2],vertice[2]-0.01,vertice[2]+0.01)) then
             reached_destination = false
            end
        end         
    else
        if (valueBetween(robot_position[1],vertice[1]-0.15,vertice[1]+0.15) and valueBetween(robot_position[2],vertice[2]-0.2,vertice[2]+0.2)) then
            zone_flag = true
            if(should_i_proceed()) then
                if (valueBetween(robot_position[1],vertice[1]-0.01,vertice[1]+0.01) and valueBetween(robot_position[2],vertice[2]-0.01,vertice[2]+0.01)) then   
                    go_to_goal_flag = false
                    reached_destination = true
                    setVelocity(0,0)
                    -- print("reached_destination")
                else
                    local robot_velocity = getVelocityOfWheels(vertice[1],vertice[2])
                    setVelocity(robot_velocity[1],robot_velocity[2])
                end
            else
                zone_flag = false
                if (vertice_type == "main") then
                    -- print(vertice_index,main_vertices_present[vertice_index])
                    main_vertices_present[vertice_index] = true
                    main_vertice_counter = main_vertice_counter + 1
                elseif (vertice_type == "fill") then
                    fill_vertices_present[vertice_index] = true
                    fill_vertice_counter = fill_vertice_counter + 1
                else
                    mid_points_present[vertice_index] = true
                end
                go_to_goal_flag = false
                setVelocity(0,0)
            end
        else
            zone_flag = false
            local robot_velocity = getVelocityOfWheels(vertice[1],vertice[2])
            setVelocity(robot_velocity[1],robot_velocity[2])
        end
    end

end


if (sim_call_type==sim_childscriptcall_sensing) then
    -- Put your main SENSING code here
    local x = 1
    sensorValues = {}
    sensor_angle = 0
    front_sensor_flag = false
    x,sensorValues[1] = simHandleProximitySensor(sensor0)
    x,sensorValues[2] = simHandleProximitySensor(sensor1)
    x,sensorValues[3] = simHandleProximitySensor(sensor2)
    x,sensorValues[4] = simHandleProximitySensor(sensor3)
    x,sensorValues[5] = simHandleProximitySensor(sensor4)
    x,sensorValues[6] = simHandleProximitySensor(sensor5)
    x,sensorValues[7] = simHandleProximitySensor(sensor6)
    x,sensorValues[8] = simHandleProximitySensor(sensor7)
    if (sensorValues[2] ~= nil) then
        sensor_angle = sensor_angle - (0.1 - sensorValues[2]) * 450  
    end
    if (sensorValues[3] ~= nil) then
        sensor_angle = sensor_angle - (0.1 - sensorValues[3]) * 450
    end
    if (sensorValues[8] ~= nil) then
        sensor_angle = sensor_angle + (0.1 - sensorValues[8]) * 300
    end
    if (sensorValues[7] ~= nil) then
        sensor_angle = sensor_angle + (0.1 - sensorValues[7]) * 300
    end
    if (sensorValues[1] ~= nil) then
        sensor_angle = 45
        front_sensor_flag = true
    end
end

if (sim_call_type==sim_childscriptcall_cleanup) then
    -- Put some restoration code here
end