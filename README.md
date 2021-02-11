# Qulture API

[![Build Status](https://circleci.com/gh/renatamarques97/qulture-api.svg?style=svg)](https://app.circleci.com/pipelines/github/renatamarques97/qulture-api)

### Ruby version
```
2.7.1
```

### Rails version
```
6.1.1
```

### Configuration
```shell
bundle install
yarn install
```

### Database creation
```shell
bundle exec rails db:create
bundle exec rails db:migrate
```

### Initialize postgres
```shell
pg_ctl start
```

### How to run the test suite
```shell
bundle exec rspec
```

### Coverage
```
115 examples, 0 failures. (100.0%) covered.
```

### Run the server
```shell
bundle exec rails s
```

See `http://localhost:3000/`

## Documentation

- The root is ___"api/v1/companies#index"___

### Company

#### POST /api/v1/companies
- Action: ___api/v1/companies#create___
- Required fields:
	- ___name___ (String)
- Optional fields:
	- ___collaborators_attributes___ (Array of collaborators attributes)
- Request body:
	1. Without nested collaborators:
	```json
	{
		"company": {
			"name": "Company Name"
		}
  }
	```
	2. With nested collaborators:
	```json
	{
		"company": {
			"name": "Company Name",
			"collaborators_attributes": [
				{ "name": "Collab 1", "email": "collaborator1@example.com" },
				{ "name": "Collab 2", "email": "collaborator2@example.com" },
				{ "name": "Collab 3", "email": "collaborator3@example.com" }
			]
		}
  }
	```
- Expected response:
	```json
	{
		"id": "1",
		"name": "Company Name"
	}		
	```

#### GET /api/v1/companies
- Action: ___api/v1/companies#index___
- Expected response:
	```json
	[
		{
			"id": "1",
			"name": "Company 1"
		},
		{
			"id": "2",
			"name": "Company 2"
		}
	]
	```

#### GET /api/v1/companies/:company_id
- Action: ___api/v1/companies#show___
- Expected response:
	```json
	{
		"id": "1",
		"name": "Company 1",
		"collaborators": [
			{
				"id": "1",
				"name": "Collab 1",
				"email": "collab1@example.com",
				"manager_id": null
			},
			{
				"id": "2",
				"name": "Collaborator 2",
				"email": "collaborator2@example.com",
				"manager_id": "1"
			}
		]
	}
	```

### Collaborator

#### POST /api/v1/companies/:company_id/collaborators
- Action: ___api/v1/collaborators#create___
- Required fields:
	- ___name___ (String)
	- ___email___ (String)
- Request body:
	```json
	{
		"collaborator": {
			"name": "Collaborator 1",
			"email": "collaborator1@example.com"
		}
  }
	```
- Expected response:
	```json
	{
		"id": "1",
		"name": "Collaborator 1",
		"email": "collaborator1@example.com",
		"manager_id": null,
		"company_id": "1"
	}		
	```

#### GET /api/v1/companies/:company_id/collaborators
- Action: ___api/v1/collaborators#index___
- Expected response:
	```json
	[
		{
			"id": "1",
			"name": "Collaborator 1",
			"email": "collaborator1@example.com",
			"manager_id": null,
			"company_id": "1"
		},
		{
			"id": "2",
			"name": "Collaborator 2",
			"email": "collaborator2@example.com",
			"manager_id": null,
			"company_id": "1"
		}
	]
	```

#### DELETE /api/v1/collaborators/:collaborator_id
- Action: ___api/v1/collaborators#destroy___
- Expected response:
	```json
	{
		"id": "1",
		"name": "Collaborator 1",
		"email": "collaborator1@example.com",
		"manager_id": null,
		"company_id": "1"
	}		
	```

#### PUT/PATCH /api/v1/collaborators/:collaborator_id
- Action: ___api/v1/collaborators#update___
- Required fields:
	- ___manager_id___ (String)
- Request body:
	```json
	{
		"manager_id": "1"
    }
	```
- Expected response:
	```json
	{
		"id": "2",
		"name": "Collaborator 2",
		"email": "collaborator2@example.com",
		"manager_id": "1",
		"company_id": "1"
	}
	```

#### GET /api/v1/collaborators/:collaborator_id?collab_info=[___collab_info___]
- Action: ___api/v1/collaborators#show___
- Query parameters:
	- ___collab_info___ (String -> [node, managed, second_managed])
- Expected response:
	```json
	[
		{
			"id": "1",
			"name": "Collaborator 1",
			"email": "collaborator1@example.com",
			"manager_id": null,
			"company_id": "1"
		},
		{
			"id": "2",
			"name": "Collaborator 2",
			"email": "collaborator2@example.com",
			"manager_id": "1",
			"company_id": "1"
		}
	]
	```

### Authors

[Renata Marques](https://www.linkedin.com/in/renata-marques-b27877119/)
