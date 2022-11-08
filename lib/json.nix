pkgs: {
  # Merge the data as json at path, meant for usage with home-manager activation scripts
  mergeJson = path: json: ''
    DIRNAME=$(dirname ${path})
    mkdir -p $DIRNAME
    if [ ! -f ${path} ]
    then
        echo "{}" > ${path}
    fi

    # Store it as a variable to avoid race condition
    UPDATED_JSON=$(jq -s 'reduce .[] as $item ({}; . * $item)' ${path} ${pkgs.writeText "updated.json" (builtins.toJSON json)})
    echo "$UPDATED_JSON" > ${path}
  '';
}
