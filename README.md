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
