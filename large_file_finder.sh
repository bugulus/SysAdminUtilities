#!/bin/bash

#chmod +x large_file_finder.sh
#./large_file_finder.sh         # Defaults to 1G
#./large_file_finder.sh 500M    # Use custom size

# ---------- Config ----------
SIZE_THRESHOLD="${1:-1G}"  # Default to 1G if not specified
LOG_FILE="$HOME/large_file_finder.log"
ARCHIVE_DIR="$HOME/large_file_archives"
EXCLUDE_DIRS=("/proc" "/sys" "/dev" "/run" "/tmp")

# ---------- Setup ----------
mkdir -p "$ARCHIVE_DIR"
touch "$LOG_FILE"
echo "Scanning for files over $SIZE_THRESHOLD..." | tee -a "$LOG_FILE"

# ---------- Exclude Arguments ----------
EXCLUDES=()
for dir in "${EXCLUDE_DIRS[@]}"; do
    EXCLUDES+=(-path "$dir" -prune -o)
done

# ---------- Find Large Files ----------
mapfile -t FILES < <(sudo find / "${EXCLUDES[@]}" -type f -size +"$SIZE_THRESHOLD" -print 2>/dev/null)

# ---------- Process Each File ----------
for FILE in "${FILES[@]}"; do
    SIZE=$(du -h "$FILE" | cut -f1)
    echo -e "\n📁 Found: $FILE ($SIZE)"
    echo "What do you want to do?"
    select action in "Archive" "Delete" "Skip"; do
        case $action in
            Archive)
                base=$(basename "$FILE")
                tarball="$ARCHIVE_DIR/${base}.tar.gz"
                tar -czf "$tarball" "$FILE" && echo "Archived to $tarball" | tee -a "$LOG_FILE"
                break
                ;;
            Delete)
                rm -i "$FILE" && echo "Deleted $FILE" | tee -a "$LOG_FILE"
                break
                ;;
            Skip)
                echo "Skipped $FILE" | tee -a "$LOG_FILE"
                break
                ;;
        esac
    done
done

echo -e "\n✅ Done. Log saved to $LOG_FILE"