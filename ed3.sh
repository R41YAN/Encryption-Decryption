
# ------------------------
# Colors & UI
# ------------------------
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[36m"
BOLD="\e[1m"
NC="\e[0m" # reset

banner() {
    echo -e "${BLUE}${BOLD}==============================================${NC}"
    echo -e "${BLUE}${BOLD}  Text & File Encryption · Metadata · Hashing ${NC}"
    echo -e "${BLUE}${BOLD}==============================================${NC}"
}

prompt_confirm_overwrite() {
    local file="$1"
    if [[ -e "$file" ]]; then
        read -p "$(echo -e "${YELLOW}File '$file' exists. Overwrite? [y/N]: ${NC}")" ans
        case "$ans" in
            [Yy]*) return 0 ;;
            *) return 1 ;;
        esac
    else
        return 0
    fi
}

require_file_exists() {
    local f="$1"
    if [[ ! -f "$f" ]]; then
        echo -e "${RED}  File not found: $f${NC}"
        return 1
    fi
    return 0
}

# ------------------------
# Utility: List files
# ------------------------
list_files() {
    echo -e "${GREEN}Files in $(pwd):${NC}"
    ls -1 --color=auto
}

# ------------------------
# Caesar Cipher (text & file)
# ------------------------
caesar_encrypt() {
    echo -n "Enter text to encrypt: "
    read -r text
    echo -n "Enter key (number): "
    read -r key
    encrypted=""
    for (( i=0; i<${#text}; i++ )); do
        char=${text:$i:1}
        ascii=$(printf "%d" "'$char")
        if [[ $ascii -ge 65 && $ascii -le 90 ]]; then
            ascii=$(( (ascii - 65 + key) % 26 + 65 ))
        elif [[ $ascii -ge 97 && $ascii -le 122 ]]; then
            ascii=$(( (ascii - 97 + key) % 26 + 97 ))
        fi
        encrypted+=$(printf "\\$(printf '%03o' "$ascii")")
    done
    echo -e "${GREEN}Encrypted text:${NC} $encrypted"
}

caesar_decrypt() {
    echo -n "Enter text to decrypt: "
    read -r text
    echo -n "Enter key (number): "
    read -r key
    decrypted=""
    for (( i=0; i<${#text}; i++ )); do
        char=${text:$i:1}
        ascii=$(printf "%d" "'$char")
        if [[ $ascii -ge 65 && $ascii -le 90 ]]; then
            ascii=$(( (ascii - 65 - key + 26) % 26 + 65 ))
        elif [[ $ascii -ge 97 && $ascii -le 122 ]]; then
            ascii=$(( (ascii - 97 - key + 26) % 26 + 97 ))
        fi
        decrypted+=$(printf "\\$(printf '%03o' "$ascii")")
    done
    echo -e "${GREEN}Decrypted text:${NC} $decrypted"
}

caesar_encrypt_file() {
    echo -n "Enter input file: "
    read -r in
    require_file_exists "$in" || return
    echo -n "Enter output file: "
    read -r out
    prompt_confirm_overwrite "$out" || { echo "Cancelled."; return; }
    echo -n "Enter key (number): "
    read -r key
    > "$out"
    while IFS= read -r line; do
        encrypted=""
        for (( i=0; i<${#line}; i++ )); do
            char=${line:$i:1}
            ascii=$(printf "%d" "'$char")
            if [[ $ascii -ge 65 && $ascii -le 90 ]]; then
                ascii=$(( (ascii - 65 + key) % 26 + 65 ))
            elif [[ $ascii -ge 97 && $ascii -le 122 ]]; then
                ascii=$(( (ascii - 97 + key) % 26 + 97 ))
            fi
            encrypted+=$(printf "\\$(printf '%03o' "$ascii")")
        done
        echo "$encrypted" >> "$out"
    done < "$in"
    echo -e "${GREEN}File encrypted → $out${NC}"
}

caesar_decrypt_file() {
    echo -n "Enter input file: "
    read -r in
    require_file_exists "$in" || return
    echo -n "Enter output file: "
    read -r out
    prompt_confirm_overwrite "$out" || { echo "Cancelled."; return; }
    echo -n "Enter key (number): "
    read -r key
    > "$out"
    while IFS= read -r line; do
        decrypted=""
        for (( i=0; i<${#line}; i++ )); do
            char=${line:$i:1}
            ascii=$(printf "%d" "'$char")
            if [[ $ascii -ge 65 && $ascii -le 90 ]]; then
                ascii=$(( (ascii - 65 - key + 26) % 26 + 65 ))
            elif [[ $ascii -ge 97 && $ascii -le 122 ]]; then
                ascii=$(( (ascii - 97 - key + 26) % 26 + 97 ))
            fi
            decrypted+=$(printf "\\$(printf '%03o' "$ascii")")
        done
        echo "$decrypted" >> "$out"
    done < "$in"
    echo -e "${GREEN}File decrypted → $out${NC}"
}

# ------------------------
# ROT13 (text & file)
# ------------------------
rot13_text() {
    echo -n "Enter text: "
    read -r text
    result=$(echo "$text" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
    echo -e "${GREEN}ROT13 result:${NC} $result"
}

rot13_file() {
    echo -n "Enter input file: "
    read -r in
    require_file_exists "$in" || return
    echo -n "Enter output file: "
    read -r out
    prompt_confirm_overwrite "$out" || { echo "Cancelled."; return; }
    tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$in" > "$out"
    echo -e "${GREEN}ROT13 file written → $out${NC}"
}

# ------------------------
# Base64 (text & file)
# ------------------------
base64_encrypt() {
    echo -n "Enter text: "
    read -r text
    echo -e "${GREEN}Base64 encoded:${NC} $(echo -n "$text" | base64)"
}

base64_decrypt() {
    echo -n "Enter Base64 text: "
    read -r text
    echo -e "${GREEN}Decoded text:${NC} $(echo -n "$text" | base64 --decode 2>/dev/null || echo -e "${RED}Invalid base64 or decode error${NC}")"
}

base64_encrypt_file() {
    echo -n "Enter input file: "
    read -r in
    require_file_exists "$in" || return
    echo -n "Enter output file: "
    read -r out
    prompt_confirm_overwrite "$out" || { echo "Cancelled."; return; }
    base64 "$in" > "$out"
    echo -e "${GREEN}Base64 encoded → $out${NC}"
}

base64_decrypt_file() {
    echo -n "Enter Base64 encoded file: "
    read -r in
    require_file_exists "$in" || return
    echo -n "Enter output file: "
    read -r out
    prompt_confirm_overwrite "$out" || { echo "Cancelled."; return; }
    base64 --decode "$in" > "$out" 2>/dev/null || { echo -e "${RED}Decode failed - invalid input${NC}"; return; }
    echo -e "${GREEN}Base64 decoded → $out${NC}"
}

# ------------------------
# MD5 Hashing (text & file)
# ------------------------
#md5_text() {
 #   echo -n "Enter text: "
  #  read -r text
   # echo -n "$text" | md5sum | awk '{print $1}' | xargs -I{} echo -e "${GREEN}MD5:${NC} {}"
#}

#md5_file() {
#    echo -n "Enter filename: "
#    read -r file
#    require_file_exists "$file" || return
#    md5sum "$file" | awk '{print $1}' | xargs -I{} echo -e "${GREEN}MD5:${NC} {}"
#}

# ------------------------
# AES-256 file encryption/decryption (openssl)
# ------------------------
aes_encrypt_file() {
    echo -n "Enter input file: "
    read -r in
    require_file_exists "$in" || return
    echo -n "Enter output file (encrypted): "
    read -r out
    prompt_confirm_overwrite "$out" || { echo "Cancelled."; return; }
    # get password without echo
    read -s -p "Enter password for encryption: " pass; echo
    read -s -p "Confirm password: " pass2; echo
    [[ "$pass" == "$pass2" ]] || { echo -e "${RED}Passwords do not match.${NC}"; return; }
    # encrypt with AES-256-CBC using PBKDF2
    openssl enc -aes-256-cbc -pbkdf2 -salt -in "$in" -out "$out" -pass pass:"$pass"
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}AES encryption successful → $out${NC}"
    else
        echo -e "${RED}Encryption failed${NC}"
    fi
}

aes_decrypt_file() {
    echo -n "Enter encrypted input file: "
    read -r in
    require_file_exists "$in" || return
    echo -n "Enter output file (decrypted): "
    read -r out
    prompt_confirm_overwrite "$out" || { echo "Cancelled."; return; }
    read -s -p "Enter password to decrypt: " pass; echo
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$in" -out "$out" -pass pass:"$pass" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}AES decryption successful → $out${NC}"
    else
        echo -e "${RED}Decryption failed (wrong password or corrupted file)${NC}"
        rm -f "$out" 2>/dev/null
    fi
}

# ------------------------
# ExifTool metadata (view & export)
# ------------------------
exif_view() {
    echo -n "Enter file name: "
    read -r file
    require_file_exists "$file" || return
    exiftool "$file"
}

exif_export() {
    echo -n "Enter file name: "
    read -r file
    require_file_exists "$file" || return
    echo -n "Enter output metadata file (txt): "
    read -r out
    prompt_confirm_overwrite "$out" || { echo "Cancelled."; return; }
    exiftool "$file" > "$out"
    echo -e "${GREEN}Metadata exported to $out${NC}"
}

# ------------------------
# Main UI Loop
# ------------------------
while true; do
    banner
    echo -e "${BOLD}Main Menu:${NC}"
    echo -e "  ${YELLOW}1)${NC} Caesar Cipher"
    echo -e "  ${YELLOW}2)${NC} ROT13"
    echo -e "  ${YELLOW}3)${NC} Base64"
    #echo -e "  ${YELLOW}4)${NC} MD5 Hashing"
    echo -e "  ${YELLOW}4)${NC} AES-256 File Encrypt/Decrypt"
    echo -e "  ${YELLOW}5)${NC} Metadata Tools (ExifTool)"
    echo -e "  ${YELLOW}6)${NC} File Listing"
    echo -e "  ${YELLOW}7)${NC} Exit"
    echo
    read -p "$(echo -e "${BLUE}Choose an option:${NC} ")" choice
    case $choice in
        1)
            echo -e "${BOLD}-- Caesar Cipher --${NC}"
            echo "  1) Encrypt Text"
            echo "  2) Decrypt Text"
            echo "  3) Encrypt File"
            echo "  4) Decrypt File"
            read -p "Choice: " c
            case $c in
                1) caesar_encrypt ;;
                2) caesar_decrypt ;;
                3) caesar_encrypt_file ;;
                4) caesar_decrypt_file ;;
                *) echo -e "${RED}Invalid.${NC}" ;;
            esac
            ;;
        2)
            echo -e "${BOLD}-- ROT13 --${NC}"
            echo "  1) Text"
            echo "  2) File"
            read -p "Choice: " c
            case $c in
                1) rot13_text ;;
                2) rot13_file ;;
                *) echo -e "${RED}Invalid.${NC}" ;;
            esac
            ;;
        3)
            echo -e "${BOLD}-- Base64 --${NC}"
            echo "  1) Encode Text"
            echo "  2) Decode Text"
            echo "  3) Encode File"
            echo "  4) Decode File"
            read -p "Choice: " c
            case $c in
                1) base64_encrypt ;;
                2) base64_decrypt ;;
                3) base64_encrypt_file ;;
                4) base64_decrypt_file ;;
                *) echo -e "${RED}Invalid.${NC}" ;;
            esac
            ;;
        #4)
          #  echo -e "${BOLD}-- MD5 Hashing --${NC}"
            #echo "  1) MD5 of Text"
           # echo "  2) MD5 of File"
            #read -p "Choice: " c
            #case $c in
             #   1) md5_text ;;
              #  2) md5_file ;;
              # *) echo -e "${RED}Invalid.${NC}" ;;
            #esac
            #;;
        4)
            echo -e "${BOLD}-- AES-256 File Encryption --${NC}"
            echo "  1) Encrypt File (AES-256-CBC)"
            echo "  2) Decrypt File (AES-256-CBC)"
            read -p "Choice: " c
            case $c in
                1) aes_encrypt_file ;;
                2) aes_decrypt_file ;;
               *) echo -e "${RED}Invalid.${NC}" ;;
            esac
            ;;
        5)
            echo -e "${BOLD}-- Metadata Tools (ExifTool) --${NC}"
            echo "  1) View Metadata"
            echo "  2) Export Metadata to File"
            read -p "Choice: " m
            case $m in
                1) exif_view ;;
                2) exif_export ;;
                *) echo -e "${RED}Invalid.${NC}" ;;
            esac
            ;;
        6)
            list_files
            ;;
        7)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Try again.${NC}" ;;
    esac
    echo
    read -p "$(echo -e "${YELLOW}Press Enter to continue...${NC}")"
done
