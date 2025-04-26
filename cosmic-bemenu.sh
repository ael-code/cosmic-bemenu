#!/usr/bin/env bash

# Extract float for a key (red, green, blue)
extract_float() {
  local file="$1"
  local key="$2"
  grep -Po "${key}:\\s*\\K[0-9.]+(?=,)" "$file"
}

# Convert float (0–1) to two-digit hex (00–FF)
float_to_hex() {
  local f="${1:-1}"
  local dec=$(awk -v f="$f" 'BEGIN { printf "%d", int(f * 255 + 0.5) }')
  printf '%02X' "$dec"
}

extract_hex_colors() {
  local file="$1"
  r_hex=$(float_to_hex "$(extract_float $file red)")
  g_hex=$(float_to_hex "$(extract_float $file green)")
  b_hex=$(float_to_hex "$(extract_float $file blue)")
  a_hex=$(float_to_hex "$(extract_float $file alpha)")

  # Output full hex code
  printf "#${r_hex}${g_hex}${b_hex}${a_hex}"
}

THEME_FOLDER=$HOME/.config/cosmic/com.system76.CosmicTheme.Dark.Builder/v1
accent_color=$(extract_hex_colors $THEME_FOLDER/accent)
bg_color=$(extract_hex_colors $THEME_FOLDER/bg_color)
text_tint_color=$(extract_hex_colors $THEME_FOLDER/text_tint)
neutral_tint_color=$(extract_hex_colors $THEME_FOLDER/neutral_tint)

bemenu_colors=(
  "--nb ${bg_color}"		# Normal background
  "--ff ${text_tint_color}"	# Filter foreground
  "--tf ${neutral_tint_color}"	# Text foreground
  "--hf ${accent_color}" 	# Highlighted foreground
  "--sf ${accent_color}" 	# Selected foreground
  "--bdr ${accent_color}" # Border color
)

bemenu_options=(
  "--no-overlap"
  "--border 1"
  "--line-height 25"
  "--hp 5"  		# Horizontal padding between entries
  "--cw 2"		# Width of the cursor
  "--ch 17"		# Height of the cursor
)

DEFAULT_BEMENU_OPTS="${bemenu_options[@]} ${bemenu_colors[@]}"
export BEMENU_OPTS=${BEMENU_OPTS:-$DEFAULT_BEMENU_OPTS}

# run bemenu
bemenu "$@"
