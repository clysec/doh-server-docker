#!/bin/sh

CMD_ARGS=""

# Loop through all environment variables and set corresponding command-line arguments
for var in $(printenv | grep '^DOHS_' | cut -d= -f1); do
    value=$(printenv "$var")
    arg_name=$(echo "$var" | tr 'A-Z_' 'a-z-')
    
    case "$arg_name" in
        dohs-disable-tls|dohs-allow-odoh-post|dohs-disable-keepalive|dohs-disable-post|dohs-enable-ecs)
            if [ "$value" = "true" ] || [ "$value" = "1" ]; then
                CMD_ARGS="$CMD_ARGS --${arg_name#dohs-}"
            fi
            ;;
        *)
            if [ -n "$value" ]; then
                CMD_ARGS="$CMD_ARGS --${arg_name#dohs-} $value"
            fi
            ;;
    esac
done

echo "Starting doh-proxy with arguments: $CMD_ARGS"

doh-proxy $CMD_ARGS