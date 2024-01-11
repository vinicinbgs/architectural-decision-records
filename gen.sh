#!bin/env sh

read -p $'\e[0;34mEnter title of ADR: \e[0m' title
read -p $'\e[0;33mContinue? (y/N): \e[0m' confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

# Template
USERNAME=$(git config user.email)
TODAY=$(date +%Y-%m-%d)
TEMPLATE=$(cat _template.md | sed -e "s/\$(today)/$TODAY/g" | sed -e "s/\$(username)/$USERNAME/g")

# Filename format: 0000-<title>.md
LAST_CREATED_FILE=$(ls -d [0-9]*-[A-Za-z0-9]*.md 2> /dev/null | tail -n 1) 
LAST_CREATED_FILE_NUMBER=$(echo $LAST_CREATED_FILE | cut -d'-' -f 1)

if [ -z "$LAST_CREATED_FILE" ]
then
    FILE_NAME="0000-$title.md"
else
    FILE_NAME=$(printf "%04d" $(expr $LAST_CREATED_FILE_NUMBER + 1))-$title.md
fi

# Create file
echo "$TEMPLATE" > $FILE_NAME
