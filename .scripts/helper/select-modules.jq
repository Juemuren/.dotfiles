# Input lines are <module><tab><JSON include array>.
# - $selected is MISE_ENV
# - $available is modules.txt

def nonempty_lines:
  split("\n")
  | map(rtrimstr("\r")
  | select(length > 0));

def module_from_config_path:
  split("/")[-1]
  | ltrimstr("config.")
  | rtrimstr(".toml");

def dependencies($selected_modules):
  [ nonempty_lines[]
    | split("\t") as [$module, $includes_json]
    | select($selected_modules | index($module))
    | $includes_json
    | fromjson[]
    | module_from_config_path
  ] | unique;

def in_order($names; $available_modules):
  $available_modules[]
  | select(
    . as $module
    | $names
    | index($module)
  );

($available | nonempty_lines) as $available_modules
| (
  $selected
  | split(",")
  | map(select(length > 0))
  | unique
) as $selected_modules
| dependencies($selected_modules) as $dependency_modules
| ($selected_modules - $available_modules) as $unknown
| if $unknown != [] then
    error("unknown modules: " + ($unknown | join(", ")))
  else
    in_order($dependency_modules; $available_modules),
    in_order($selected_modules - $dependency_modules; $available_modules)
  end
