# red-discord-server-docker

Docker image for running the [Red discord bot](https://cogs.red/) server. It includes Java 11 for full audio cog support.

----

## Getting Started

It is recomended to use docker compose to run this image as it makes use of secrets to load the Discord bot token.

*Note: There are two image tags available* 
  - `latest` based on `Alpine 3`
  - `ubuntu-latest` based on `Ubuntu 20.04 LTS`

Steps:

- Download the `docker-compose.yml` file
  - Set the fields under `environment` 
- Add a file named `red_discord_token`
  - Paste in the token for your bot
- Run `docker compose up` and wait for the invite URL to be shown
  - Click the invite URL and connect the bot to your server

Storage data will be stored as JSON in the `red` directory beside `docker-compose.yml`.
