# A serverless app (wip)

This is an example of a serverless app with ci/cd.


## Infrastructure

This is where
- ci/cd
- route53
- s3 buckets
- iam for ci/cd

are defined. Everything is written in `terraform`.

## Learnings
- is there a point even in creating an acm cert in region that is different than `north virginia`?
  From this applications perspective, I do not think so.
