// 04 - Extending the model with "collections" (topics), built from question tags

// Create one Collections node per distinct tag (tags are stored as "tag1|tag2|...")
MATCH (q:Questions)
WITH DISTINCT q.tags AS collections
UNWIND split(collections, "|") AS collection
MERGE (c:Collections {name: collection});

// Link each question to its collections
MATCH (q:Questions)
UNWIND split(q.tags, "|") AS collection
MATCH (c:Collections {name: collection})
MERGE (q)-[:IN_COLLECTION]->(c);

// Answers have no tags, so they inherit the collections of the question they answer
MATCH (q:Questions)-[:IN_COLLECTION]->(c:Collections)
MATCH (a:Answers)-[:ANS_TO]->(q)
MERGE (a)-[:IN_COLLECTION]->(c);
