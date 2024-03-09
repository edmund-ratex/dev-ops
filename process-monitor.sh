#!/bin/bash

# Define variables
base_java_dir="/data/ratey/dc/"
label_metricName="process"
label_metricOwner="java"
label_metricGroup="process_monitor"
prom_txt_file="/data/monitor/node_text_collected/process_monitor.prom"

# Function to check if a process is running
is_process_running() {
    pgrep -f "$1" >/dev/null
}

# Function to write metric to the prom_txt_file
write_metric() {
    local process_name="$1"
    local is_running="$2"

    echo "${label_metricName}{process_owner=\"${label_metricOwner}\",exporter_group=\"${label_metricGroup}\",process_name=\"${process_name}\"} ${is_running}" >>"$prom_txt_file"
}

# Clear the prom_txt_file
> "$prom_txt_file"

# Loop through all directories in base_java_dir
for i in "${base_java_dir}"/*; do
    if is_process_running "$i"; then
        write_metric "$i" 1
    else
        write_metric "$i" 0
    fi
done

