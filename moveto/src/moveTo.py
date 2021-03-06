#!/usr/bin/env python

import roslib;
import rospy
import actionlib
import sys
import time

# move_base_msgs
from move_base_msgs.msg import *
# import std messages 
from std_msgs.msg import String

docked = False;

'''
 used to move the turtlebot to either the home or the away position
 @param move_position int[]
 return actionlib status
'''
def simple_move(move_position):

    # Simple Action Client
    sac = actionlib.SimpleActionClient('move_base', MoveBaseAction )

    # create goal
    goal = MoveBaseGoal()

    # set goal
    goal.target_pose.pose.position.x = move_position[0]
    goal.target_pose.pose.position.y = move_position[1]
    goal.target_pose.pose.orientation.z = move_position[2]
    goal.target_pose.pose.orientation.w = move_position[3]
    goal.target_pose.header.frame_id = 'map'
    goal.target_pose.header.stamp = rospy.Time.now()

    # start listner
    sac.wait_for_server()

    # send goal
    sac.send_goal(goal)

    # finish
    sac.wait_for_result()

    # check status of result
    return sac.get_state()

'''
 send an event to the salt master wich reacts acordingly
 @param succeded boolean
 @param message String
'''
def sendGoalEvent(succeded, message):
    # create a salt caller
    caller = salt.client.Caller()

    caller.sminion.functions['event.send'](
        'moveto/goal/success',
        {
            'success': succeded,
            'message': message,
        }
    )

'''
 send goal event via the event Topic to the listener
 in the cloud, which reacts acordingly.
 @param status String
'''
def goalReached(status):
    dockedListener()
    global docked
    pub = rospy.Publisher('event', String, queue_size=10)
    r = rospy.Rate(5)

    event_str = "closeToBase/" + status
    rospy.loginfo(event_str)

    while(pub.get_num_connections() == 0):
        r.sleep()

    while docked == False:
        pub.publish(event_str)
        r.sleep()


def dockedListener():
    #rospy.init_node('dockedListener', anonymous=True)
    rospy.Subscriber("event", String, callback)
    #rospy.spin()


def callback(data):
    message = data.data.split('/')
    if message[0] == 'docked' and message[1] == 'success':
        docked = True
        rospy.signal_shutdown("Done")


if __name__ == '__main__':
    try:
	away_pos = [-0.536414086819, 0.492057323456, 0.992841611677, 0.119438411419]
	home_pos = [-5.86358213425, 2.0202703476, 0.999910191108, -0.0134018550249]

        rospy.init_node('simple_move', log_level=rospy.INFO)
	if sys.argv[1] == 'home':	
            result = simple_move(home_pos)
            if result == actionlib.GoalStatus.SUCCEEDED:
	        rospy.loginfo('Goal successfully reached!')
                # sendGoalEvent(True, "goal successfully reached!")
                goalReached("success")
            else:
                rospy.loginfo('Something went wrong')
	        rospy.loginfo(sac.get_state())
                # sendGoalEvent(False, "Something went wrong")
                goalReached("fail")
	elif sys.argv[1] == 'away':
	    result = simple_move(away_pos)
        elif sys.argv[1] == 'debug':
            goalReached("success")
	else:
	    print 'use home or away'
	
    except rospy.ROSInterruptException:
        print "Keyboard Interrupt"
