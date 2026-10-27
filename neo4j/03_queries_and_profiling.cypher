// 03 - Queries, profiling and index optimisation

// Query i: users with a "Nice Question" badge since 2020, and the questions they posted
PROFILE
MATCH (u:Users)-[:ACHIEVED]->(b:Badges), (u)-[:POSTED]->(q:Questions)
WHERE b.name = "Nice Question" AND datetime(b.date) > datetime("2020-01-01T00:00:00")
RETURN u.id, u.display_name, b.name, b.date, q.id, q.title;
// Before indexing: 11 steps, 52,489 total database hits
// (the b.name / b.date filter alone cost 25,036 hits)

// Optimisation: index the two filtered badge properties
CREATE INDEX badge_name FOR (b:Badges) ON (b.name);
CREATE INDEX badge_date FOR (b:Badges) ON (b.date);
// Re-running the PROFILE above after indexing: 10 steps, 34,198 database hits (about 35% fewer)

// Query ii: as above, plus the comments replying to each question
PROFILE
MATCH (u:Users)-[:ACHIEVED]->(b:Badges), (u)-[:POSTED]->(q:Questions), (c:Comments)-[:REPLIED_TO]->(q)
WHERE b.name = "Nice Question" AND datetime(b.date) > datetime("2020-01-01T00:00:00")
RETURN u.id, u.display_name, b.name, b.date, q.id, q.title, c.id;
// With the same indexes: 12 steps, 34,588 database hits
// (the [:POSTED] expansion was the most expensive step at 9,410 hits)

// Query iii: users with the "Inquisitive" badge, their questions and the accepted answers
MATCH (u:Users)-[:ACHIEVED]->(b:Badges), (u)-[:POSTED]->(q:Questions), (q)-[:ACCEPTED_ANS]->(a:Answers)
WHERE b.name = "Inquisitive"
RETURN u.id, u.display_name, b.name, q.id, q.title, a.id;
