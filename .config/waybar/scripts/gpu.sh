#!/bin/bash
value=$(cat /sys/class/hwmon/hwmon2/device/gpu_busy_percent)
if [ $value -ge 80 ]; then
    class="critical"
elif [ $value -ge 50 ]; then
    class="high"
elif [ $value -ge 30 ]; then
    class="elevated"
fi
echo "{\"percentage\": $value, \"class\": \"$class\"}"