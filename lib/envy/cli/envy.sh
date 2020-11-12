envy() {
  local tmpfile=$(./bin/envy_run g)
  ./bin/envy_run pld "${tmpfile}" "$@"
  source "${tmpfile}"
  rm "${tmpfile}"
}
