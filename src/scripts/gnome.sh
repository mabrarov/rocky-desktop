#!/bin/bash -eux

echo '==> GNOME window title bar tuning'

user_home_dir="/home/${GNOME_USER}"
user_config_dir="${user_home_dir}/.config"
gtk_user_config_dir="${user_config_dir}/gtk-3.0"

mkdir -p "${gtk_user_config_dir}"

chown "${GNOME_USER}:${GNOME_USER}" "${user_home_dir}"
chmod u=rwX,g=,o= "${user_home_dir}"

chown "${GNOME_USER}:${GNOME_USER}" "${user_config_dir}"
chmod u=rwX,g=,o= "${user_config_dir}"

cat << EOF > "${gtk_user_config_dir}/gtk.css"
/* https://gist.github.com/jamesridgway/2f123c4d6262ad13d1aa5120f6063098 */
/* https://www.reddit.com/r/gnome/comments/y61xhm/is_there_a_way_to_reduce_title_bar_height_of_apps/ */
/* https://stackoverflow.com/questions/48030687/how-to-theme-style-the-title-bar-in-gnome-3 */

window.ssd headerbar.titlebar {
    padding: 4px;
    min-height: 28px;
}

window.ssd headerbar.titlebar button.titlebutton {
    min-height: 26px;
    min-width: 26px;
}
EOF

chown "${GNOME_USER}:${GNOME_USER}" -R "${gtk_user_config_dir}"
chmod u=rwX,g=rX,o=rX -R "${gtk_user_config_dir}"
