
# Lazy-load RVM. Sourcing rvm here forks dozens of subprocesses on every login;
# with this machine's ~260ms-per-exec security-agent tax that alone costs ~12-15s.
# Instead load rvm on first use of a Ruby command — paid once per session, and
# only if you touch native Ruby (day-to-day work runs in Docker).
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  __rvm_lazy() {
    unfunction rvm ruby gem bundle bundler rake irb rails ri rdoc 2>/dev/null
    source "$HOME/.rvm/scripts/rvm"
    rehash
  }
  for __cmd in rvm ruby gem bundle bundler rake irb rails ri rdoc; do
    eval "${__cmd}() { __rvm_lazy; ${__cmd} \"\$@\"; }"
  done
  unset __cmd
fi
