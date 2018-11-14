[ > ports.json
for f in /home/*;
    do {
        user=${f##*/}
        sudo -nu ${user} /usr/bin/find /home/${user}/.local/share/jupyter/runtime -name "*.json" -exec cat {} \; >> ports.json
        , >> ports.json
    }
] >> ports.json
done