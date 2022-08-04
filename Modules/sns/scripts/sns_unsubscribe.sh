#!
# Dependencies: Bash, jq (https://stedolan.github.io/jq/)

subscriptions=$(aws sns list-subscriptions-by-topic --topic-arn "$sns_arn" --profile "$profile" --region "$region" | jq -r '.Subscriptions[].Endpoint')
echo 'Confirmed subscriptions to delete:'
echo $subscriptions

subscriptionsARN=$(aws sns list-subscriptions-by-topic --topic-arn "$sns_arn" --profile "$profile" --region "$region" | jq -r '.Subscriptions[].SubscriptionArn')

echo 'Deleting:'
for arn in $subscriptionsARN; do
  echo $arn
  if [ "$arn" != "PendingConfirmation" ] ; then
    aws sns unsubscribe --subscription-arn "$arn" --profile "$profile" --region "$region"
  fi
done