# Feedback 

### SQL
For your queries, you've used a `JOIN`, which combines tow tables where they match. Do you _need_ all the columns from the second table?

Another tip, use aliases for your tables - especially when interacting with multiple tables:

```
SELECT u.email, u.phone_number, s.num_items
FROM users u
JOIN sales s
...
```

^^ This makes your select statement much more manageable and readable. Remember, SQL queries are often in conjunction with servers, ratehr than in a file of their own, so they can become quite easily tangled up.

### Servers
Lovely incrementation of tests, and I like the separation of endpoint cases into classes - although I would consider that tadding the filtered information to be part of the endpoint class above.

I would suggest using isinstance over type in general, because it takes into account inheritance, but your use here of type makes complete sense considering that inheritance isn't relevant.

I think there's a slight misunderstanding in your without nuts test - if nuts are allowed, then nuts that both do and do not contain nuts would be within the response (i.e. all of the donuts would be sent!).

Really comprehensive testing suite here - well done.

### Cloud

Really great implementation - you've demonstrated a solid understanding of cloud concepts and how to build things according to the specification. 
