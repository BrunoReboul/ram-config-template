# gcs_storage_location to_be_adapted

## Background

Cloud storage bukets location have to comply with data soveriegnty regulation.

When you create a bucket, you permanently define its name, its geographic location, and the project it is part of.

## Fix

The bucket location cannot be changed. Create a new bucket in a compliant location, copy storage objects, delete the non compliant bucket.

```shell
gcloud projects create
gcloud app create [--region=REGION]
gcloud projects delete
```

## References

- [Data sovereignty](https://en.wikipedia.org/wiki/Data_sovereignty)
- [GDPR General Data Protection Regulation](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32016R0679)
- [Bucket locations](https://cloud.google.com/storage/docs/locations#available_locations)
- [Moving and renaming buckets](https://cloud.google.com/storage/docs/moving-buckets)
