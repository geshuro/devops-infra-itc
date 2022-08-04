#!/bin/bash
# Dependencies: Bash, jq (https://stedolan.github.io/jq/)

subscriptions=$(aws sns list-subscriptions-by-topic --topic-arn "$sns_arn" --profile "$profile" --region "$region" | jq -r '.Subscriptions[].Endpoint')
echo 'Confirmed subscriptions:'
echo $subscriptions
echo 'Emails to suscribe:'

for email in $sns_emails; do
  echo $email
  suscribed=false
  for i in $subscriptions; do
    if [[ $i = "$email"* ]] ; then
      suscribed=true
      break
    fi
  done
  if [ "$suscribed" = false ] ; then
    aws sns subscribe --topic-arn "$sns_arn" --protocol email --notification-endpoint "$email" --profile "$profile" --region "$region"
  fi
done