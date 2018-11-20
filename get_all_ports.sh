# TODO: track only active users 
# TODO: use jupyter_runtime_dir as the path in case it is changed
echo "[" > ports.json
for f in /home/*; do
    user=${f##*/}
    sudo -nu ${user} /usr/bin/find /home/${user}/.local/share/jupyter/runtime -name "*.json" | while read filename; do
        sudo -nu ${user} cat ${filename} >> ports.json
        echo "," >> ports.json
    done
done
truncate -s-2 ports.json
echo "]" >> ports.json