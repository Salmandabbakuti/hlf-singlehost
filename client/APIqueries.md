#### Log Events

```
curl -X GET "http://localhost:8080/logEvents?productId=A12345"
```
#### Submit Product

```
curl -d '{"productId":"A12345","ownerName":"Salman", "productName":"Parker Solar Drive"}' -H "Content-Type: application/json" -X POST http://localhost:8080/submitProduct
```

#### Add Event Status

```
curl -d '{"productId":"A12345","status":"Profiling"}' -H "Content-Type: application/json" -X POST http://localhost:8080/addEvent
```
