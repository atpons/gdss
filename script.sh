DB_TOKEN=replace_with_your_dropbox_token
GDSS_FILENAME=gdss_$(date +%s).png
screencapture -i /tmp/$GDSS_FILENAME

if [[ -f /tmp/$GDSS_FILENAME ]]; then
  curl -X POST https://content.dropboxapi.com/2/files/upload \
      --header "Authorization: Bearer $DB_TOKEN" \
      --header "Dropbox-API-Arg: {\"path\": \"/$GDSS_FILENAME\"}" \
      --header "Content-Type: application/octet-stream" \
      --data-binary @/tmp/$GDSS_FILENAME 2&>1 /dev/null

  GDSS_URL=`curl -X POST https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings \
      --header "Authorization: Bearer $DB_TOKEN" \
    --header 'Content-Type: application/json' \
    --data "{\"path\": \"/$GDSS_FILENAME\"}" | python -c "import sys, json; print(json.load(sys.stdin)['url'])"`

  echo $GDSS_URL | pbcopy
  open $GDSS_URL

  rm -f /tmp/$GDSS_FILENAME
fi
