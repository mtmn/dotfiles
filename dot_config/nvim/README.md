To recompile `fnl` files into `lua` I use this shell function:

```bash
nvimrecomp() {
	nvim_config_path_path="$HOME/.config/nvim"

	mkdir -p "$nvim_config_path"/lua/config

	find "$nvim_config_path/fnl" -type f -name "*.fnl" | while read -r fnl_file; do
		rel_path="${fnl_file#"$nvim_config_path"/fnl/}"

		if [ "$rel_path" = "init.fnl" ]; then
			lua_file="$nvim_config_path/init.lua"
		else
			lua_file="$nvim_config_path/lua/${rel_path%.fnl}.lua"
		fi

		fennel --compile "$fnl_file" | tee "$lua_file" > /dev/null
		echo "$lua_file recompiled"
	done
}
```
