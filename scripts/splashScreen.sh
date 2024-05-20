#!/bin/bash

# Define color codes and styles
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
ITALIC='\033[3m'
NC='\033[0m' # No Color

# Project title and group member names
TITLE="\n\n${BOLD}${BOLD}${ITALIC}${GREEN}                 ------      ------   TASK MANAGEMENT SYSTEM   ------      ------${NC}\n\n"
NAME="${BOLD}${UNDERLINE}${MAGENTA}                          **********    Group Members    **********${NC}\n\n"
N1="${BOLD}${BLUE}                            ** NAFEESA YOUSAF   **          FL-21503 ${NC}\n"
N2="${BOLD}${BLUE}                            -- NAYAB HAMEED     --          FL-21495${NC}\n"
N3="${BOLD}${BLUE}                            ** MAHAM SHAHID     **          FL-21506 ${NC}\n"
N4="${BOLD}${BLUE}                            -- ABU HURAIRA      --          FL-21535${NC}\n"

# Display the project title with color and style
echo -e "$TITLE"
echo -e "$NAME"
echo -e "$N1"
echo -e "$N2"
echo -e "$N3"
echo -e "$N4"
sleep 3 
bash  "$SCRIPT_PATH"login.sh;