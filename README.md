[<img alt="Feature Flag, Remote Config and A/B Testing platform, Bullet Train" width="100%" src="https://github.com/BulletTrainHQ/bullet-train-frontend/raw/master/hero.png"/>](https://bullet-train.io/)

# Bullet Train in Docker

You can use this repo to set up an entire [Bullet Train Feature Flag](https://bullet-train.io) environment locally. Just clone the repo and run docker-compose:

```bash
git clone https://github.com/BulletTrainHQ/bullet-train-docker.git
cd bullet-train-docker
docker-compose up
```

Wait for the images to download and run, then visit `http://localhost:8080/`. As a first step, you will need to create a new account.
More information how to it, are here https://github.com/BulletTrainHQ/bullet-train-api#locally

## Architecture

The docker-compose file runs the following containers:

### Front End

The Web user interface. From here you can create accounts and manage your flags. The front end is written in node.js and React.

### REST API

The web user interface communicates via REST to the API that powers the application. The SDK clients also connect to this API. The API is written in Django and the Django REST Framework.

### Postgres Database

The REST API stores all its data within a Postgres database.

## Further Reading

For more information, please visit:

- [Bullet Train Feature Flag Homepage](https://bullet-train.io)
- [Bullet Train Documentation](https://docs.bullet-train.io/)
- [Web Front End on GitHub](https://github.com/BulletTrainHQ/bullet-train-frontend)
- [REST API on GitHub](https://github.com/BulletTrainHQ/bullet-train-api)
