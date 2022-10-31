current_dir=`pwd`

files_to_link=(
.config/nvim
.config/vifm
.gitconfig
.gitignore_global
.tmux.conf
.zshrc
)

for link_file in "${files_to_link[@]}"
do
    ln -s "$current_dir/$link_file" ~/$link_file && echo "Created symlink '~/$link_file'"
done
