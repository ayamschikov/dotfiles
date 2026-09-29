current_dir=$(pwd)

files_to_link=(
  .config/nvim
  .config/vifm
  .config/lazy_vim
  .gitconfig
  .gitignore_global
  .tmux.conf
  .tmux/claude.conf
  .zshrc
)

for link_file in "${files_to_link[@]}"; do
  mkdir -p "$(dirname ~/$link_file)"
  ln -s "$current_dir/$link_file" ~/$link_file && echo "Created symlink '~/$link_file'"
done
