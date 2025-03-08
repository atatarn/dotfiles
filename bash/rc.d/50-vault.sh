
vault-init() {
	echo "Open your Vault, grab the token (usually by clicking on the Profile icon -> Copy token)";
	read -s -p "Paste token here: " VTOKEN;

	if [ -z ${VTOKEN:-} ]; then
		echo "Empty token";
		exit -1;
	else
		export VAULT_TOKEN=$VTOKEN;
		echo "";
		echo "Vault Token ready";
	fi
}

