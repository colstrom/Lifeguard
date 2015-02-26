# Lifeguard
Lifeguard allows you to revive threads that have exited. Threads monitoring for Ruby!


Example of usage: 
l = Lifeguard.new(
  lambda { 3.times do sleep(1); p '0th lambda' end },
  lambda { 6.times do sleep(1); p '1st lambda' end },
  lambda { 8.times do sleep(1); p '2nd lambda' end },
  )

l.monitor
