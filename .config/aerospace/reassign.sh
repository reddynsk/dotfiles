#!/bin/bash
# Reassign all windows to their rule workspaces
declare -A MAP=(
  ["com.brave.Browser"]=1
  ["company.thebrowser.Browser"]=1
  ["app.zen-browser.zen"]=1
  ["com.mitchellh.ghostty"]=2
  ["com.github.wez.wezterm"]=2
  ["com.todesktop.230313mzl4w4u92"]=3
  ["com.microsoft.VSCodeInsiders"]=3
  ["com.microsoft.VSCode"]=3
  ["com.google.antigravity"]=3
  ["md.obsidian"]=4
  ["notion.id"]=4
  ["com.anthropic.claudefordesktop"]=4
  ["com.tinyspeck.slackmacgap"]=5
  ["com.hnc.Discord"]=5
  ["net.whatsapp.WhatsApp"]=5
  ["com.spotify.client"]=6
  ["com.adobe.PremierePro.24"]=6
  ["com.netsoft.Hubstaff"]=7
)

for app in "${!MAP[@]}"; do
  ws="${MAP[$app]}"
  ids=$(aerospace list-windows --monitor all --app-bundle-id "$app" --format "%{window-id}" 2>/dev/null)
  for id in $ids; do
    aerospace move-node-to-workspace --window-id "$id" "$ws" 2>/dev/null
  done
done

echo "Reassigned:"
aerospace list-windows --monitor all --format "ws%{workspace} %{app-name}" | sort
