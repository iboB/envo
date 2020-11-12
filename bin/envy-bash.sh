envy() {
  local tmpfile=$(ruby bin/envy_run g)
  ruby bin/envy_run pld "${tmpfile}" "$@"
  source "${tmpfile}"
  rm "${tmpfile}"
}
