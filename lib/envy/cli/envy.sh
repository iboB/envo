envy() {
  local tmpfile=$(envy_run g)
  envy_run pld "${tmpfile}" "$@"
  source "${tmpfile}"
  rm "${tmpfile}"
}
