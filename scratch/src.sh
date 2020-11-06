envy() {
  local output=$(ruby bin/envy_run fwd "$@")
  eval "${output}"
}
