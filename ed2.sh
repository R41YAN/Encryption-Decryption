#!/bin/bash

# ============================
# Caesar Cipher (text)
# ============================
caesar_encrypt() {
    echo "Enter text to encrypt:"
    read text
    echo "Enter key:"
    read key
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
    echo "Encrypted text: $encrypted"
}

caesar_decrypt() {
    echo "Enter text to decrypt:"
    read text
    echo "Enter key:"
    read key
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
    echo "Decrypted text: $decrypted"
}

# ============================
# Caesar Cipher (file)
# ============================
caesar_encrypt_file() {
    echo "Enter input file:"
    read in
    echo "Enter output file:"
    read out
    echo "Enter key:"
    read key
    
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
    
    echo "File encrypted → $out"
}

caesar_decrypt_file() {
    echo "Enter input file:"
    read in
    echo "Enter output file:"
    read out
    echo "Enter key:"
    read key
    
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
    
    echo "File decrypted → $out"
}

# ============================
# ROT13
# ============================
rot13_text() {
    echo "Enter text:"
    read text
    echo "ROT13 result: $(echo "$text" | tr 'A-Za-z' 'N-ZA-Mn-za-m')"
}

rot13_file() {
    echo "Enter input file:"
    read in
    echo "Enter output file:"
    read out
    tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$in" > "$out"
    echo "ROT13 file written → $out"
}

# ============================
# Base64
# ============================
base64_encrypt() {
    echo "Enter text:"
    read text
    echo "Base64 encoded: $(echo "$text" | base64)"
}

base64_decrypt() {
    echo "Enter Base64 text:"
    read text
    echo "Decoded text: $(echo "$text" | base64 --decode)"
}

base64_encrypt_file() {
    echo "Enter input file:"
    read in
    echo "Enter output file:"
    read out
    base64 "$in" > "$out"
    echo "Base64 encoded → $out"
}

base64_decrypt_file() {
    echo "Enter Base64 encoded file:"
    read in
    echo "Enter output file:"
    read out
    base64 --decode "$in" > "$out"
    echo "Base64 decoded → $out"
}

# ============================
# ExifTool (metadata)
# ============================
exif_view() {
    read -p "Enter file name: " file
    if [[ -f "$file" ]]; then
        exiftool "$file"
    else
        echo "❌ File not found!"
    fi
}

exif_export() {
    read -p "Enter file name: " file
    read -p "Enter output file: " out
    if [[ -f "$file" ]]; then
        exiftool "$file" > "$out"
        echo "✔ Metadata exported to $out"
    else
        echo "❌ File not found!"
    fi
}


# ============================
# MAIN MENU
# ============================
while true; do
    echo "----------------------------------------"
    echo " TEXT ENCRYPTION & DECRYPTION TOOL"
    echo "----------------------------------------"
    echo "1. Caesar Cipher"
    echo "2. ROT13 Cipher"
    echo "3. Base64 Encode/Decode"
    echo "4. Metadata Tools (ExifTool)"
    echo "5. Exit"
    echo "----------------------------------------"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "--- Caesar Cipher ---"
            echo "1. Encrypt Text"
            echo "2. Decrypt Text"
            echo "3. Encrypt File"
            echo "4. Decrypt File"
            read -p "Choice: " c
            case $c in
                1) caesar_encrypt ;;
                2) caesar_decrypt ;;
                3) caesar_encrypt_file ;;
                4) caesar_decrypt_file ;;
            esac
            ;;
        2)
            echo "--- ROT13 Cipher ---"
            echo "1. Encrypt/Decrypt Text"
            echo "2. Encrypt/Decrypt File"
            read -p "Choice: " c
            case $c in
                1) rot13_text ;;
                2) rot13_file ;;
            esac
            ;;
        3)
            echo "--- Base64 ---"
            echo "1. Encode Text"
            echo "2. Decode Text"
            echo "3. Encode File"
            echo "4. Decode File"
            read -p "Choice: " c
            case $c in
                1) base64_encrypt ;;
                2) base64_decrypt ;;
                3) base64_encrypt_file ;;
                4) base64_decrypt_file ;;
            esac
            ;;
        4)
    echo "--- Metadata Tools (ExifTool) ---"
    echo "1. View Metadata"
    echo "2. Export Metadata to File"
    read -p "Choice: " m
    case $m in
        1) exif_view ;;
        2) exif_export ;;
    esac
    ;;

        5)
            echo "Goodbye!"
            exit ;;
        *)
            echo "Invalid choice!" ;;
    esac
    echo
done
