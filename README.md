[<img alt="Feature Flag, Remote Config and A/B Testing platform, Bullet Train" width="100%" src="https://github.com/BulletTrainHQ/bullet-train-frontend/raw/master/hero.png"/>](https://bullet-train.io/)

# Bullet Train in Docker

You can use this repo to set up an entire [Bullet Train Feature Flag](https://bullet-train.io) environment locally. Just clone the repo and run docker-compose:

```bash
git clone https://github.com/BulletTrainHQ/bullet-train-docker.git
cd bullet-train-docker
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

Once you have created an account and some flags, you can then start using the API with one of the [Bullet Train Client SDKs](https://github.com/BulletTrainHQ?q=client&type=&language=). You will need to override the API endpoint for each SDK to point to [http://localhost:8000/api/v1/](http://localhost:8000/api/v1/)

You can access the Django Admin console to get CRUD access to some of the core tables within the API. You will need to create a super user account first. More information on how to create the super user account can be found here [https://github.com/BulletTrainHQ/bullet-train-api#locally](https://github.com/BulletTrainHQ/bullet-train-api#locally)

### Postgres Database

The REST API stores all its data within a Postgres database.

## Further Reading

For more information, please visit:

- [Bullet Train Feature Flag Homepage](https://bullet-train.io)
- [Bullet Train Documentation](https://docs.bullet-train.io/)
- [Web Front End on GitHub](https://github.com/BulletTrainHQ/bullet-train-frontend)
- [REST API on GitHub](https://github.com/BulletTrainHQ/bullet-train-api)
