-- DO NOT WRITE CODE OUTSIDE OF THE if-then-end SECTIONS BELOW!! (unless the code is a function definition)
function cleanNumbers(number)
    number = tonumber(string.format("%.3f",number))
    if (number == 0) then
        return 0
    end
    return number
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

    omega = KP * cleanNumbers(angle_error)
    -- print("______________________________________ OMEGA",omega)
    velocity = KP * cleanNumbers(distance_error)
    robotLength = 0.08
    wheelRadius = 0.015

    velocity_left = (2 * velocity - 0.08 * omega) / 0.03
    velocity_right = (2 * velocity + 0.08 * omega) / 0.03

    return {cleanNumbers(velocity_left),cleanNumbers(velocity_right)}
end

function goto(x,y)
    -- print(constraint1)
    if (constraint1 == true) then
        local vel = getVelocityOfWheels(x,y)
        setVelocity(vel[1],vel[2])
    else
        setVelocity(0,0)
    end
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
    radius_of_circle = 1
    robot_visibility_radius = 0.14
    constraint1 = true
    flag = true
end


if (sim_call_type==sim_childscriptcall_actuation) then
    -- Put your main ACTUATION code here

    -- For example:
    --
    -- local position=simGetObjectPosition(handle,-1)
    -- position[1]=position[1]+0.001
    -- simSetObjectPosition(handle,-1,position)
    if (sensorValues ~= 0) then

        local robot_position = simGetObjectPosition(eYSIP_bot,-1)
        local rt_a_sqr_b_sqr_value = distance(robot_position[1],robot_position[2],0,0)
        local a_sqr_b_sqr = rt_a_sqr_b_sqr_value ^ 2
        local c = radius_of_circle^2 + robot_position[1]^2 + robot_position[2]^2 - robot_visibility_radius^2
        rt_a_sqr_b_sqr_value = cleanNumbers(rt_a_sqr_b_sqr_value)
        if (flag and rt_a_sqr_b_sqr_value == radius_of_circle) then
            setVelocity(0,0)
        elseif (flag and rt_a_sqr_b_sqr_value == (radius_of_circle - robot_visibility_radius)) then
            print("case 2")
            x = c * robot_position[1]  / (2 * (rt_a_sqr_b_sqr_value^2))
            y = c * robot_position[2]  / (2 * (rt_a_sqr_b_sqr_value^2))
            local orientation = simGetObjectOrientation(eYSIP_bot,-1)
            local angle_of_the_point = math.atan2(y - robot_position[2], x - robot_position[1]) + (math.pi / 2)
            if(angle_of_the_point > math.pi) then
                angle_of_the_point = angle_of_the_point - (2 * math.pi)
            end
            local angle_diff = angle_of_the_point - orientation[3]
            local sensor_number = angle_diff / (math.pi / 4)
            sensor_number = round_off(sensor_number)
            if (sensorValues[sensor_number+1] ~= nil) then
                x = (x + robot_position[1])/2
                y = (y + robot_position[2])/2
                goto(x,y)
            else
                goto(x,y)
            end
            print(x,y)
            flag = false
        elseif(flag and rt_a_sqr_b_sqr_value == 0) then
            print("Case 4")
            x = 0.14
            y = 0
            local orientation = simGetObjectOrientation(eYSIP_bot,-1)
            local angle_of_the_point = math.atan2(y - robot_position[2], x - robot_position[1]) + (math.pi / 2)
            if(angle_of_the_point > math.pi) then
                angle_of_the_point = angle_of_the_point - (2 * math.pi)
            end
            local angle_diff = angle_of_the_point - orientation[3]
            local sensor_number = angle_diff / (math.pi / 4)
            sensor_number = round_off(sensor_number)
            if (sensorValues[sensor_number+1] ~= nil) then
                x = (x + robot_position[1])/2
                y = (y + robot_position[2])/2
                goto(x,y)
            else
                goto(x,y)
            end
            print(x,y)
            flag = false
        elseif(flag and rt_a_sqr_b_sqr_value < (radius_of_circle - robot_visibility_radius)) then
            print("case 3")
            local second_term = robot_position[1] * robot_visibility_radius / rt_a_sqr_b_sqr_value 
            local x1 = robot_position[1] - second_term
            local x2 = x1 + 2 * second_term
            local y1 = (robot_position[2]/robot_position[1]) * x1
            local y2 = (robot_position[2]/robot_position[1]) * x2
            -- print(robot_position[1],robot_position[2],robot_visibility_radius)
            -- print(second_term,x1,y1)
            -- print(x2,y2)
            if(distance(x1,y1,0,0) > distance(x2,y2,0,0)) then
                x = x1
                y = y1
            else
                x = x2
                y = y2
            end
            local orientation = simGetObjectOrientation(eYSIP_bot,-1)
            local angle_of_the_point = math.atan2(y - robot_position[2], x - robot_position[1]) + (math.pi / 2)
            if(angle_of_the_point > math.pi) then
                angle_of_the_point = angle_of_the_point - (2 * math.pi)
            end
            local angle_diff = angle_of_the_point - orientation[3]
            local sensor_number = angle_diff / (math.pi / 4)
            sensor_number = round_off(sensor_number)
            if (sensorValues[sensor_number+1] ~= nil) then
                x = (x + robot_position[1])/2
                y = (y + robot_position[2])/2
                goto(x,y)
            else
                goto(x,y)
            end
            print(x,y)
            flag = false
        elseif(flag and rt_a_sqr_b_sqr_value > (radius_of_circle - robot_visibility_radius) and rt_a_sqr_b_sqr_value < radius_of_circle) then
            print("case 5")
            local angle_with_x_axis = math.atan2(robot_position[2],robot_position[1])
            x = radius_of_circle * math.cos(angle_with_x_axis)
            y = radius_of_circle * math.sin(angle_with_x_axis)
            local x1 = (c * robot_position[2] - robot_position[1] * math.sqrt(8 * radius_of_circle^2 * a_sqr_b_sqr - c^2))/ (2 * a_sqr_b_sqr)
            local x2 = x1 + 2 * (robot_position[1] * math.sqrt(8 * radius_of_circle^2 * a_sqr_b_sqr - c^2))/ (2 * a_sqr_b_sqr)
            if (x1 > x2) then
                local y1 = math.sqrt(radius_of_circle^2 - x1^2)
                local angle_1 = math.atan2(y1,x1)
                local angle_2 = math.atan2(-y1,x1)
                local angdiff_1 = angle_with_x_axis - angle_1
                local angdiff_2 = angle_with_x_axis - angle_2
                if(angdiff_1 > angdiff_2) then
                    r_x = x1
                    r_y = y1
                else
                    r_x = x1
                    r_y = -y1
                end
            else
                local y2 = math.sqrt(radius_of_circle^2 - x2^2)
                local angle_1 = math.atan2(y2,x2)
                local angle_2 = math.atan2(-y2,x2)
                local angdiff_1 = angle_with_x_axis - angle_1
                local angdiff_2 = angle_with_x_axis - angle_2
                if(angdiff_1 > angdiff_2) then
                    r_x = x2
                    r_y = y2
                else
                    r_x = x2
                    r_y = -y2
                end

            end
            local orientation = simGetObjectOrientation(eYSIP_bot,-1)
            local sector_angle_diff = 0.15/radius_of_circle;
            local sensor_number = 0 
            while x <= r_x do
                local angle_of_the_point = math.atan2(y - robot_position[2], x - robot_position[1]) + (math.pi / 2)
                if(angle_of_the_point > math.pi) then
                    angle_of_the_point = angle_of_the_point - (2 * math.pi)
                end
                local angle_diff = angle_of_the_point - orientation[3]
                sensor_number = angle_diff / (math.pi / 4)
                sensor_number = round_off(sensor_number)
                if(sensorValues[sensor_number+1] == nil) then
                    break
                end
                angle_with_x_axis = math.atan2(y,x)
                angle_with_x_axis = angle_with_x_axis - sector_angle_diff
                x = radius_of_circle * math.cos(angle_with_x_axis)
                y = radius_of_circle * math.sin(angle_with_x_axis)
            end
            if(sensorValues[sensor_number+1] ~= nil) then
                x = (robot_position[1] + r_x)/2
                y = (robot_position[2] + r_y)/2
                goto(x,y)
            else
                goto(x,y)
            end
            print(x,y)
            flag = false
        elseif(not flag) then
            if((not ((x - 0.01) < robot_position[1] and robot_position[1] < (x + 0.01))) or (not ((y - 0.01) < robot_position[2] and robot_position[2] < (y + 0.01)))) then
                goto(x,y)
            else
                flag = true
            end
        end     
    end
end


if (sim_call_type==sim_childscriptcall_sensing) then
    -- Put your main SENSING code here
    local x = 1
    sensorValues = {}
    x,sensorValues[1] = simHandleProximitySensor(sensor0)
    x,sensorValues[2] = simHandleProximitySensor(sensor1)
    x,sensorValues[3] = simHandleProximitySensor(sensor2)
    x,sensorValues[4] = simHandleProximitySensor(sensor3)
    x,sensorValues[5] = simHandleProximitySensor(sensor4)
    x,sensorValues[6] = simHandleProximitySensor(sensor5)
    x,sensorValues[7] = simHandleProximitySensor(sensor6)
    x,sensorValues[8] = simHandleProximitySensor(sensor7)
    local alpha, thetha
    local count = 0
    for i=1,8 do
        if(sensorValues[i] ~= nil) then
        
            alpha = (math.pi / 4) * (i - 1)
            local orientation_angles = simGetObjectOrientation(eYSIP_bot,-1)
            local robot_position = simGetObjectPosition(eYSIP_bot,-1)
            thetha = orientation_angles[3] - (math.pi / 2)
            local x_j = robot_position[1] + ((sensorValues[i] + 0.04) * math.cos(alpha + thetha))
            local y_j = robot_position[2] + ((sensorValues[i] + 0.04) * math.sin(alpha + thetha))
            local distance_i = distance(robot_position[1],robot_position[2],0,0)
            local distance_j = distance(x_j,y_j,0,0)
            -- print(x_j,y_j)
            -- print(distance_i,distance_j)
            if (flag and cleanNumbers(distance_i) == 0) then
                constraint1 = true
            elseif (flag and distance_i < distance_j and round_off(cleanNumbers(distance_j)) == radius_of_circle) then
                constraint1 = true
            elseif (flag and distance_i >= distance_j and distance_j < radius_of_circle ) then
                constraint1 = true
            elseif(flag) then
                constraint1 = false
                break
            end
            count = count + 1
        end
    end
    if(count == 0) then
        constraint1 = true
    end
end

if (sim_call_type==sim_childscriptcall_cleanup) then
    -- Put some restoration code here
end