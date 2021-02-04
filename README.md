[<img alt="Feature Flag, Remote Config and A/B Testing platform, Flagsmith" width="100%" src="https://github.com/Flagsmith/flagsmith-api/raw/master/hero.png"/>](https://flagsmith.com/)

[Flagsmith](https://www.flagsmith.com/) is an open source, fully featured, Feature Flag and Remote Config service. Use our hosted API, deploy to your own private cloud, or run on-premise.

# Flagsmith

Flagsmith makes it easy to create and manage features flags across web, mobile, and server side applications. Just wrap a section of code with a flag, and then use Flagsmith to toggle that feature on or off for different environments, users or user segments.

<img alt="Flagsmith Screenshot" width="100%" src="https://github.com/Flagsmith/flagsmith-api/raw/master/screenshot.png"/>

## Features

* **Feature flags**. Release features with confidence through phased rollouts.
* **Remote config**. Easily toggle individual features on and off, and make changes without deploying new code.
* **A/B and Multivariate Testing**. Use segments to run A/B and multivariate tests on new features. With segments, you can also introduce beta programs to get early user feedback.
* **Organization Management**.  Organizations, projects, and roles for team members help keep your deployment organized.
* **Integrations**. Easily enhance Flagsmith with your favourite tools.

## Using Flagsmith

* **Flagsmith hosted**. You can try our hosted version for free at https://www.flagsmith.com/
* **Flagsmith open source**. The Flagsmith API is built using Python 3, Django 2, and DjangoRestFramework 3. You can begin running the open source application using docker-compose. We also have options fore deploying to AWS, Kubernetes and OpenShift.

## Resources

* [Website](https://www.flagsmith.com/)
* [Documentation](https://docs.flagsmith.com/)
* If you have any questions about our projects you can email [support@flagsmith.com](mailto:support@flagsmith.com)

# Flagsmith in Docker

You can use this repo to set up an entire [Flagsmith Feature Flag](https://www.flagsmith.com) environment locally. Just clone the repo and run docker-compose:

```bash
git clone https://github.com/Flagsmith/flagsmith-docker.git
cd flagsmith-docker
docker-compose up
```

Wait for the images to download and run, then visit `http://localhost:8080/`. As a first step, you will need to create a new account at [http://localhost:8080/signup](http://localhost:8080/signup)

You can create a Django Admin user to get access to the Django admin dashboard with the following command:

```bash
# Make sure you are in the root directory of this repository
docker-compose run --rm --entrypoint ".venv/bin/python src/manage.py createsuperuser" api
```

You can then access the admin dashboard at [http://localhost:8000/admin/](http://localhost:8000/admin/)

## InfluxDB

Flagsmith has a soft dependency on InfluxDB to store time-series data. You dont need to configure Influx to run the platform, but SDK traffic and flag analytics will not work without it being set up and configured correctly. Once your docker-compose is running:

1. Create a user account in influxdb. You can visit http://localhost:8086/ and do this. Create an Initial Bucket with the name `flagsmith_api`
2. Go into Data > Buckets and create a second bucket, `flagsmith_api_downsampled_15m`.
3. Go into Data > Tokens and grab your access token.
4. Edit the `docker-compose.yml` file and add the following `environment` variables in the api service to connect the api to InfluxDB:
    * `INFLUXDB_TOKEN`: The token from the step above
    * `INFLUXDB_URL`: `http://influxdb`
    * `INFLUXDB_ORG`: The organisation ID - you can find it [here](https://docs.influxdata.com/influxdb/v2.0/organizations/view-orgs/)
    * `INFLUXDB_BUCKET`: `flagsmith_api`
5. Restart `docker-compose`
6. Log into InfluxDB, create a new bucket called `flagsmith_api_downsampled_15m`
7. Create a new task with the following query. This will downsample your per millisecond data down to 15 minute blocks for faster queries. Set it to run every 15 minutes.

```
option task = {name: "Downsample", every: 15m}

data = from(bucket: "flagsmith_api")
	|> range(start: -duration(v: int(v: task.every) * 2))
	|> filter(fn: (r) =>
		(r._measurement == "api_call"))

data
	|> aggregateWindow(fn: sum, every: 15m)
	|> filter(fn: (r) =>
		(exists r._value))
	|> to(bucket: "flagsmith_api_downsampled_15m")
```

Once this task has run you will see data coming into the Organisation API Usage area.

## Architecture

The docker-compose file runs the following containers:

### Front End - Port 8080

The Web user interface. From here you can create accounts and manage your flags. The front end is written in node.js and React.

### REST API - Port 8000

The web user interface communicates via REST to the API that powers the application. The SDK clients also connect to this API. The API is written in Django and the Django REST Framework.

Once you have created an account and some flags, you can then start using the API with one of the [Flagsmith Client SDKs](https://github.com/Flagsmith?q=client&type=&language=). You will need to override the API endpoint for each SDK to point to [http://localhost:8000/api/v1/](http://localhost:8000/api/v1/)

You can access the Django Admin console to get CRUD access to some of the core tables within the API. You will need to create a super user account first. More information on how to create the super user account can be found here [https://github.com/Flagsmith/flagsmith-api#locally](https://github.com/Flagsmith/flagsmith-api)

### Postgres Database

The REST API stores all its data within a Postgres database.

## Further Reading

For more information, please visit:

- [Flagsmith Feature Flag Homepage](https://www.flagsmith.com)
- [Flagsmith Documentation](https://docs.flagsmith.com/)
- [Web Front End on GitHub](https://github.com/Flagsmith/flagsmith-frontend)
- [REST API on GitHub](https://github.com/Flagsmith/flagsmith-api)
