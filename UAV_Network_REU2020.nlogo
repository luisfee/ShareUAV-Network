
breed[actors actor]
breed[attackers attacker]
globals[id msg]
breed[sinks sink]
links-own[distance-ag]
actors-own[
sender_id
message_send
message
my_id
message-sum
my-list
]

to setup
 clear-all
  reset-ticks

  create-sinks 1;
  [
     setxy xcor ycor ;
  ]

  create-actors NumActors ;
  [

    setxy random-xcor random-ycor 

    create-link-to one-of sinks
  ]
  create-attackers 1 [
      setxy random-xcor random-ycor 
  ]

  ask sinks
  [
    set shape "airplane"
    set size 10
    set color red
    set label "sink"
  ]

   ask actors
  [
    set shape "default"
    set size 10
    set color yellow
    set label who
    set my-list []
  ]

  ask attackers [
  set shape "default"
  set size 10
  set color red
  set label "Attacker"

  ]

  ask turtles[
    if any? links[

        layout-spring turtles links 0.1 5 1]]


  ask actors [

  layout-spring actors no-links 0.1 .5 10
  ]

end



to go
  ask attackers[
    face actor 1
  ]
ask turtles[
    if any? links[

        layout-spring turtles links 0.1 5 1]]


  ask actors [
  layout-spring actors no-links 0.1 .5 10
  ]

  ask attackers [
     repeat 5 [ fd 0 wait 0.5 ]
    forward 10
    face actor 1]

  ask one-of actors[
ifelse label = "traitor"[
       set color red
    ]
    [
 set color white
  set label "receiver"
  ask other actors in-radius 20[
     ifelse label = "traitor"[
        set color red]
        [
    set color blue
          set id who]
    ]
    set my-list fput id my-list
    print my-list
    ]
    ]
ask actors with [color = blue] [
    set label who
    set message  ( (random 2) + 1)
    print " Message sent"
    set my-list []
   ask actors with [color = white] [
  repeat 1 [ fd 0 wait 0.5 ]
   message-action
    repeat 1 [ fd 0 wait 0.5 ]
      set msg 0
      set message 0
  ]
  ]

  ask attackers [
    if any? turtles in-radius 5[
     left 60 forward 3
    ]
    wander
    face actor 1
    repeat 5 [ fd 0 wait 0.5 ]

    ask  actor 1 [
      ifelse label = "traitor" [
      wander]
      [
    set color yellow
    set label "receiver"
    repeat 5 [ fd 0 wait 0.5 ]
      ]
    ]
  ]
  ask actors with [label = "receiver"] [
    if empty? my-list [
      ask my-links[set color red]
      set label "traitor"
    ]
  ]
  ask sinks[
    ask my-links with[ color = red ] [die]
  ]
  ask actors with [label = "traitor"] [ wander]

end

to wander
  fd random 5
  rt (random 30) - 20
end

to message-action
  set message-sum ((sum [message] of actors with [color = blue]))
    show message-sum
  if message-sum <  5[ ask actors with [color = white]  [ set color pink]]
  if message-sum >= 5 [ ask actors with [color = white][ set color violet]]
end


