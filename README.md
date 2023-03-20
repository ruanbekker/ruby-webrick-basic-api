# ruby-webrick-basic-api
Ruby Webrick

## Run the Server

Using docker:

```bash
docker run -it -p 8080:8080 ruanbekker/ruby-api
```

## Make Requests

List all items:

```bash
$ curl -H 'Content-Type: application/json' -XGET http://localhost:8080/api
{
    "items":[]
}
```

Create Items:

```bash
$ curl -H 'Content-Type: application/json' -XPOST http://localhost:8080/api -d '{"name": "spotify", "description": "music streaming service"}'
$ curl -H 'Content-Type: application/json' -XPOST http://localhost:8080/api -d '{"name": "netflix", "description": "tv streaming service"}'
```

List all items:

```bash
$ curl -H 'Content-Type: application/json' -XGET http://localhost:8080/api
{
    "items": [
        {"id":1,"name":"spotify","description":"music streaming service"},
        {"id":2,"name":"netflix","description":"tv streaming service"}
    ]
}
```

Update Item:

```bash
$ curl -H 'Content-Type: application/json' -XPUT http://localhost:8080/api -d '{"id": 2, "name": "netflix", "description": "tv streaming service..."}'
```

Delete Item:

```bash
$ curl -H 'Content-Type: application/json' -XDELETE http://localhost:8080/api -d '{"id": 2}'
```

## Routes

- GET    /api
- POST   /api, body: {'name': 'james', 'description': 'foobar'}
- UPDATE /api, body: {'id': 1, 'name': 'james', 'description': 'foobar'}
- DELETE /api, body: {'id': 1}