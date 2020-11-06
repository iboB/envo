envy() {
  local output=$(ruby scratch.rb $@)
  eval "${output}"
}
