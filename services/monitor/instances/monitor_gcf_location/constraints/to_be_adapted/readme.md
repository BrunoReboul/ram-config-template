# monitor_gcf_location to_be_adapted

## Background

Cloud Functions location have to comply with data soveriegnty regulation

## Fix

The location is choosen at deployment time.

```shell
gcloud functions deploy FUNCTION_NAME --region REGION FLAGS...
```

## References

- [Data sovereignty](https://en.wikipedia.org/wiki/Data_sovereignty)
- [GDPR General Data Protection Regulation](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32016R0679)
- [Cloud Functions locations](https://cloud.google.com/functions/docs/locations)
- [Deploy your Cloud Function in a location](https://cloud.google.com/functions/docs/locations#selecting_the_region)
