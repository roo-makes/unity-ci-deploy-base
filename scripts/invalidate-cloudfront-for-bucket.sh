#!/bin/sh

BUCKET=$1
PATHS=/${2:-*}

NUM_DISTROS=0

for id in $(aws cloudfront list-distributions --query "DistributionList.Items[*].{id:Id,origin:Origins.Items[0].DomainName}[?starts_with(origin,'$BUCKET.s3.')].id" --output text);
do
  echo "Invalidating \"$PATHS\" on Cloudfront Distribution: $id"
  INVAL_ID=$(aws cloudfront create-invalidation --distribution-id $id --paths "$PATHS" --query "Invalidation.Id" --output text)
  echo "Invalidation accepted: $INVAL_ID"
  ((NUM_DISTROS++))
done

echo "Invalidated $NUM_DISTROS distributions"