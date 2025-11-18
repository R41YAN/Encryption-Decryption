
# 🔐 Linux Encryption & Metadata Toolkit

### *A Bash-based Security Utility for Text, Files, Hashing & Metadata Operations*

**Author:** MD Raiyan
**University:** University of Information Technology and Sciences (UITS)
**Course:** Linux Programming Lab (2025)
**Instructor:** Md. Tasnin Tanvir — Lecturer, UITS
B.Sc in CSE, Khulna University of Engineering & Technology (KUET)

---

## 📌 Overview

This project is a **multi-purpose Linux command-line toolkit** developed as part of the *Linux Programming Lab* course.
It provides essential security and utility tools including:

* Caesar Cipher (text + file)
* ROT13 encoding/decoding
* Base64 encoding/decoding
* AES-256-CBC file encryption/decryption (OpenSSL)
* File metadata extraction (ExifTool)
* File listing utilities
* Interactive color-based menu UI

The entire project is implemented in **pure Bash scripting** using standard Linux tools.

---

## 🎯 Features

### 🔡 **1. Caesar Cipher**

* Encrypt text
* Decrypt text
* Encrypt file
* Decrypt file
* Supports both uppercase & lowercase letters

---

### 🔁 **2. ROT13 Cipher**

* Apply ROT13 to text
* Apply ROT13 to files
* Uses built-in `tr` command

---

### 🧬 **3. Base64 Tools**

* Encode text
* Decode Base64 text
* Encode file
* Decode Base64 file
* Uses Linux `base64` command

---

### 🔐 **4. AES-256 File Encryption**

* Encrypt any file using AES-256-CBC
* Decrypt encrypted files
* Password-protected
* Implements PBKDF2 + OpenSSL Salt
* Safe overwrite prompts
* Secure password input (hidden)

---

### 🖼️ **5. Metadata (ExifTool Integration)**

* View all metadata inside images, videos, documents
* Export metadata to a text file
* Requires `exiftool`

---

### 📂 **6. File Listing**

* Simple view of all files in the current directory
* Colorized output using `ls --color`

---

### 🎨 **7. User Interface**

* Fully interactive menu-based CLI
* Color-coded text: Green, Red, Blue, Yellow
* Input validation and file existence checks
* Overwrite confirmation prompts

---

## 📦 Requirements

Your Linux environment should have:

| Dependency | Purpose                       |
| ---------- | ----------------------------- |
| `bash`     | Script execution              |
| `openssl`  | AES-256 encryption/decryption |
| `exiftool` | Metadata extraction           |
| `base64`   | Base64 operations             |
| `tr`       | ROT13                         |

### Install dependencies (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install openssl exiftool
```

---

## 🚀 How to Run

1. Give execution permission:

```bash
chmod +x security_toolkit.sh
```

2. Run the script:

```bash
./security_toolkit.sh
```

3. Use the interactive menus to navigate.

---

## 📁 Project Structure

```
security_toolkit.sh    # Main Bash script
README.md              # Project documentation
```

---

## 🛡️ Security Notes

* AES-256 encryption is strong, but **password strength** depends on the user.
* The script avoids plaintext password echoing for safety.
* Caesar/ROT13/Base64 are **not secure ciphers**, included for educational purposes only.

---

## 🧑‍🎓 Project Details

This project is submitted as part of the **Linux Programming Lab (2025)**
at the **University of Information Technology and Sciences (UITS)**
under the supervision of:
**Md. Tasnin Tanvir**, Lecturer (UITS),
B.Sc in CSE, KUET.

---

## 📜 License

This project is free to use for educational and academic purposes.
