-- DO NOT WRITE CODE OUTSIDE OF THE if-then-end SECTIONS BELOW!! (unless the code is a function definition)

-- Author : R Hariharan
-- Description : This is a child script for a our model which make it go to a perticular co-odrinate using a P controller
-- Refrence to all Regular API function used here : http://www.coppeliarobotics.com/helpFiles/en/apiFunctionListCategory.htm

-- Function reduces the precision of the number to 3 decimal places
function cleanNumbers(number)
    number = tonumber(string.format("%.3f",number))
    if (number == 0) then
        return 0
    end
    return number
end

-- Function to set velocity of the wheels of the robot
function setVelocity(velLeft,velRight)
    simSetJointTargetVelocity(leftWheel,velLeft)
    simSetJointTargetVelocity(rightWheel,velRight)
end

-- Function to compute the velocity of the left and right wheel using P-controller
function getVelocityOfWheels(x,y)
    KP = 0.013 -- Propotional gain
	position = simGetObjectPosition(eYSIP_bot,-1) -- Get the global position of the robot
    orientation = simGetObjectOrientation(eYSIP_bot,-1) -- Get the global orientation of the robot

    -- Calculate the distance error and angle error
    distance_error =  math.sqrt(((x - cleanNumbers(position[1]))^2 + (y - cleanNumbers(position[2]))^2))
    local_angle_error = math.atan2(y - position[2], x - position[1]) -- the angle to which the point lies
    local_angle_error = local_angle_error * 180 / math.pi + 90 -- Correction of 90 degrees because the orientation across z-axis is measured from negative y-axis
    print("______________________",local_angle_error,angle_error)
    if(local_angle_error > 180) then
        local_angle_error = local_angle_error - 360
    end
    angle_error = local_angle_error - (cleanNumbers(orientation[3]) * 180 / math.pi)
    print("______________________",local_angle_error,angle_error)

    omega = KP * cleanNumbers(angle_error)
    velocity = KP * cleanNumbers(distance_error)
    robotLength = 0.08 -- our model's length 
    wheelRadius = 0.015 -- our model's wheel radius

    -- Calculate the velocity based the equation of differential drive system
    velocity_left = (2 * velocity - 0.08 * omega) / 0.03
    velocity_right = (2 * velocity + 0.08 * omega) / 0.03
    return {cleanNumbers(velocity_left),cleanNumbers(velocity_right)}
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
    -- Getting All sensor objects, wheel ojects and the robot
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
end


if (sim_call_type==sim_childscriptcall_actuation) then
    -- Put your main ACTUATION code here

    -- For example:
    --
    -- local position=simGetObjectPosition(handle,-1)
    -- position[1]=position[1]+0.001
    -- simSetObjectPosition(handle,-1,position)
    if (sensorValues ~= 0) then
    	local velocity = getVelocityOfWheels(-1,0) -- Mention the co-ordinate the robot must go to
        print(velocity[1],velocity[2])
        setVelocity(velocity[1],velocity[2])
    end
end


if (sim_call_type==sim_childscriptcall_sensing) then
    -- Put your main SENSING code here
    sensorValues = 1
end


if (sim_call_type==sim_childscriptcall_cleanup) then
    -- Put some restoration code here
end
