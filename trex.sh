#!/bin/bash
default_latency=0
default_jitter=0
default_loss=0

while true; do
    coba="$(sudo tc qdisc show dev enp0s3)"
    if [[ $coba == *netem* ]]; then
        sudo tc qdisc del dev enp0s3 root
    fi
    PS3='Please enter your choice: '
    options=("Delay" "Loss" "Init" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Delay")
                read -p "Enter latency (default: $default_latency): " latency
                latency=${latency:-$default_latency}
                read -p "Enter jitter (default: $default_jitter): " jitter
                jitter=${jitter:-$default_jitter}
                sudo tc qdisc add dev enp0s3 root netem delay "${latency}ms" "${jitter}ms" 
                ;;
            "Loss")
                read -p "Enter loss (% - default: $default_loss): " loss
                loss=${loss:-$default_loss}
                sudo tc qdisc add dev enp0s3 root netem loss "${loss}%"
                ;;
            "Init")
                init="$(sudo tc qdisc show dev enp0s3)"
                if [[ $init == *netem* ]]; then
                    sudo tc qdisc del dev enp0s3 root
                fi
                break
                ;;
            "Quit")
                exit 0
                ;;
            *) echo "invalid option $REPLY";;
        esac
        exit 0
    done
done

