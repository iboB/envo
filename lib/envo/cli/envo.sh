envo() {
  local tmpfile=$(envo_run g)
  envo_run pld "${tmpfile}" "$@"
  source "${tmpfile}"
  rm "${tmpfile}"
}
