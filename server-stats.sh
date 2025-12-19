#!/usr/bin/env bash

main(){

  boot_time=$(date -d "$(uptime -s)" +"%d-%m-%Y %H:%M")
  uptime=$(uptime -p | awk '{print $2"h" " " $4 "min" }')
  cpu_usage=$(top -bn2 -d 0.01 | grep '^%Cpu' | tail -n 1 | awk '{print $2+$4+$6}')   
  load_avg=$(cat /proc/loadavg | awk '{print $1 " " $2 " " $3}')
  memory_usage=$(free -m | awk '/^Mem:/ {print ($3 / $2) * 100}')
  storage_usage=$( df | awk ' NR==3{print $3 / $2 *100}')
  
  awk -v boot="$boot_time" \
      -v uptime="$uptime" \
      -v cpu="$cpu_usage" \
      -v load_avg="$load_avg" \
      -v mem="$memory_usage" \
      -v disk="$storage_usage" '
  BEGIN {
      print "+----------------------------------------+"
      print "|       SERVER PERFORMANCE STATS         |"
      print "+----------------------------------------+"
      printf "| Boot time: | %-23s   |\n", boot
      print "+----------------------------------------+"
      printf "| Uptime:    | %-23s   |\n", uptime
      print "+----------------------------------------+"
      printf "| CPU usage: | %-23s   |\n", cpu "%"
      print "+----------------------------------------+"
      printf "| Load avg:  | %-23s   |\n", load_avg
      print "+----------------------------------------+"
      printf "| RAM usage: | %-23s   |\n", mem "%"
      print "+----------------------------------------+"
      printf "| Storage:   | %-23s   |\n", disk "%"
      print "+----------------------------------------+"
  }'
  echo

  ps -eo pid,comm,%cpu --sort=-%cpu --no-headers |
  head -n 5 |
  awk '
  BEGIN {
    line="+--------+----------------------+--------+"
    print "+----------------------------------------+"
    print "|           TOP 5 CPU eaters:            |"
    print line
    printf "| %-5s  | %-20s | %6s |\n", "PID", "PROCESS", "CPU %"
    print line
  }
  {
    printf "| %-6d | %-20s | %6.2f |\n", $1, $2, $3
  }
  END {
    print line
  }'

  echo

  ps -eo pid,comm,%mem --sort=-%mem --no-headers |
  head -n 5 |
  awk '
  BEGIN {
    line="+--------+----------------------+--------+"
    print "+----------------------------------------+"
    print "|           TOP 5 RAM eaters:            |"
    print line
    printf "| %-5s  | %-20s | %6s |\n", "PID", "PROCESS", "MEM %"
    print line
  }
  {
    printf "| %-6d | %-20s | %6.2f |\n", $1, $2, $3
  }
  END {
    print line
  }'

}

main




