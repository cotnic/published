// Create NODE
CREATE (e:Person { name: "Emil", from: "Sweden", klout: 99 })

// Search for person that is from Sweden
MATCH (a:Person)
WHERE a.from = "Sweden"
RETURN a

// Create nodes and relationships
MATCH (ee:Person) WHERE ee.name = "Emil"
CREATE (js:Person { name: "Johan", from: "Sweden", learn: "surfing" }),
(ee)-[:KNOWS {since: 2001}]->(js)

// Create nodes and relationships
MATCH (ee:Person) WHERE ee.name = "Emil"
CREATE (ir:Person { name: "Ian", from: "England", title: "author" }),
(rvb:Person { name: "Rik", from: "Belgium", pet: "Orval" }),
(ally:Person { name: "Allison", from: "California", hobby: "surfing" }),
(ee)-[:KNOWS {rating: 5}]->(ir),
(rvb)-[:KNOWS]->(ally)

// Create relatioship between two unrelated nodes
MATCH (n), (m)
WHERE n.name = "Allison" AND m.name = "Emil"
CREATE (n)-[:KNOWS]->(m)

// can also be done with MERGE
MATCH (n:User {name: "Allison"}), (m:User {name: "Emil"})
MERGE (n)-[:KNOWS]->(m)

// get all current Person nodes
MATCH (n:Person) 
RETURN n

// get all persons that Allison knows two hops deep
MATCH (Person { name: 'Allison' })-[:KNOWS*1..2]-(pe:Person)
RETURN (pe)

// create Node with multiple labels
CREATE (n:Actor:Director { place: "Hollywood" })

// search for nodes with specific labels
MATCH (n)
WHERE n:Actor:Director
RETURN n

// Update node new or modifiy
MATCH (n)
WHERE n.name = "Rik"
SET n.owns = "Audi"

// Replace all node properties
MATCH (n)
WHERE n.name = "Rik"
SET n = {name = "Rik", plays: "Piano", age: 23}

// Add new properties without deleting old
MATCH (n)
WHERE n.name = "Allison"
SET n += {plays: "Piano", age: 23}

// Add new node property if property not already SET
MATCH (n)
WHERE n.plays = "Piano" AND NOT (EXISTS (n.likes))
SET n.likes = "Movies"

// Rename a property in NODE
MATCH (n)
WHERE n.instrument is null
SET n.instrument = n.plays
REMOVE n.plays

// DELETE nodes
// first we have to delete relationships
MATCH (n)-[r]-()
WHERE n.likes = "Movies"
DELETE r, n

// Delete property in a specific node
MATCH (n)
WHERE n:Person AND n.name = "Rik" AND EXISTS (n.plays)
REMOVE n.plays

// Delete a label from specific nodes
MATCH (n)
WHERE n:Actor:Director
REMOVE n:Actor

// Count all nodes
MATCH (n)
RETURN count(n)

// Count all relationships
MATCH ()-->()
RETURN count(*);

// Limit for up to 2 nodes
MATCH (a:Person)
WHERE a.from = "Sweden"
RETURN a
LIMIT 2

// Delete all database
MATCH (n)
OPTIONAL MATCH (n)-[r]-()
DELETE n, r